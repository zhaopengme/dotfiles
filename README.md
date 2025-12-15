# Dotfiles (Public Base) — macOS / Zsh / tmux / Neovim / Ghostty / mise

这是一个**可公开**的通用 dotfiles 仓库：专注于 macOS 上的基础开发环境安装与配置管理（Zsh、tmux、Neovim、Git、Ghostty、mise、常用 CLI/GUI 工具）。

本仓库**不包含任何敏感信息**。你自己的身份信息（Git name/email）、SSH 配置、token 等请使用私有仓库管理（本仓库提供模板：`private-template/`）。

---

## 你会得到什么

- 一套可重复执行的安装流程：检查 macOS → 安装 Homebrew & 包 → 链接配置 → mise 初始化
- 统一的配置源目录：`src/config/`（内容被 symlink 到 `$HOME`）
- 可选的 macOS 偏好设置脚本：`scripts/macos-prefs.zsh`
- 私有仓库模板：`private-template/`（用于 git-secret 管理敏感文件并恢复到本机）

---

## 快速开始（推荐）

### 1) 克隆并运行基础安装

```bash
git clone https://github.com/<your-org-or-username>/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
zsh install.zsh
```

`install.zsh` 默认执行 `base` 流程，包含：
- `scripts/macos-check.zsh`
- `scripts/brew-install.zsh`
- `scripts/oh-my-zsh-install.zsh`
- `scripts/bash-profile-bootstrap.zsh`
- `scripts/link-dotfiles.zsh`
- `scripts/mise-setup.zsh`

### 2) 可选：应用 macOS 偏好设置

```bash
zsh scripts/macos-prefs.zsh
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
├── install.zsh
├── brew/
│   ├── cli.txt
│   └── cask.txt
├── scripts/
│   ├── macos-check.zsh
│   ├── brew-install.zsh
│   ├── oh-my-zsh-install.zsh
│   ├── bash-profile-bootstrap.zsh
│   ├── link-dotfiles.zsh
│   ├── mise-setup.zsh
│   ├── macos-prefs.zsh
│   └── macos-prefs.d/
├── src/
│   └── config/
│       ├── zsh/        # zshenv/zprofile/zshrc/oh-my-zsh.sh
│       ├── tmux/       # .tmux.conf + ~/.config/tmux
│       ├── nvim/       # ~/.config/nvim
│       ├── git/        # ~/.gitconfig（不含个人身份）
│       ├── ghostty/    # ~/.config/ghostty
│       ├── mise/       # ~/.config/mise/config.toml
│       ├── env/        # ~/.envconfig（会加载 ~/.envconfig.local）
│       └── shell/      # bash_profile 等兼容配置
└── private-template/   # 私有仓库模板（git-secret + ssh config + tokens 等）
```

---

## 配置如何生效（关键机制）

`scripts/link-dotfiles.zsh` 会把 `src/config/**` 下的文件/目录以 **symlink** 方式链接到你的 `$HOME`，包括：

- `src/config/zsh/*` → `~/.zshenv` / `~/.zprofile` / `~/.zshrc` / `~/.oh-my-zsh.sh`
- `src/config/tmux/*` → `~/.tmux.conf` / `~/.config/tmux`
- `src/config/nvim` → `~/.config/nvim`
- `src/config/git/gitconfig` → `~/.gitconfig`
- `src/config/ghostty` → `~/.config/ghostty`
- `src/config/mise/config.toml` → `~/.config/mise/config.toml`
- `src/config/env/envconfig` → `~/.envconfig`（其中会加载 `~/.envconfig.local`）

如果你修改了配置文件，重新执行：

```bash
zsh scripts/link-dotfiles.zsh
```

---

## 自定义（公共 vs 私有）

### 公共仓库（推荐只放通用的）
- `brew/cli.txt`、`brew/cask.txt`：基础软件清单
- `src/config/**`：通用配置（不要包含个人身份与敏感信息）

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