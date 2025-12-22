#!/usr/bin/env zsh

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${0:A}")/../.." && pwd)"

os_id() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux) echo "linux" ;;
    *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
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

assert_safe_dest() {
  local dest="$1"
  if [[ -z "${HOME:-}" || -z "$dest" ]]; then
    echo "Error: unsafe destination" >&2
    exit 1
  fi
  if [[ "$dest" == "/" || "$dest" == "$HOME" ]]; then
    echo "Error: unsafe destination: $dest" >&2
    exit 1
  fi
  case "$dest" in
    "$HOME"/*) ;;
    *) echo "Error: destination must be under HOME: $dest" >&2; exit 1 ;;
  esac
}

link_path() {
  local src="$1"
  local dest="$2"

  assert_safe_dest "$dest"

  [[ -e "$src" || -L "$src" ]] || return 0
  mkdir -p "$(dirname "$dest")"

  if [[ -L "$dest" ]]; then
    local current
    current="$(readlink "$dest" || true)"
    [[ "$current" == "$src" ]] && return 0
  fi

  [[ -e "$dest" || -L "$dest" ]] && rm -rf "$dest"
  ln -s "$src" "$dest"
  echo "Linked: $dest -> $src"
}

link_rel() {
  local rel="$1"
  local dest="$2"
  local src
  src="$(pick_source "$rel")" || return 0
  link_path "$src" "$dest"
}

main() {
  # Install overlays expected by the public repo
  link_rel "git/gitconfig.local" "$HOME/.gitconfig.local"
  link_rel "zsh/zshrc.local" "$HOME/.zshrc.local"
  link_rel "env/envconfig.local" "$HOME/.envconfig.local"
}

main "$@"
