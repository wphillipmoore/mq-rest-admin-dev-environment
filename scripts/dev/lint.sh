#!/usr/bin/env bash
set -euo pipefail
# Tier 1 — Lint

files=$(find scripts -type f \( -name '*.sh' -o -path '*/git-hooks/*' \) | sort)
if [ -n "$files" ]; then
  echo "$files" | xargs shellcheck
else
  echo "No shell scripts found."
fi

if command -v actionlint >/dev/null 2>&1; then
  actionlint
else
  echo "actionlint not found — skipping workflow lint."
fi
