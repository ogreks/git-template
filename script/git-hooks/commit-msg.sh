#!/bin/sh

# 定义正则表达式
regex="^(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)(\(.+\))?: .+"

# 读取每个推送的引用
while read oldrev newrev refname; do
    # 获取新引用的所有提交
    commits=$(git rev-list $oldrev..$newrev)

    # 检查每个提交的提交信息
    for commit in $commits; do
        # 获取提交信息
        msg=$(git log --format=%B -n 1 $commit)

        # 检查提交信息是否符合规范
        if [[ ! $msg =~ $regex ]]; then
            echo "提交 $commit 不遵循常规提交准则。请参考：(常规提交规范)[https://www.conventionalcommits.org/en/v1.0.0/#summary]"
            exit 1
        fi
    done
done