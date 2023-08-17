## Git Template

> 提交git学习记录模板、规范项目提交自动化探索

### 关于Git钩子

- `script/git-hooks/*`: 此文件夹内脚本作为GitHook相匹配的脚本检查
- `script/git-hooks/<lib>/*`: 此文件夹内脚本作为自定义的GitHook脚本，可以覆盖默认的脚本。`<lib>` 可以是预设的不同语言的钩子库。

#### 如何使用

1. 克隆仓库之后： `git clone <仓库地址>`
2. 进入仓库目录：`cd <仓库地址>`
3. 设置Git钩子：`sh script/setup-git-hooks.sh`
   - 如果你想使用预设的不同语言的Git钩子，可以使用 `-l` 选项指定一个钩子库：`sh script/setup-git-hooks.sh -l <lib>`
   - 如果你想在一个特定的Git仓库中设置钩子，可以使用 `-p` 选项指定仓库的路径：`sh script/setup-git-hooks.sh -p <path>`。如果指定的路径不存在，脚本会创建一个新的 Git 仓库。
   - 如果你需要查看帮助信息，可以使用 `-h` 选项：`sh script/setup-git-hooks.sh -h`

* 注意以上步骤会覆盖当前本地设置的 Git 钩子，上述操作推荐使用git-bash命令行(***限windows**)