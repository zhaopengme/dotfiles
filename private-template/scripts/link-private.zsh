#!/usr/bin/env zsh
#
# Link private overlay files into $HOME.
#
# Intended usage:
#   zsh scripts/link-private.zsh
#
# This script is deliberately small and focused:
# - Link "local" overlay files that your PUBLIC dotfiles should load:
#   - ~/.gitconfig.local   (included by public gitconfig)
#   - ~/.zshrc.local       (sourced by public zshrc)
#   - ~/.envconfig.local   (loaded by public envconfig)
#
# - Optional: link ~/.ssh/config from private repo (non-secret).
#   If you manage ssh config as a secret, do NOT link it here; use secret-helper instead.

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG_DIR="$ROOT_DIR/src/config"

link_path() {
  local src="$1"
  local dest="$2"

  if [[ ! -e "$src" && ! -L "$src" ]]; then
    echo "Skip (source missing): $src"
    return 0
  fi

  mkdir -p "$(dirname "$dest")"

  # If it's already the correct symlink, skip.
  if [[ -L "$dest" ]]; then
    local current
    current="$(readlink "$dest" || true)"
    if [[ "$current" == "$src" ]]; then
      echo "Already linked: $dest -> $src"
      return 0
    fi
  fi

  # Replace existing file/dir/link.
  if [[ -e "$dest" || -L "$dest" ]]; then
    rm -rf "$dest"
    echo "Removed existing: $dest"
  fi

  ln -s "$src" "$dest"
  echo "Linked: $dest -> $src"
}

main() {
  # Git overlay (public ~/.gitconfig should include ~/.gitconfig.local)
  link_path "$CONFIG_DIR/git/gitconfig.local" "$HOME/.gitconfig.local"

  # Zsh overlay (public ~/.zshrc should source ~/.zshrc.local)
  link_path "$CONFIG_DIR/zsh/zshrc.local" "$HOME/.zshrc.local"

  # Env overlay (public ~/.envconfig should load ~/.envconfig.local)
  link_path "$CONFIG_DIR/env/envconfig.local" "$HOME/.envconfig.local"

  # Optional: SSH config (ONLY if you don't manage it via git-secret)
  # link_path "$CONFIG_DIR/ssh/config" "$HOME/.ssh/config"
}

main "$@"
