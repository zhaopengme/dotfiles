#!/usr/bin/env zsh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG_DIR="$ROOT_DIR/src/config"

install_bash_profile() {
  local src="$CONFIG_DIR/shell/bash_profile"
  local dest="$HOME/.bash_profile"

  if [[ ! -f "$src" ]]; then
    return
  fi

  # 如果已经是正确的链接则跳过
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

install_bash_profile

