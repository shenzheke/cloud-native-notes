#!/bin/bash
# 回滚 Web 部署版本脚本
# 执行环境：Web 服务器（10.0.0.7）
# 目录结构：
#   /code/web1
#   /code/web2
#   /code/web3
#   ...
#   /code/html -> /code/web3  (当前版本)

CODE_DIR="/code"
LINK_NAME="${CODE_DIR}/html"

# 获取当前软链接指向的目录
current_version=$(readlink -f "$LINK_NAME" 2>/dev/null)

if [ -z "$current_version" ]; then
    echo "❌ 未找到当前版本软链接：$LINK_NAME"
    exit 1
fi

echo "当前版本：$current_version"

# 获取所有已发布版本（按时间或数字排序）
versions=($(ls -dt ${CODE_DIR}/web* 2>/dev/null))

if [ ${#versions[@]} -lt 2 ]; then
    echo "⚠️ 没有可回滚的旧版本（仅检测到一个版本）"
    exit 1
fi

# 找出当前版本在数组中的位置
for ((i=0; i<${#versions[@]}; i++)); do
    if [[ "${versions[$i]}" == "$current_version" ]]; then
        current_index=$i
        break
    fi
done

# 判断是否有上一个版本
if [ -z "$current_index" ] || [ "$current_index" -eq $((${#versions[@]} - 1)) ]; then
    echo "⚠️ 没有更旧版本可回滚。"
    exit 1
fi

rollback_version="${versions[$((current_index + 1))]}"

echo "准备回滚到版本：$rollback_version"

# 更新软链接
ln -sfn "$rollback_version" "$LINK_NAME"

echo "✅ 回滚完成！"
echo "当前软链接：$(readlink -f $LINK_NAME)"
