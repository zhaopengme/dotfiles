# dotfiles-private (template)

这是一个 **私有 dotfiles 仓库模板**，用来承接公共仓库不应该包含的内容：

- 你的身份信息（Git name/email、签名策略、公司 URL rewrite 等）
- 机器/公司差异配置（代理、内部工具、额外 brew 包等）
- **敏感文件**（SSH config、token 文件等），通过 **git-secret + GPG** 加密管理，并在新机器上一键恢复

> 这个目录是模板：请把它复制到一个**独立的私有仓库**里使用（例如 `~/.dotfiles-private`）。

---

## 设计原则（简洁好用）

- 公共仓库保持“通用可公开”，只负责基础工具与配置。
- 私有仓库只做三件事：
  1) 安装私有依赖（可选）：`git-secret`、`gnupg`、公司 CLI 等  
  2) 链接私有 overlay 文件到 `$HOME`：`~/.gitconfig.local`、`~/.zshrc.local`、`~/.envconfig.local`
  3) 使用 `git-secret` 管理敏感文件，按 `secrets/manifest.yml` 恢复到目标路径（如 `~/.ssh/config`）

---

## 目录结构

```text
.
├── install.zsh
├── brew/
│   ├── cli.private.txt
│   └── cask.private.txt
├── src/
│   └── config/
│       ├── git/gitconfig.local
│       ├── zsh/zshrc.local
│       └── env/envconfig.local
├── scripts/
│   ├── macos-check.zsh
│   ├── brew-install-private.zsh
│   ├── link-private.zsh
│   └── secret-helper.zsh
└── secrets/
    ├── manifest.yml
    └── (your secret files / encrypted artifacts)
```

---

## 使用方式（新机器最短流程）

### 1) 克隆私有仓库并做基础安装

```bash
git clone <your-private-repo-url> ~/.dotfiles-private
cd ~/.dotfiles-private
zsh install.zsh
```

默认 `install.zsh` 会：
- 检查 macOS
- 尝试安装私有 brew 包（best-effort）
- 链接 overlay 文件到 `$HOME`

### 2) 导入 GPG 私钥（只在新机器第一次需要）

你需要能解密 `git-secret` 的 GPG 私钥（导入方式取决于你如何保存密钥）。

验证：

```bash
gpg --list-secret-keys
```

### 3) 解密并安装敏感文件

推荐一条命令完成：

```bash
zsh scripts/secret-helper.zsh reveal-install
```

或分两步：

```bash
zsh scripts/secret-helper.zsh reveal
zsh scripts/secret-helper.zsh install
```

---

## 私有 overlay（非敏感但私有）

这个模板会把以下文件 symlink 到 `$HOME`（由公共 dotfiles 加载）：

- `src/config/git/gitconfig.local`  → `~/.gitconfig.local`
- `src/config/zsh/zshrc.local`      → `~/.zshrc.local`
- `src/config/env/envconfig.local`  → `~/.envconfig.local`

这些文件适合放：
- Git 身份、签名设置、公司 URL rewrite、代理等（建议都放在 `gitconfig.local`）
- 私有 alias、公司脚本入口、加载私有 token 文件（放在 `zshrc.local`）
- 非敏感环境变量或机器差异（放在 `envconfig.local`）

---

## git-secret 工作流（精简版）

### 一次性初始化（在私有仓库根目录）

```bash
git secret init
git secret tell you@example.com
```

> `tell` 需要你的 GPG 公钥已存在于 keyring 中。

### 添加/更新一个 secret 文件

以 `~/.ssh/config` 为例（推荐把 SSH config 当作 secret 管理）：

1) 复制明文到仓库工作区：

```bash
cp ~/.ssh/config secrets/ssh_config
```

2) 让 git-secret 跟踪它（首次添加需要）：

```bash
git secret add secrets/ssh_config
```

3) 加密生成 `*.secret`：

```bash
git secret hide -f
```

4) 确保 `secrets/manifest.yml` 里有映射：

```text
ssh_config: "~/.ssh/config"
```

5) 提交时只提交加密产物与元数据（不要提交明文）：

```bash
git add secrets/ssh_config.secret .gitsecret/paths/mapping.cfg secrets/manifest.yml
git commit -m "Manage ssh config via git-secret"
```

---

## secrets/manifest.yml（恢复规则）

`manifest.yml` 的每一行是：

- 解密后文件名（位于 `secrets/`） → 目标路径

例如：

```text
ssh_config: "~/.ssh/config"
tokens.env: "~/.config/private/tokens.env"
```

安装时行为：
- 自动创建目标目录
- 复制文件到目标位置（不是 symlink）
- 对目标文件执行 `chmod 600`
- 如果目标是 `~/.ssh/config`，会确保 `~/.ssh` 为 `chmod 700`

---

## SSH 配置示例

模板提供了一个示例文件：

- `secrets/ssh_config`

你可以：
- 用它作为起点修改
- 或直接用你现有的 `~/.ssh/config` 覆盖它

---

## 安全建议（务必遵守）

- **不要把 SSH 私钥放进 git（即使加密也不推荐）**  
  更好的方式：Keychain / 1Password SSH agent / 硬件密钥。
- token/密码尽可能使用 Keychain/1Password 注入；必须落盘时才用 `git-secret` 管理，并确保权限正确（0600）。
- 公共仓库不要出现任何身份与敏感信息；都放私有仓库即可。

---

## 命令速查

在私有仓库根目录：

```bash
# 基础：brew(可选) + link overlay
zsh install.zsh

# 仅安装私有 brew 包
zsh install.zsh brew

# 仅链接 overlay（git/zsh/env）
zsh install.zsh link

# 解密与安装敏感文件
zsh scripts/secret-helper.zsh reveal-install

# 其他
zsh scripts/secret-helper.zsh check
zsh scripts/secret-helper.zsh hide
zsh scripts/secret-helper.zsh add <path> [dest]
```
