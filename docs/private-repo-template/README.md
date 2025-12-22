# Private Dotfiles Template (macOS + Ubuntu/Debian + Linuxbrew)

这个目录是“私有 dotfiles 仓库”的模板设计（不包含任何敏感信息），用于配合本公共仓库工作。

目标：
- 跨平台：macOS + Ubuntu/Debian（Linuxbrew，服务器无 GUI）
- 只放私有/机器差异内容：Git 身份、SSH 配置、公司内网变量、额外软件清单等
- 通过 symlink 把私有配置安装到 `$HOME`，并与公共仓库的 overlay 机制对齐：
  - `~/.gitconfig.local`
  - `~/.zshrc.local`
  - `~/.envconfig.local`

默认行为：
- **默认覆盖**：安装时会删除并替换 `$HOME` 下同名目标（包括可选的 `~/.ssh/config`）。

---

## 推荐的私有仓库结构

建议在你的私有仓库里采用与公共仓库一致的三层结构：

```text
.
├── install.zsh
├── packages/
│   ├── common/brew-cli.private.txt
│   ├── macos/
│   │   ├── brew-cli.private.txt
│   │   └── brew-cask.private.txt
│   └── linux/brew-cli.private.txt
├── scripts/
│   ├── common/link-private.zsh
│   └── common/brew-private-install.zsh
└── src/
    ├── common/config/
    │   ├── env/envconfig.local
    │   ├── git/gitconfig.local
    │   └── zsh/zshrc.local
    ├── macos/config/
    │   └── zsh/zshrc.local
    └── linux/config/
        └── zsh/zshrc.local
```

其中：
- `src/**/config/**`：只放“私有 overlay 文件”，不要放密钥/明文 token
- `packages/**`：私有软件清单（公司工具、个人偏好），macOS 才有 cask
- `install.zsh`：调用 `brew-private-install` + `link-private`

---

## 创建私有仓库（示例）

```bash
mkdir -p ~/.dotfiles-private
cd ~/.dotfiles-private
# 把本目录下的模板文件拷贝过去作为起点（你也可以直接新建并按结构写）
```

推荐把私有仓库作为独立 git 仓库托管（GitHub private / 自建 git），并确保：
- 不提交任何密钥、token、密码
- 敏感内容使用加密工具（例如 `sops`/`git-secret`/`age`）或放入密码管理器

---

## 与公共仓库如何配合

公共仓库已经会 `include` / `source` 这些 overlay：
- `~/.gitconfig.local`
- `~/.zshrc.local`
- `~/.envconfig.local`

因此私有仓库只要把对应文件链接到 `$HOME` 即可。

可选项：
- `BREW_UPDATE=0`：跳过 `brew update`（更快，但可能遇到过期索引）。

---

## Linux（Ubuntu/Debian）注意事项

- Linuxbrew 默认前缀通常是 `/home/linuxbrew/.linuxbrew`，需要写入权限（常见需要 `sudo`）。
- 建议私有仓库只在 `packages/linux/brew-cli.private.txt` 放“额外”公式，基础必装由公共仓库负责。
