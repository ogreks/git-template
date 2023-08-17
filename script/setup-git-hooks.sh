#!/bin/sh

# 默认的 Git 仓库位置是当前目录
repo_dir="."
lib_dir=""

# 获取当前脚本的绝对路径
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 解析命令行选项
while getopts p:l:h option
do
    case "${option}" in
        p) repo_dir=${OPTARG};;
        l) lib_dir=${OPTARG};;
        h) echo "Usage: setup-git-hooks.sh [-p <path>] [-l <lib>] [-h]"
           echo "  -p: Set the path of the Git repository. Default is the current directory."
           echo "  -l: Set the name of the library of custom git hooks inside script/git-hooks/."
           echo "  -h: Show this help message."
           exit 0;;
        *) echo "Error: Unknown option ${option}"
           exit 1;;
    esac
done

# 检查是否安装了 git
if ! command -v git >/dev/null 2>&1; then
    echo "Error: git is not installed." >&2
    exit 1
fi

# 检查用户指定的路径是否存在，如果不存在，创建它
mkdir -p "$repo_dir"

# 获取项目根目录
ROOT_DIR=$(cd "$repo_dir" && pwd)

# 检查 .git 文件夹是否存在
if [ ! -d "$ROOT_DIR/.git" ]; then
    # 如果不存在，使用 git init 命令初始化 Git 仓库
    git init "$ROOT_DIR"
fi

# 创建 .git/hooks 目录，如果它还不存在的话
mkdir -p "$ROOT_DIR/.git/hooks"

# 遍历 script/git-hooks/ 目录下的所有 .sh 文件
if ls "$SCRIPT_DIR/git-hooks/"*.sh 1> /dev/null 2>&1; then
    for file in "$SCRIPT_DIR/git-hooks/"*.sh; do
        # 获取文件的基本名（不包括路径和扩展名）
        base_name=$(basename "$file" .sh)

        # 如果用户指定了一个库，并且这个库中存在一个同名的脚本，那么使用这个脚本替换默认的脚本
        if [ -n "$lib_dir" ] && [ -f "$SCRIPT_DIR/git-hooks/$lib_dir/$base_name.sh" ]; then
            file="$SCRIPT_DIR/git-hooks/$lib_dir/$base_name.sh"
        fi

        # 将文件设置为 git hook
        cp "$file" "$ROOT_DIR/.git/hooks/$base_name"

        # 使 git hook 可执行
        chmod +x "$ROOT_DIR/.git/hooks/$base_name"
    done
fi

# 如果用户指定了一个库，遍历库目录下的所有 .sh 文件
if [ -n "$lib_dir" ] && ls "$SCRIPT_DIR/git-hooks/$lib_dir/"*.sh 1> /dev/null 2>&1; then
    for file in "$SCRIPT_DIR/git-hooks/$lib_dir/"*.sh; do
        # 获取文件的基本名（不包括路径和扩展名）
        base_name=$(basename "$file" .sh)

        # 将文件设置为 git hook
        cp "$file" "$ROOT_DIR/.git/hooks/$base_name"

        # 使 git hook 可执行
        chmod +x "$ROOT_DIR/.git/hooks/$base_name"
    done
fi

echo "Git hooks have been set up successfully."