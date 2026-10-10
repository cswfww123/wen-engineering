#!/usr/bin/env bash
# Fail when a skill's relative markdown link (or backtick ../skill/FILE.md
# path) points at a missing or untracked
# file, or when a reference .md inside a skill folder has no pointer from any
# sibling file (an orphan the agent can never reach).
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"
failures=()

# 1. Relative .md links resolve to tracked files.
while IFS= read -r file; do
  dir="$(dirname "$file")"
  # Links inside ``` fences are examples of target-repo files, not pack links.
  # Covers [text](x.md) links and backtick `../<skill>/<FILE>.md` paths.
  prose="$(awk '/^[[:space:]]*```/ { fence = !fence; next } !fence' "$file")"
  targets="$({
    printf '%s\n' "$prose" | grep -oE '\]\([^)#[:space:]]+\.md(#[^)]*)?\)' |
      sed -E 's/^\]\(//; s/(#[^)]*)?\)$//'
    printf '%s\n' "$prose" | grep -oE '`\.\./[a-z-]+/[A-Za-z0-9_-]+\.md`' | tr -d '`'
  } || true)"
  for target in $targets; do
    case "$target" in http://* | https://*) continue ;; esac
    path="$dir/$target"
    if [ ! -f "$path" ]; then
      failures+=("$file -> $target (missing)")
    elif ! git ls-files --error-unmatch "$path" >/dev/null 2>&1; then
      failures+=("$file -> $target (not tracked by git)")
    fi
  done
done < <(find skills agents -name '*.md')

# 2. Every non-SKILL.md reference file is named by a sibling in its skill dir.
while IFS= read -r ref; do
  skill_dir="$(echo "$ref" | cut -d/ -f1-2)"
  name="$(basename "$ref")"
  if ! grep -rqF --include='*.md' --exclude="$name" "$name" "$skill_dir"; then
    failures+=("$ref (orphan: no pointer in $skill_dir)")
  fi
done < <(find skills -mindepth 2 -name '*.md' -not -name SKILL.md)

if [ "${#failures[@]}" -gt 0 ]; then
  printf 'FAIL: %s\n' "${failures[@]}" >&2
  exit 1
fi

echo "PASS: skill references resolve and no orphan reference files"
