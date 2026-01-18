#!/bin/bash

# 定义主机列表
hosts=(
    "lb02"
    "web01"
    "web02"
    "sweb01"
    "sweb02"
    "db01"
)

# 定义源文件路径
cert_file="/etc/elasticsearch/certs/elastic-cert.pem"
ca_file="/etc/elasticsearch/certs/elastic-stack-ca.pem"
key_file="/etc/elasticsearch/certs/elastic-cert.key"

# 目标路径
target_dir="/etc/elasticsearch/certs/"

# 循环遍历主机并使用 SCP 发送证书
for host in "${hosts[@]}"; do
    echo "Sending certificates to $host..."
    
    # 使用 SCP 复制文件到目标主机的指定目录
    scp "$cert_file" "$host:$target_dir"
    scp "$ca_file" "$host:$target_dir"
    scp "$key_file" "$host:$target_dir"
    
    if [[ $? -eq 0 ]]; then
        echo "Certificates successfully sent to $host"
    else
        echo "Failed to send certificates to $host"
    fi
done

echo "All transfers complete."
