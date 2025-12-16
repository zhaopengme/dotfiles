#!/usr/bin/env zsh

set -euo pipefail

ZSH_PLUGINS_DIR="$HOME/.zsh"

install_plugin() {
  local name="$1"
  local repo="$2"
  local dest="$ZSH_PLUGINS_DIR/$name"

  if [[ -d "$dest" ]]; then
    echo "Plugin '$name' already installed at $dest, skipping."
    return
  fi

  if ! command -v git >/dev/null 2>&1; then
    echo "git not found, cannot install plugin '$name'." >&2
    return 1
  fi

  echo "Installing plugin '$name' into $dest ..."
  mkdir -p "$ZSH_PLUGINS_DIR"
  git clone --depth=1 "$repo" "$dest" || {
    echo "Failed to clone plugin '$name'." >&2
    return 1
  }
  echo "Plugin '$name' installed."
}

main() {
  install_plugin "zsh-ssh" "https://github.com/sunlei/zsh-ssh.git"
}

main "$@"
