# Dotfiles (Public Base) — macOS + Ubuntu/Debian (Linuxbrew) / Zsh / tmux / Neovim / mise

这是一个**可公开**的通用 dotfiles 仓库：提供可重复执行的安装与配置管理。

- macOS：开发环境（Zsh、tmux、Neovim、Git、Ghostty、mise、常用 CLI/GUI 工具）
- Linux：仅支持 **Ubuntu/Debian 服务器（无 GUI）**，并统一使用 **Linuxbrew**（Zsh、tmux、Neovim、Git、mise）

本仓库**不包含任何敏感信息**。你自己的身份信息（Git name/email）、SSH 配置、token 等请使用私有仓库管理（本仓库提供模板：`private-template/`）。

---

## 你会得到什么

- 一套可重复执行的安装流程：OS 检测 → 安装 Homebrew/Linuxbrew & 包 → 链接配置 → mise 初始化
- 统一的配置源目录：`src/common/config/` + `src/{macos,linux}/config/`（内容被 symlink 到 `$HOME`）
- 可选的 macOS 偏好设置脚本：`scripts/macos/prefs.zsh`
- 私有仓库模板：`private-template/`（用于 git-secret 管理敏感文件并恢复到本机）

---

## 快速开始（推荐）

### 1) 克隆并运行基础安装（macOS）

```bash
git clone https://github.com/<your-org-or-username>/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
zsh install.zsh
```

`install.zsh` 默认执行 `base` 流程，包含：
- OS 检测与 check（macOS/Linux）
- Homebrew / Linuxbrew 安装与包安装（macOS 含 cask，Linux 不含 GUI）
- Oh My Zsh 安装（必选）
- 链接 dotfiles（按 `common` + OS 覆盖）
- mise 安装与 `mise install`（必选）

### 2) Ubuntu/Debian 服务器（Linuxbrew，无 GUI）

推荐使用引导脚本（会用 `apt-get` 安装最小依赖，然后进入 `install.zsh`）：

```bash
git clone https://github.com/<your-org-or-username>/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

注意：
- Linuxbrew 默认安装前缀为 `/home/linuxbrew/.linuxbrew`，通常需要 `sudo` 权限创建/写入该目录。
- 安装过程会联网下载 Homebrew / Oh My Zsh / mise 相关内容。

### 2) 可选：应用 macOS 偏好设置

```bash
zsh scripts/macos/prefs.zsh
```

---

## 私有配置（强烈建议）

公共仓库只负责“基础通用”。请把以下内容放到**私有仓库**：

- Git 身份信息：`user.name` / `user.email` / 签名配置
- SSH 配置（如 `~/.ssh/config`）
- token / API keys / 内部服务配置
- 公司相关工具清单（brew private packages）

本仓库自带一个私有模板目录：`private-template/`  
你可以把它复制为一个独立的私有仓库（例如 `~/.dotfiles-private`），并按模板文档使用 `git-secret` 管理敏感文件。

私有仓库建议生成/维护三个 overlay 文件（由公共配置加载）：
- `~/.gitconfig.local`
- `~/.zshrc.local`
- `~/.envconfig.local`

---

## 本仓库的目录结构（当前）

```text
.
├── install.sh               # Ubuntu/Debian 引导（安装 zsh/git/curl 等后执行 install.zsh）
├── install.zsh
├── packages/
│   ├── common/
│   │   └── brew-cli.txt     # 最小必装 CLI（macOS + Linuxbrew）
│   ├── macos/
│   │   ├── brew-cli.txt
│   │   └── brew-cask.txt
│   └── linux/
│       └── brew-cli.txt
├── scripts/
│   ├── common/              # 跨平台通用脚本
│   ├── macos/               # macOS 专属脚本（含 prefs）
│   └── linux/               # Ubuntu/Debian 专属脚本（Linuxbrew）
├── src/
│   ├── common/config/       # 默认通用配置（所有 OS）
│   ├── macos/config/        # macOS 覆盖（例如 ghostty、zprofile、ohmyzsh plugins）
│   └── linux/config/        # Linux 覆盖（Ubuntu/Debian + Linuxbrew）
└── private-template/   # 私有仓库模板（git-secret + ssh config + tokens 等）
```

---

## 配置如何生效（关键机制）

`scripts/common/link-dotfiles.zsh` 会把 `src/common/config/**` 下的文件/目录以 **symlink** 方式链接到你的 `$HOME`，并在存在时用 `src/{macos,linux}/config/**` 覆盖同名目标。

注意：链接过程会删除并替换已存在的目标文件/目录（例如 `~/.zshrc`、`~/.config/tmux`），如需保留请提前备份。

- `zsh/*` → `~/.zshenv` / `~/.zprofile` / `~/.zshrc` / `~/.oh-my-zsh.sh`
- `tmux/*` → `~/.tmux.conf` / `~/.config/tmux`
- `nvim` → `~/.config/nvim`
- `git/gitconfig` → `~/.gitconfig`
- `ghostty` → `~/.config/ghostty`（仅 macOS）
- `mise/config.toml` → `~/.config/mise/config.toml`
- `env/envconfig` → `~/.envconfig`（会加载 `~/.envconfig.local`）
- `zsh/os.zsh` → `~/.config/dotfiles/os.zsh`（OS 片段，可覆盖）
- `zsh/ohmyzsh.plugins.zsh` → `~/.config/dotfiles/ohmyzsh.plugins.zsh`（OS 插件片段，可覆盖）

如果你修改了配置文件，重新执行：

```bash
zsh scripts/common/link-dotfiles.zsh
```

---

## 自定义（公共 vs 私有）

### 公共仓库（推荐只放通用的）
- `packages/**`：基础软件清单（common + OS）
- `src/**/config/**`：通用配置（不要包含个人身份与敏感信息）

### 私有仓库（放你自己的）
- `~/.gitconfig.local`：Git 身份/签名/公司 rewrite
- `~/.zshrc.local`：公司 alias、私有脚本入口等
- `~/.envconfig.local`：机器差异/非敏感环境变量
- 敏感文件：通过 `git-secret` 加密，reveal 后按 manifest 安装（参考 `private-template/`）

---

## 更新

```bash
cd ~/.dotfiles
git pull
zsh install.zsh
```

---

## 安全说明

- 本仓库不应包含：私钥、token、密码、任何敏感配置
- 敏感内容请使用私有仓库（可基于 `private-template/`），并使用 `git-secret` 管理

---

## License

MIT
