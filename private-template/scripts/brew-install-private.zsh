#!/usr/bin/env zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BREW_DIR="$ROOT_DIR/brew"
CLI_LIST="$BREW_DIR/cli.private.txt"
CASK_LIST="$BREW_DIR/cask.private.txt"

log() {
  echo "[brew-private] $*"
}

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

is_macos() {
  [[ "$(uname -s)" == "Darwin" ]]
}

ensure_homebrew() {
  if have_cmd brew; then
    log "Homebrew found: $(command -v brew)"
    return 0
  fi

  log "Homebrew not found. Installing..."
  # Official install script (requires network access)
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Make brew available in this shell session (Apple Silicon vs Intel)
  if [[ -x "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x "/usr/local/bin/brew" ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  if ! have_cmd brew; then
    log "Homebrew install finished but 'brew' is still not in PATH."
    log "Open a new terminal or run the shellenv snippet shown by the installer."
    return 1
  fi

  log "Homebrew installed: $(command -v brew)"
}

brew_update_once() {
  # Keep it simple and deterministic; user can update separately if they want.
  # Still, most installs benefit from at least a tap/update.
  log "Running: brew update"
  brew update
}

install_cli_packages() {
  if [[ ! -f "$CLI_LIST" ]]; then
    log "No CLI list found at: $CLI_LIST (skipping)"
    return 0
  fi

  log "Installing CLI packages from: $CLI_LIST"

  # Read non-empty, non-comment lines
  local pkg
  while IFS= read -r pkg; do
    pkg="${pkg%%#*}"
    pkg="${pkg#"${pkg%%[![:space:]]*}"}"
    pkg="${pkg%"${pkg##*[![:space:]]}"}"

    [[ -n "$pkg" ]] || continue

    if brew list --formula "$pkg" >/dev/null 2>&1; then
      log "Already installed formula: $pkg"
    else
      log "Installing formula: $pkg"
      brew install "$pkg"
    fi
  done <"$CLI_LIST"
}

install_cask_packages() {
  if [[ ! -f "$CASK_LIST" ]]; then
    log "No Cask list found at: $CASK_LIST (skipping)"
    return 0
  fi

  log "Installing Cask packages from: $CASK_LIST"

  local cask
  while IFS= read -r cask; do
    cask="${cask%%#*}"
    cask="${cask#"${cask%%[![:space:]]*}"}"
    cask="${cask%"${cask##*[![:space:]]}"}"

    [[ -n "$cask" ]] || continue

    if brew list --cask "$cask" >/dev/null 2>&1; then
      log "Already installed cask: $cask"
    else
      log "Installing cask: $cask"
      brew install --cask "$cask"
    fi
  done <"$CASK_LIST"
}

cleanup() {
  log "Running: brew cleanup (best-effort)"
  brew cleanup || true
}

main() {
  if ! is_macos; then
    log "Not macOS. Skipping Homebrew private packages."
    return 0
  fi

  ensure_homebrew
  brew_update_once
  install_cli_packages
  install_cask_packages
  cleanup

  log "Done."
}

main "$@"
