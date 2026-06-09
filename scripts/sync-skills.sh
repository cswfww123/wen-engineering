#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: scripts/sync-skills.sh [options]

Synchronize this repo's skills into local agent skill directories.

Options:
  --agents LIST    Comma-separated agents: codex,claude,both (default: both)
  --mode MODE      copy or link (default: copy)
  --dry-run        Print planned changes without writing
  --force          Replace same-name skill directories not yet managed by this repo
  -h, --help       Show this help

Environment overrides:
  CODEX_SKILLS_DIR   Default: $HOME/.codex/skills
  CLAUDE_SKILLS_DIR  Default: $HOME/.claude/skills
USAGE
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skills_src="$repo_root/skills"
agents="both"
mode="copy"
dry_run=0
force=0
marker_file=".wen-engineering-managed"
manifest_file=".wen-engineering-skills-manifest"
manifest_names=()

while [ "$#" -gt 0 ]; do
  case "$1" in
    --agents)
      agents="${2:?--agents requires a value}"
      shift 2
      ;;
    --agents=*)
      agents="${1#--agents=}"
      shift
      ;;
    --mode)
      mode="${2:?--mode requires a value}"
      shift 2
      ;;
    --mode=*)
      mode="${1#--mode=}"
      shift
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    --force)
      force=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$mode" in
  copy|link) ;;
  *)
    echo "--mode must be copy or link" >&2
    exit 2
    ;;
esac

if [ "$mode" = "copy" ] && ! command -v rsync >/dev/null 2>&1; then
  echo "copy mode requires rsync. Install rsync or use --mode link." >&2
  exit 2
fi

if [ ! -d "$skills_src" ]; then
  echo "Cannot find skills source directory: $skills_src" >&2
  exit 1
fi

skill_names=()
while IFS= read -r skill_name; do
  skill_names+=("$skill_name")
done < <(
  find "$skills_src" -mindepth 2 -maxdepth 2 -name SKILL.md -print |
    while IFS= read -r skill_file; do basename "$(dirname "$skill_file")"; done |
    sort
)

if [ "${#skill_names[@]}" -eq 0 ]; then
  echo "No skills found under $skills_src" >&2
  exit 1
fi

contains() {
  local needle="$1"
  shift
  local item
  for item in "$@"; do
    [ "$item" = "$needle" ] && return 0
  done
  return 1
}

run() {
  if [ "$dry_run" -eq 1 ]; then
    printf 'DRY RUN:'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

target_for_agent() {
  case "$1" in
    codex) echo "${CODEX_SKILLS_DIR:-$HOME/.codex/skills}" ;;
    claude) echo "${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}" ;;
    *)
      echo "Unknown agent: $1" >&2
      exit 2
      ;;
  esac
}

read_manifest() {
  local manifest="$1"
  local line
  manifest_names=()
  if [ -f "$manifest" ]; then
    while IFS= read -r line; do
      case "$line" in
        ""|\#*) continue ;;
      esac
      manifest_names+=("$line")
    done < "$manifest"
  fi
}

write_manifest() {
  local target="$1"
  local manifest="$target/$manifest_file"
  if [ "$dry_run" -eq 1 ]; then
    echo "DRY RUN: write $manifest with ${#skill_names[@]} managed skills"
    return
  fi

  {
    echo "# Managed by wen-engineering scripts/sync-skills.sh"
    echo "# mode=$mode"
    printf '%s\n' "${skill_names[@]}"
  } > "$manifest"
}

is_managed_dir() {
  local dest="$1"
  [ -f "$dest/$marker_file" ] && grep -q "wen-engineering" "$dest/$marker_file"
}

sync_one_skill() {
  local target="$1"
  local name="$2"
  local src="$skills_src/$name"
  local dest="$target/$name"

  if [ "$mode" = "link" ]; then
    if [ -e "$dest" ] || [ -L "$dest" ]; then
      run rm -rf "$dest"
    fi
    run ln -s "$src" "$dest"
    return
  fi

  if [ -L "$dest" ]; then
    run rm "$dest"
  fi
  run mkdir -p "$dest"
  run rsync -a --delete --exclude ".DS_Store" "$src/" "$dest/"
  if [ "$dry_run" -eq 1 ]; then
    echo "DRY RUN: write $dest/$marker_file"
  else
    {
      echo "managed-by: wen-engineering"
      echo "source: $repo_root"
    } > "$dest/$marker_file"
  fi
}

sync_target() {
  local agent="$1"
  local target
  target="$(target_for_agent "$agent")"
  local manifest="$target/$manifest_file"
  local conflicts=()
  local name dest src link_target old

  read_manifest "$manifest"

  for name in "${skill_names[@]}"; do
    dest="$target/$name"
    src="$skills_src/$name"
    if [ -e "$dest" ] || [ -L "$dest" ]; then
      if { [ "${#manifest_names[@]}" -gt 0 ] && contains "$name" "${manifest_names[@]}"; } || is_managed_dir "$dest"; then
        continue
      fi
      if [ -L "$dest" ]; then
        link_target="$(readlink "$dest")"
        [ "$link_target" = "$src" ] && continue
      fi
      [ "$force" -eq 1 ] || conflicts+=("$name")
    fi
  done

  if [ "${#conflicts[@]}" -gt 0 ]; then
    echo "Refusing to replace existing unmarked $agent skills in $target:" >&2
    printf '  %s\n' "${conflicts[@]}" >&2
    echo "Re-run with --force if you want this repo to manage those skill names." >&2
    exit 3
  fi

  run mkdir -p "$target"

  if [ "${#manifest_names[@]}" -gt 0 ]; then
    for old in "${manifest_names[@]}"; do
      if ! contains "$old" "${skill_names[@]}"; then
        dest="$target/$old"
        if [ -e "$dest" ] || [ -L "$dest" ]; then
          run rm -rf "$dest"
        fi
      fi
    done
  fi

  for name in "${skill_names[@]}"; do
    sync_one_skill "$target" "$name"
  done

  write_manifest "$target"
  echo "Synced ${#skill_names[@]} skills to $agent: $target"
}

case "$agents" in
  both) agents="codex,claude" ;;
esac

IFS=',' read -r -a requested_agents <<< "$agents"
for agent in "${requested_agents[@]}"; do
  case "$agent" in
    codex|claude) sync_target "$agent" ;;
    "")
      echo "Empty agent name in --agents" >&2
      exit 2
      ;;
    *)
      echo "Unknown agent in --agents: $agent" >&2
      exit 2
      ;;
  esac
done
