#!/usr/bin/env bash
# Fail when agents/Executor.md body drifts from the Executor system text in
# skills/implement/DISPATCH.md (the two must stay identical: hosts with a pack
# role load the agent file; hosts without one paste the DISPATCH block).
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dispatch="$repo_root/skills/implement/DISPATCH.md"
agent="$repo_root/agents/Executor.md"

dispatch_text="$(awk '
  /<!-- executor-system-text:start -->/ { in_block = 1; next }
  /<!-- executor-system-text:end -->/   { in_block = 0 }
  in_block && !/^```/ { print }
' "$dispatch")"

# Agent body = everything after the closing frontmatter fence, blank-trimmed.
agent_text="$(awk 'fm < 2 { if (/^---$/) fm++; next } { print }' "$agent" | sed '/./,$!d')"

if [ -z "$dispatch_text" ]; then
  echo "FAIL: executor-system-text markers not found in $dispatch" >&2
  exit 1
fi

if [ "$dispatch_text" != "$agent_text" ]; then
  echo "FAIL: agents/Executor.md body differs from DISPATCH.md Executor system text" >&2
  diff <(printf '%s\n' "$dispatch_text") <(printf '%s\n' "$agent_text") >&2 || true
  exit 1
fi

echo "PASS: Executor system text in sync"
