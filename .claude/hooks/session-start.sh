#!/bin/bash
# Installiert Agent Reach in Claude Code Cloud-Sitzungen (nur Benutzer-Ebene, kein sudo).
# Anleitung: https://raw.githubusercontent.com/Panniantong/agent-reach/main/docs/install.md
set -euo pipefail

if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

export PATH="$HOME/.local/bin:$PATH"

# uv fehlt? Dann installieren (ohne Admin-Rechte).
if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Nur die GitHub-Version installieren, NICHT das gleichnamige PyPI-Paket.
if ! command -v agent-reach >/dev/null 2>&1; then
  uv tool install https://github.com/Panniantong/Agent-Reach/releases/latest/download/agent-reach.zip
fi

# Standard-Kanäle und Skill einrichten (einmalig).
if [ ! -f "$HOME/.agent-reach/state.json" ]; then
  agent-reach setup >/dev/null
fi

if [ -n "${CLAUDE_ENV_FILE:-}" ]; then
  echo "export PATH=\"$HOME/.local/bin:\$PATH\"" >> "$CLAUDE_ENV_FILE"
fi
