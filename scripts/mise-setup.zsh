#!/usr/bin/env zsh

set -euo pipefail

if ! command -v mise >/dev/null 2>&1; then
  echo "mise not installed, skipping mise setup."
  exit 0
fi

echo "mise detected: $(command -v mise)"

# 配置文件链接由 link-dotfiles.zsh 负责，这里只做可选的 install。

if [[ "${MISE_AUTO_INSTALL:-1}" == "1" ]]; then
  echo "Running 'mise install' (set MISE_AUTO_INSTALL=0 to skip)..."
  mise install
else
  echo "Skipping 'mise install' (MISE_AUTO_INSTALL=$MISE_AUTO_INSTALL)."
fi

