#!/usr/bin/env zsh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG_DIR="$ROOT_DIR/src/config"

link_path() {
  local src="$1"
  local dest="$2"

  if [[ ! -e "$src" && ! -L "$src" ]]; then
    echo "Skip (source missing): $src"
    return
  fi

  mkdir -p "$(dirname "$dest")"

  # 如果已经是我们生成的正确链接，直接跳过
  if [[ -L "$dest" ]]; then
    local current
    current="$(readlink "$dest" || true)"
    if [[ "$current" == "$src" ]]; then
      echo "Already linked: $dest -> $src"
      return
    fi
  fi

  # 无论是旧文件、旧目录还是旧链接，都强制替换为新的 symlink
  if [[ -e "$dest" || -L "$dest" ]]; then
    rm -rf "$dest"
    echo "Removed existing: $dest"
  fi

  ln -s "$src" "$dest"
  echo "Linked: $dest -> $src"
}

main() {
  # Zsh
  link_path "$CONFIG_DIR/zsh/zshenv"   "$HOME/.zshenv"
  link_path "$CONFIG_DIR/zsh/zprofile" "$HOME/.zprofile"
  link_path "$CONFIG_DIR/zsh/zshrc"    "$HOME/.zshrc"
  link_path "$CONFIG_DIR/zsh/oh-my-zsh.sh" "$HOME/.oh-my-zsh.sh"
  # tmux
  link_path "$CONFIG_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
  link_path "$CONFIG_DIR/tmux/config"    "$HOME/.config/tmux"

  # Neovim
  link_path "$CONFIG_DIR/nvim" "$HOME/.config/nvim"

  # Git
  link_path "$CONFIG_DIR/git/gitconfig" "$HOME/.gitconfig"

  # Ghostty
  link_path "$CONFIG_DIR/ghostty" "$HOME/.config/ghostty"

  # mise
  link_path "$CONFIG_DIR/mise/config.toml" "$HOME/.config/mise/config.toml"

  # envconfig
  link_path "$CONFIG_DIR/env/envconfig" "$HOME/.envconfig"
}

main "$@"
