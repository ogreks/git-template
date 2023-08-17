## Git Template

> 提交git学习记录模板、规范项目提交自动化探索

### 关于Git钩子

- `script/git-hooks/*`: 此文件夹内脚本作为GitHook相匹配的脚本检查

#### 如何使用

1. 克隆仓库之后： `git clone <仓库地址>`
2. 进入仓库目录：`cd <仓库地址>`
3. 设置Git钩子：`sh script/setup-git-hooks.sh`

* 注意以上步骤会覆盖当前本地设置的 Git 钩子，上述操作推荐使用git-bash命令行(***限windows**)