#!/usr/bin/env bash

set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
TAG="# === Minecraft MC Tool ==="

detect_shell_rc() {
  if [[ -n "$ZSH_VERSION" ]] || command -v zsh >/dev/null 2>&1; then
    local zdotdir
    zdotdir="$(zsh -c 'print -r -- ${ZDOTDIR:-$HOME}' 2>/dev/null)"
    echo "$zdotdir/.zshrc"
    return 0
  fi

  if [[ -n "$BASH_VERSION" ]] || command -v bash >/dev/null 2>&1; then
    echo "$HOME/.bashrc"
    return 0
  fi

  return 1
}

RC_FILE="$(detect_shell_rc)" || {
  echo "❌ Can not detect bash or zsh."
  exit 1
}

echo "🧠 Config file detected: $RC_FILE"

if grep -q "$TAG" "$RC_FILE"; then
  echo "⚠️  MC it's already initialized. Nothing to do."
  exit 0
fi

if [[ ! -f "$PROJECT_DIR/mc.sh" ]]; then
  echo "❌ 'mc' file not found in the folder."
  exit 1
fi

chmod +x "$PROJECT_DIR/mc.sh"
mkdir "$PROJECT_DIR/servers"

cat <<EOF >> "$RC_FILE"

$TAG
alias mc="$PROJECT_DIR/mc.sh"
# === END Minecraft MC Tool ===
EOF

echo "✅ Command 'mc' installed correctly."
