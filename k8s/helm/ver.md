#Kubernetes: 1.29.8
#Helm:         3.17.x 或 3.18.x
#Traefik Proxy: 3.5.x 或 3.6.x
#Traefik Helm Chart: v34.x – v37.x

cd /tmp
wget https://get.helm.sh/helm-v3.17.3-linux-amd64.tar.gz
tar -zxvf helm-v3.17.3-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
chmod +x /usr/local/bin/helm

#开启 Helm 命令补全（强烈推荐）
helm completion bash > /etc/bash_completion.d/helm
source /etc/bash_completion.d/helm





# 加仓库
helm repo add traefik https://traefik.github.io/charts
helm repo update

# 创建命名空间
kubectl create ns traefik

# 安装 Traefik（默认）
helm install traefik traefik/traefik --namespace traefik

# OR需要指定 Chart 版本：
helm install traefik traefik/traefik \
  --namespace traefik \
  --version 37.4.0

