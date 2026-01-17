# 创建 registry 配置目录
mkdir -p /etc/containerd/certs.d/registry.k8s.io

# 写 hosts.toml（核心文件）
vim /etc/containerd/certs.d/registry.k8s.io/hosts.toml


#内容如下：

server = "https://registry.k8s.io"

[host."https://registry.aliyuncs.com"]
  capabilities = ["pull", "resolve"]

#解释：server：逻辑上的官方仓库		host：真正访问的国内镜像源

#告诉 containerd 使用 config_path


vim /etc/containerd/config.toml


#找到：

[plugins."io.containerd.grpc.v1.cri".registry]


#改成（或确认存在）：

[plugins."io.containerd.grpc.v1.cri".registry]
  config_path = "/etc/containerd/certs.d"
