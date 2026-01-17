
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

kubectl create namespace argocd

helm install argocd argo/argo-cd --namespace argocd --version 9.3.2



| 项目             | 状态           |
| -------------- | ------------ |
| Kubernetes     | 1.29.8（新）    |
| Argo CD 3.2.x  |  **官方当前主线** |
| Argo CD 2.13.x | LTS / 稳定维护   |
| Argo CD 3.x    | 新架构 + 新能力    |

#获取初始密码
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# openssl.cnf
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = v3_req

[dn]
CN = argocd-server

[v3_req]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = argocd-server
DNS.2 = argocd-server.argocd
DNS.3 = argocd-server.argocd.svc
DNS.4 = argocd-server.argocd.svc.cluster.local
DNS.5 = argocd.devops.com
IP.1 = 10.96.0.1   # 可选：如果你通过 ClusterIP 访问


openssl req -x509 -new -nodes -keyout argocd.key -out argocd.crt -days 365 -config openssl.cnf -extensions v3_req



helm upgrade argocd argo/argo-cd \
  --namespace argocd \
  --version 9.3.2 \
  -f values.yaml


#查看版本
kubectl -n argocd get deploy argocd-server -o jsonpath='{.spec.template.spec.containers[0].image}'


kubectl edit configmap argocd-cmd-params-cm -n argocd
#在 data 下面加入（如果 data 不存在就新建）：
data:
  server.insecure: "true"
#保存后重启 pod
kubectl -n argocd rollout restart deployment argocd-server

#客户端在管理页面下载,argocd-server svc ip addr 与argocd.devops.com在hosts文件做好映射
chmod +x argocd-linux-amd64
mv argocd-linux-amd64 /usr/local/bin/argocd

argocd login argocd.devops.com
