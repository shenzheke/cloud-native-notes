# 生成密码（用户名 admin，密码随便改）
htpasswd -nb admin rootroot. | tr -d '\n' | base64
#### 或直接用 kubectl 创建(不推荐，推荐用yaml文件创建)
kubectl create secret generic traefik-dashboard-auth-secret \
  --from-literal=users=admin:$$apr1$$...   # 用 htpasswd 生成的字符串，注意 $$ 转义
  -n traefik
