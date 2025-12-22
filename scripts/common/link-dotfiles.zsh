#!/usr/bin/env zsh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${0:A}")/../.." && pwd)"

assert_safe_dest() {
  local dest="$1"

  if [[ -z "${HOME:-}" ]]; then
    echo "Error: HOME is not set; refusing to link dotfiles." >&2
    exit 1
  fi

  if [[ -z "$dest" ]]; then
    echo "Error: empty destination path; refusing to remove/link." >&2
    exit 1
  fi

  if [[ "$dest" == "/" || "$dest" == "$HOME" ]]; then
    echo "Error: unsafe destination: $dest" >&2
    exit 1
  fi

  case "$dest" in
    "$HOME"/*) ;;
    *)
      echo "Error: destination must be under HOME: $dest" >&2
      exit 1
      ;;
  esac
}

os_id() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux) echo "linux" ;;
    *) echo "unknown" ;;
  esac
}

pick_source() {
  local rel="$1"
  local os
  os="$(os_id)"

  local os_path="$ROOT_DIR/src/$os/config/$rel"
  local common_path="$ROOT_DIR/src/common/config/$rel"

  if [[ -e "$os_path" || -L "$os_path" ]]; then
    echo "$os_path"
    return 0
  fi
  if [[ -e "$common_path" || -L "$common_path" ]]; then
    echo "$common_path"
    return 0
  fi

  return 1
}

link_path() {
  local src="$1"
  local dest="$2"

  assert_safe_dest "$dest"

  if [[ ! -e "$src" && ! -L "$src" ]]; then
    echo "Skip (source missing): $src"
    return
  fi

  mkdir -p "$(dirname "$dest")"

  if [[ -L "$dest" ]]; then
    local current
    current="$(readlink "$dest" || true)"
    if [[ "$current" == "$src" ]]; then
      echo "Already linked: $dest -> $src"
      return
    fi
  fi

  if [[ -e "$dest" || -L "$dest" ]]; then
    rm -rf "$dest"
    echo "Removed existing: $dest"
  fi

  ln -s "$src" "$dest"
  echo "Linked: $dest -> $src"
}

link_rel() {
  local rel="$1"
  local dest="$2"

  local src
  src="$(pick_source "$rel")" || {
    echo "Skip (source not found in src/{common,$(os_id)}): $rel"
    return 0
  }
  link_path "$src" "$dest"
}

main() {
  # Zsh
  link_rel "zsh/zshenv"   "$HOME/.zshenv"
  link_rel "zsh/zprofile" "$HOME/.zprofile"
  link_rel "zsh/zshrc"    "$HOME/.zshrc"
  link_rel "zsh/oh-my-zsh.sh" "$HOME/.oh-my-zsh.sh"

  # OS fragments (optional but recommended)
  link_rel "zsh/os.zsh" "$HOME/.config/dotfiles/os.zsh"
  link_rel "zsh/ohmyzsh.plugins.zsh" "$HOME/.config/dotfiles/ohmyzsh.plugins.zsh"

  # tmux
  link_rel "tmux/tmux.conf" "$HOME/.tmux.conf"
  link_rel "tmux/config"    "$HOME/.config/tmux"

  # Neovim
  link_rel "nvim" "$HOME/.config/nvim"

  # Git
  link_rel "git/gitconfig" "$HOME/.gitconfig"

  # mise
  link_rel "mise/config.toml" "$HOME/.config/mise/config.toml"

  # envconfig
  link_rel "env/envconfig" "$HOME/.envconfig"

  # bash profile (for bash users / legacy)
  link_rel "shell/bash_profile" "$HOME/.bash_profile"

  # Ghostty (macOS only)
  if [[ "$(os_id)" == "macos" ]]; then
    link_rel "ghostty" "$HOME/.config/ghostty"
  fi
}

main "$@"
