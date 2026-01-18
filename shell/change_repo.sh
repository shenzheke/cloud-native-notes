#!/bin/bash

# Rocky Linux 9 更换国内源脚本
# 支持 Rocky 9.x 版本（如 9.6）
# 默认使用阿里云镜像，可修改 MIRROR_URL 变量切换其他源

set -e  # 遇到错误立即退出

# 配置镜像源 URL（修改这里切换源）
MIRROR_URL="https://mirrors.aliyun.com/rockylinux"

echo "开始更换 Rocky Linux 9 为国内镜像源：$MIRROR_URL"

# 检查是否为 root 用户
if [ "$EUID" -ne 0 ]; then
    echo "请使用 sudo 运行此脚本"
    exit 1
fi

# 备份原有 repo 文件
echo "备份原有 repo 文件..."
for file in /etc/yum.repos.d/rocky*.repo; do
    if [ -f "$file" ]; then
        cp "$file" "${file}.bak.$(date +%Y%m%d_%H%M%S)"
    fi
done

# 替换所有 rocky*.repo 文件（Rocky 9 文件名小写 r）
echo "替换 repo 配置..."
sed -i \
    -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e "s|^#baseurl=http://dl.rockylinux.org/\$contentdir|baseurl=${MIRROR_URL}|g" \
    /etc/yum.repos.d/rocky*.repo

# 清理缓存并重建
echo "清理缓存并重建..."
dnf clean all
dnf makecache

echo "更换完成！"
echo "仓库列表："
dnf repolist
echo "测试更新：dnf update -y （可选）"