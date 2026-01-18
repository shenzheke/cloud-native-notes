#!/bin/bash
set -e

ES_HOST="10.0.0.5"
KIBANA_IP="10.0.0.5"
ELASTIC_PASS="你的elastic密码"  # 替换！

echo "=== 部署 Kibana 8.19 ==="

# 1. 下载并解压
wget -q https://artifacts.elastic.co/downloads/kibana/kibana-8.19.0-linux-x86_64.tar.gz
tar -xzf kibana-8.19.0-linux-x86_64.tar.gz
sudo rm -rf /usr/share/kibana
sudo mv kibana-8.19.0 /usr/share/kibana

# 2. 创建用户
sudo useradd --system --shell /sbin/nologin kibana || true

# 3. 证书目录
sudo mkdir -p /etc/kibana/certs
sudo cp /etc/elasticsearch/certs/elastic-stack-ca.crt /etc/kibana/certs/
sudo chown -R kibana:kibana /etc/kibana/certs

# 4. 生成 Kibana 自签证书
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/kibana/certs/kibana.key \
  -out /etc/kibana/certs/kibana.crt \
  -subj "/CN=kibana" 2>/dev/null

# 5. kibana.yml
sudo tee /usr/share/kibana/config/kibana.yml > /dev/null <<EOF
server.port: 5601
server.host: "0.0.0.0"
server.ssl.enabled: true
server.ssl.certificate: /etc/kibana/certs/kibana.crt
server.ssl.key: /etc/kibana/certs/kibana.key

elasticsearch.hosts: ["https://10.0.0.5:9200"]
elasticsearch.username: "elastic"
elasticsearch.password: "${ELASTIC_PASS}"
elasticsearch.ssl.certificateAuthorities: ["/etc/kibana/certs/elastic-stack-ca.crt"]
elasticsearch.ssl.verificationMode: certificate

xpack.security.enabled: true
xpack.encryptedSavedObjects.encryptionKey: $(openssl rand -base64 32 | tr -d '=+/' | cut -c1-32)
EOF

# 6. systemd 服务（关键：用 tee + heredoc 避免 CRLF）
sudo tee /etc/systemd/system/kibana.service > /dev/null <<'EOF'
[Unit]
Description=Kibana

[Service]
User=kibana
Group=kibana
WorkingDirectory=/usr/share/kibana
ExecStart=/usr/share/kibana/bin/kibana
Restart=always
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOF

# 7. 启动
sudo systemctl daemon-reload
sudo systemctl enable --now kibana

echo "Kibana 启动成功！访问：https://$KIBANA_IP:5601"
echo "用户名：elastic   密码：$ELASTIC_PASS"