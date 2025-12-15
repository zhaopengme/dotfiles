# Ghostty 终端配置

深度集成 tmux 的 Ghostty 终端配置，采用 **冷青极客风** 配色，与 tmux 保持视觉一致。

## ✨ 特性

- 🎨 **统一配色** - 冷青主色 (#32ade6)，与 tmux 状态栏完美搭配
- ⌨️ **快捷键映射** - 所有 tmux 操作映射到 `⌘ Command` 键
- 🚀 **自动启动 tmux** - 打开终端自动进入 tmux 会话
- 🪟 **极简界面** - 无标题栏、无边框，专注代码
- 🔧 **智能启动** - 自动检测 Apple Silicon/Intel Mac 的 tmux 路径

## 📦 依赖安装

```bash
# 安装 tmux
brew install tmux

# 安装 Nerd Font（推荐）
brew tap homebrew/cask-fonts
brew install font-jetbrains-mono-nerd-font
```

## 🎨 主题配色

| 元素 | 颜色 | 说明 |
|------|------|------|
| 背景 | `#1c1c1e` | 深灰黑 |
| 前景 | `#f2f2f7` | 浅灰白 |
| 光标 | `#32ade6` | 冷青色（主色） |
| 选中 | `#2c2c2e` | 中灰 |

配色灵感来自 macOS 深色模式，适合长时间编码。

## ⌨️ 快捷键

> **tmux 前缀键**: `Ctrl+B`  
> 所有快捷键已映射到 macOS `⌘ Command` 键

### 窗口管理
```
⌘T          新建窗口
⌘1-9        切换到窗口 1-9
⌘[          上一个窗口
⌘]          下一个窗口
⌘,          重命名窗口
```

### 面板操作
```
⌘Enter      水平分屏
⌘D          垂直分屏
⌘H/J/K/L    切换面板（Vim 风格）
⌘W          关闭面板
⌘Z          面板缩放/全屏
⌘O          交换面板位置
```

### 面板调整
```
⌘⇧H         向左扩展
⌘⇧J         向下扩展
⌘⇧K         向上扩展
⌘⇧L         向右扩展
```

### 会话管理
```
⌘N          新建会话
⌘O          会话列表
⌘⇧D         分离会话
⌘⇧X         关闭会话
⌘U          Popup 会话
```

### 其他
```
⌘R          命令弹窗
⌘G          临时终端
⌘⇧S         保存会话（tmux-resurrect）
⌘⇧R         恢复会话（tmux-resurrect）
```

完整快捷键列表：[KEYBINDINGS.md](./KEYBINDINGS.md)

## 📁 文件说明

```
~/.config/ghostty/
├── config              # 主配置文件
├── start-tmux.sh       # tmux 启动脚本
├── ghostty-white.icns  # 自定义图标
├── README.md           # 本文档
└── KEYBINDINGS.md      # 快捷键速查表
```

## 🔧 自定义

### 修改字体大小
编辑 `config`:
```
font-size = 14  # 改为你喜欢的大小
```

### 禁用 tmux 自动启动
注释掉 `config` 中的这一行：
```
# command = ~/.config/ghostty/start-tmux.sh
```

### 修改配色
编辑 `config` 中的 `palette` 和 `background/foreground` 配置。

## 🐛 常见问题

### Q: 快捷键不工作？
**A:** 确认 tmux 正在运行：
```bash
echo $TMUX  # 应该有输出
tmux show-options -g | grep prefix  # 应显示 prefix C-b
```

### Q: 字体显示异常？
**A:** 确认字体已安装：
```bash
fc-list | grep -i "jetbrains"
# 或重新安装
brew install font-jetbrains-mono-nerd-font
```

### Q: tmux 启动失败？
**A:** 检查启动脚本权限：
```bash
chmod +x ~/.config/ghostty/start-tmux.sh
# 手动运行查看错误
~/.config/ghostty/start-tmux.sh
```

### Q: 会话名显示为 "main"？
**A:** 会话名基于当前目录生成。在项目目录中启动 Ghostty 即可自动使用项目名。

## 🔄 更新配置

```bash
# 如果使用 dotfiles 仓库
cd ~/.dotfiles
git pull

# 重启 Ghostty
killall ghostty
```

## 📚 参考

- [Ghostty 官方文档](https://ghostty.org)
- [tmux 配置](../../.tmux.conf)
- [快捷键速查](./KEYBINDINGS.md)

---

**维护**: （通用模板已移除个人链接）  
**更新**: 2024
