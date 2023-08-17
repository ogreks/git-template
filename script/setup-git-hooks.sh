#!/bin/sh

# 获取项目根目录
ROOT_DIR=$(git rev-parse --show-toplevel)

# 创建 .git/hooks 目录，如果它还不存在的话
mkdir -p $ROOT_DIR/.git/hooks

# 遍历 /script/git-helper/ 目录下的所有 .sh 文件
for file in $ROOT_DIR/script/git-hooks/*.sh; do
    # 获取文件的基本名（不包括路径和扩展名）
    base_name=$(basename $file .sh)

    # 将文件设置为 git hook
    cp $file $ROOT_DIR/.git/hooks/$base_name

    # 使 git hook 可执行
    chmod +x $ROOT_DIR/.git/hooks/$base_name
done

echo "Git hooks have been set up successfully."