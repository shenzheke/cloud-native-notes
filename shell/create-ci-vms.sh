#!/bin/bash
# 批量创建CI实验环境VM - PVE8.4 + Cloud-Init

# 模板与基本参数
TEMPLATE_ID=100
BRIDGE=vmbr0
STORAGE=local-lvm
HOSTFILE=/root/vm_ip_host.txt

# 映射表
declare -A VMS=(
  [200]="gitlab 10.0.0.200 4 8192"
  [201]="jenkins 10.0.0.201 4 6144"
  [202]="nexus 10.0.0.202 2 4096"
  [203]="sonar 10.0.0.203 4 6144"
)

# 公共hosts内容（固定部分）
read -r -d '' COMMON_HOSTS << 'EOF'
10.0.0.5 lb01
10.0.0.6 lb02
10.0.0.7 web01
10.0.0.8 web02
10.0.0.9 sweb01
10.0.0.10 sweb02
10.0.0.31 nfs01
10.0.0.41 backup
10.0.0.51 db01
10.0.0.61 m01
EOF

# snippets目录
SNIPPET_DIR="/var/lib/vz/snippets"
mkdir -p "$SNIPPET_DIR"

# 清空历史输出文件
echo -n "" > "$HOSTFILE"

# 循环创建
for VMID in "${!VMS[@]}"; do
  set -- ${VMS[$VMID]}
  HOSTNAME=$1
  IP=$2
  CPU=$3
  MEM=$4

  echo "🚀 创建 VM$VMID ($HOSTNAME, $IP)..."

  # 生成 cloud-init 文件
  USERDATA_FILE="$SNIPPET_DIR/${HOSTNAME}-cloudinit.yml"
  cat > "$USERDATA_FILE" <<EOF
#cloud-config
hostname: ${HOSTNAME}
fqdn: ${HOSTNAME}.local
manage_etc_hosts: true
users:
  - name: root
    plain_text_passwd: 'rootroot.'
    lock_passwd: false
    shell: /bin/bash
  - name: ${HOSTNAME}
    gecos: "${HOSTNAME} user"
    shell: /bin/bash
    plain_text_passwd: '${HOSTNAME}'
    lock_passwd: false
    sudo: ALL=(ALL) NOPASSWD:ALL
ssh_pwauth: true
disable_root: false
chpasswd:
  expire: false
timezone: Asia/Shanghai
runcmd:
  - echo "配置 /etc/hosts"
  - |
    cat > /etc/hosts <<'EOT'
127.0.0.1   localhost
${COMMON_HOSTS}
10.0.0.200 gitlab
10.0.0.201 jenkins
10.0.0.202 nexus
10.0.0.203 sonar
EOT
# 修复：使用ip route命令，兼容Ubuntu/Debian/RHEL
  - ip route add default via 10.0.0.1 dev \$(ip route | grep -v default | awk '{print \$3}' | head -1)
  - echo "VM ${HOSTNAME} 初始化完成"
EOF

  # 克隆模板
  qm clone $TEMPLATE_ID $VMID --name $HOSTNAME --full true

  # 资源配置
  qm set $VMID --cores $CPU --memory $MEM --net0 virtio,bridge=$BRIDGE

  # Cloud-init 网络、用户配置
  qm set $VMID --ipconfig0 ip=${IP}/24,gw=10.0.0.1
  qm set $VMID --ciuser root --cipassword 'rootroot.'
  qm set $VMID --nameserver 192.168.2.1
  qm set $VMID --cicustom "user=local:snippets/${HOSTNAME}-cloudinit.yml"

  # 启动
  qm start $VMID

  echo "${IP}  ${HOSTNAME}" >> "$HOSTFILE"

  echo "✅ $HOSTNAME 创建完成。"
done

echo
echo "🎯 所有虚拟机创建完成！IP与主机名已保存至：$HOSTFILE"
cat "$HOSTFILE"
