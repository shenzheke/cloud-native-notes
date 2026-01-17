version 3.27.4
# 1. 下载 3.27.4 版本的 calico.yaml
# 注意：官方仓库路径格式是 v3.27.4
curl https://raw.githubusercontent.com/projectcalico/calico/v3.27.4/manifests/calico.yaml -O

# 2. 修改 CIDR 为你想要的 10.244.0.0/16（默认是 192.168.0.0/16）
# 用 sed 一行搞定（推荐）：
sed -i 's|192.168.0.0/16|10.244.0.0/16|g' calico.yaml

# 或者用 vim / nano 手动找下面这几行取消注释并修改：
#      - name: CALICO_IPV4POOL_CIDR
#        value: "10.244.0.0/16"

# 3. 应用（强烈建议先 --dry-run=client 预览）
kubectl apply -f calico.yaml

# 4. 等待就绪（通常 1-3 分钟）
kubectl get pods -n kube-system | grep calico
