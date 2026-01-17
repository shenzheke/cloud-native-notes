# 备份
mkdir -p ~/pki-backup
cp -r /etc/kubernetes/pki/* ~/pki-backup/

# 移动旧 apiserver 证书，强制生成新的
mv /etc/kubernetes/pki/apiserver.crt /etc/kubernetes/pki/apiserver.crt.bak
mv /etc/kubernetes/pki/apiserver.key /etc/kubernetes/pki/apiserver.key.bak

# 生成新的 apiserver 证书，包含 VIP
kubeadm init phase certs apiserver --config kubeadm-config.yaml

# 重启 kubelet，让 apiserver pod 使用新证书
systemctl restart kubelet


sed -i 's/10.0.0.61/10.0.0.168/' /etc/kubernetes/admin.conf
sed -i 's/10.0.0.61/10.0.0.168/' /etc/kubernetes/kubelet.conf



#同步把.kube/config也覆盖
