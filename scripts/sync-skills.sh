#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: scripts/sync-skills.sh [options]

Synchronize this repo's skills and bundled third-party notice into local agent skill directories.

Options:
  --agents LIST    Comma-separated agents: codex,claude,zcode,kimi,both,all (default: all)
  --mode MODE      copy or link (default: copy)
  --dry-run        Print planned changes without writing
  --force          Replace unmarked active names; back up unmarked retired names
                  and broken reverse links
  --archive-legacy-agents
                  Deprecated no-op; $HOME/.agents/skills is now canonical
  -h, --help       Show this help

Environment overrides:
  CODEX_SKILLS_DIR   Default: $HOME/.codex/skills
  CLAUDE_SKILLS_DIR  Default: $HOME/.claude/skills
  AGENTS_SKILLS_DIR  Default: $HOME/.agents/skills
  ZCODE_SKILLS_DIR   Default: $HOME/.zcode/skills
  KIMI_SKILLS_DIR    Default: $HOME/gstack/.kimi/skills
USAGE
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skills_src="$repo_root/skills"
agents="all"
mode="copy"
dry_run=0
force=0
archive_legacy_agents=0
marker_file=".wen-engineering-managed"
manifest_file=".wen-engineering-skills-manifest"
third_party_notice_name="WEN_THIRD_PARTY_NOTICES.md"
third_party_notice_marker=".wen-engineering-third-party-notice-managed"
third_party_notice_src="$repo_root/THIRD_PARTY_NOTICES.md"
manifest_names=()
# Names this pack no longer ships. Foreign-managed copies (e.g. .wen-pm-managed,
# .wen-test-managed) are left untouched; only this pack's old managed copies retire.
retired_skill_names=("to-prd" "to-issues" "to-test-plan" "qa-run" "grill-with-docs" "domain-modeling")
canonical_skills_dir="${AGENTS_SKILLS_DIR:-$HOME/.agents/skills}"
codex_skills_dir="${CODEX_SKILLS_DIR:-$HOME/.codex/skills}"
claude_skills_dir="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
zcode_skills_dir="${ZCODE_SKILLS_DIR:-$HOME/.zcode/skills}"
kimi_skills_dir="${KIMI_SKILLS_DIR:-$HOME/gstack/.kimi/skills}"
retired_skills_backup_dir="$(dirname "$canonical_skills_dir")/.wen-engineering-retired-skills"
displaced_skills_backup_dir="$(dirname "$canonical_skills_dir")/.wen-engineering-displaced-skills"

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
    --archive-legacy-agents)
      archive_legacy_agents=1
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

contains() {
  local needle="$1"
  shift
  local item
  for item in "$@"; do
    [ "$item" = "$needle" ] && return 0
  done
  return 1
}

skill_names=()
while IFS= read -r skill_name; do
  contains "$skill_name" "${retired_skill_names[@]}" && continue
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
    agents) echo "$canonical_skills_dir" ;;
    codex) echo "$codex_skills_dir" ;;
    claude) echo "$claude_skills_dir" ;;
    zcode) echo "$zcode_skills_dir" ;;
    kimi) echo "$kimi_skills_dir" ;;
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
        "."|".."|*/*)
          echo "Refusing invalid managed skill name in $manifest: $line" >&2
          return 3
          ;;
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

physical_dir() {
  local path="$1"
  (cd "$path" 2>/dev/null && pwd -P)
}

prospective_physical_path() {
  local path="$1"
  local suffix=""
  local parent name

  while [ ! -d "$path" ]; do
    name="$(basename "$path")"
    suffix="/$name$suffix"
    parent="$(dirname "$path")"
    if [ "$parent" = "$path" ]; then
      echo "$path$suffix"
      return
    fi
    path="$parent"
  done

  echo "$(physical_dir "$path")$suffix"
}

path_contains() {
  local parent="$1"
  local child="$2"

  while [ "$parent" != "/" ] && [ "${parent%/}" != "$parent" ]; do
    parent="${parent%/}"
  done
  while [ "$child" != "/" ] && [ "${child%/}" != "$child" ]; do
    child="${child%/}"
  done
  [ "$parent" = "$child" ] && return 0
  if [ "$parent" = "/" ]; then
    case "$child" in
      /*) return 0 ;;
    esac
  fi
  case "$child" in
    "$parent"/*) return 0 ;;
  esac
  return 1
}

link_points_to_canonical() {
  local link="$1"
  local link_target link_physical canonical_physical

  [ -L "$link" ] || return 1
  link_target="$(readlink "$link")"
  [ "$link_target" = "$canonical_skills_dir" ] && return 0

  [ -d "$link" ] && [ -d "$canonical_skills_dir" ] || return 1
  link_physical="$(physical_dir "$link")"
  canonical_physical="$(physical_dir "$canonical_skills_dir")"
  [ "$link_physical" = "$canonical_physical" ]
}

is_managed_retired_skill() {
  local name="$1"
  local dest="$2"
  local link_target

  if { [ "${#manifest_names[@]}" -gt 0 ] && contains "$name" "${manifest_names[@]}"; } || is_managed_dir "$dest"; then
    return 0
  fi
  if [ -L "$dest" ]; then
    link_target="$(readlink "$dest")"
    [ "$link_target" = "$skills_src/$name" ] && return 0
  fi
  return 1
}

# Skills owned by a companion pack (e.g. .wen-pm-managed) must not be retired
# when this repo no longer ships names like to-prd / to-issues.
is_foreign_managed_skill() {
  local dest="$1"
  local marker

  [ -d "$dest" ] || return 1
  for marker in "$dest"/.wen-*-managed; do
    [ -f "$marker" ] || continue
    case "$(basename "$marker")" in
      "$marker_file"|'.wen-engineering-third-party-notice-managed') continue ;;
    esac
    return 0
  done
  return 1
}

is_known_agent_skill_link() {
  local link_target="$1"
  local root root_physical

  case "$link_target" in
    "$canonical_skills_dir"/*|"$codex_skills_dir"/*|"$claude_skills_dir"/*|"$zcode_skills_dir"/*|"$kimi_skills_dir"/*) return 0 ;;
  esac

  case "$link_target" in
    /*)
      for root in "$canonical_skills_dir" "$codex_skills_dir" "$claude_skills_dir" "$zcode_skills_dir" "$kimi_skills_dir"; do
        [ -d "$root" ] || continue
        root_physical="$(physical_dir "$root")"
        path_contains "$root_physical" "$link_target" && return 0
      done
      ;;
  esac
  return 1
}

preflight_canonical_topology() {
  local agent target canonical_physical target_physical

  if [ -L "$canonical_skills_dir" ]; then
    echo "Refusing to use a symlink as the canonical skills root: $canonical_skills_dir" >&2
    echo "Replace it with a real directory before syncing; --force will not create a reverse-link loop." >&2
    return 3
  fi

  canonical_physical="$(prospective_physical_path "$canonical_skills_dir")"

  for agent in "${validated_agents[@]}"; do
    target="$(target_for_agent "$agent")"
    [ "$target" = "$canonical_skills_dir" ] && continue
    link_points_to_canonical "$target" && continue
    if path_contains "$canonical_skills_dir" "$target" || path_contains "$target" "$canonical_skills_dir"; then
      echo "Refusing nested canonical/$agent skills paths:" >&2
      echo "  canonical: $canonical_skills_dir" >&2
      echo "  $agent: $target" >&2
      echo "The canonical and agent roots must be distinct, non-nested directories." >&2
      return 3
    fi
    target_physical="$(prospective_physical_path "$target")"
    if path_contains "$canonical_physical" "$target_physical" || path_contains "$target_physical" "$canonical_physical"; then
      echo "Refusing unsafe canonical/$agent skills topology:" >&2
      echo "  canonical: $canonical_skills_dir -> $canonical_physical" >&2
      echo "  $agent: $target -> $target_physical" >&2
      echo "The canonical and agent roots must be distinct, non-nested directories." >&2
      return 3
    fi
  done
}

preflight_agent_link_conflicts() {
  local conflicts=()
  local agent target

  [ "$force" -eq 0 ] || return 0

  for agent in "${validated_agents[@]}"; do
    target="$(target_for_agent "$agent")"
    [ "$target" = "$canonical_skills_dir" ] && continue
    link_points_to_canonical "$target" && continue
    if [ -e "$target" ] || [ -L "$target" ]; then
      conflicts+=("$agent:$target")
    fi
  done

  if [ "${#conflicts[@]}" -gt 0 ]; then
    echo "Refusing to replace existing agent skill roots without --force:" >&2
    printf '  %s\n' "${conflicts[@]}" >&2
    echo "No canonical skills were changed. Re-run with --force to import and back up those roots." >&2
    return 3
  fi
}

is_managed_third_party_notice() {
  local marker="$canonical_skills_dir/$third_party_notice_marker"
  [ -f "$marker" ] && [ ! -L "$marker" ] && grep -q '^managed-by: wen-engineering$' "$marker"
}

preflight_third_party_notice() {
  local dest="$canonical_skills_dir/$third_party_notice_name"
  local marker="$canonical_skills_dir/$third_party_notice_marker"

  [ -f "$third_party_notice_src" ] || return 0

  if { [ -e "$marker" ] || [ -L "$marker" ]; } && ! is_managed_third_party_notice; then
    echo "Refusing to replace an unmarked third-party notice marker: $marker" >&2
    echo "No canonical skills were changed." >&2
    return 3
  fi

  [ -e "$dest" ] || [ -L "$dest" ] || return 0
  if ! is_managed_third_party_notice; then
    if [ -f "$dest" ] && [ ! -L "$dest" ] && cmp -s "$third_party_notice_src" "$dest"; then
      return 0
    fi
    echo "Refusing to replace an unmarked canonical notice: $dest" >&2
    echo "Move or reconcile it first; no canonical skills were changed." >&2
    return 3
  fi
}

sync_third_party_notice() {
  local target="$1"
  local dest="$target/$third_party_notice_name"
  local marker="$target/$third_party_notice_marker"

  [ -f "$third_party_notice_src" ] || return 0

  run mkdir -p "$target"
  if ! { [ -f "$dest" ] && [ ! -L "$dest" ] && cmp -s "$third_party_notice_src" "$dest"; }; then
    if [ -e "$dest" ] || [ -L "$dest" ]; then
      run rm -rf "$dest"
    fi
    run cp "$third_party_notice_src" "$dest"
  fi
  if [ "$dry_run" -eq 1 ]; then
    echo "DRY RUN: write $marker"
  else
    {
      echo "managed-by: wen-engineering"
      echo "source: $third_party_notice_src"
    } > "$marker"
  fi
}

is_broken_reverse_link() {
  local entry="$1"
  local link_target resolved_target

  [ -L "$entry" ] && [ ! -e "$entry" ] || return 1
  link_target="$(readlink "$entry")"
  case "$link_target" in
    /*) resolved_target="$(prospective_physical_path "$link_target")" ;;
    *) resolved_target="$(prospective_physical_path "$(dirname "$entry")/$link_target")" ;;
  esac
  is_known_agent_skill_link "$link_target" || is_known_agent_skill_link "$resolved_target"
}

is_managed_broken_link() {
  local name="$1"
  local entry="$2"
  local link_target

  if { [ "${#manifest_names[@]}" -gt 0 ] && contains "$name" "${manifest_names[@]}"; } || is_managed_dir "$entry"; then
    return 0
  fi
  link_target="$(readlink "$entry")"
  [ "$link_target" = "$skills_src/$name" ]
}

preflight_broken_reverse_link_conflicts() {
  local target="$canonical_skills_dir"
  local conflicts=()
  local entry name

  [ -d "$target" ] || return 0
  read_manifest "$target/$manifest_file"

  for entry in "$target"/* "$target"/.[!.]* "$target"/..?*; do
    is_broken_reverse_link "$entry" || continue
    name="$(basename "$entry")"
    is_managed_broken_link "$name" "$entry" && continue
    [ "$force" -eq 1 ] || conflicts+=("$name")
  done

  if [ "${#conflicts[@]}" -gt 0 ]; then
    echo "Refusing to remove unmarked broken reverse links in $target:" >&2
    printf '  %s\n' "${conflicts[@]}" >&2
    echo "No canonical skills were changed. Re-run with --force to back them up outside the active skills directory." >&2
    return 3
  fi
}

clean_broken_reverse_links() {
  local target="$canonical_skills_dir"
  local entry name backup

  [ -d "$target" ] || return 0
  read_manifest "$target/$manifest_file"

  for entry in "$target"/* "$target"/.[!.]* "$target"/..?*; do
    is_broken_reverse_link "$entry" || continue
    name="$(basename "$entry")"
    if is_managed_broken_link "$name" "$entry"; then
      run rm "$entry"
      echo "Removed broken managed skill link: $entry"
      continue
    fi
    if [ "$force" -eq 1 ]; then
      backup="$(backup_path "$displaced_skills_backup_dir/$name")"
      run mkdir -p "$displaced_skills_backup_dir"
      run mv "$entry" "$backup"
      echo "Backed up broken unmarked skill link: $entry -> $backup"
    fi
  done
}

check_target_conflicts() {
  local agent="$1"
  local target
  target="$(target_for_agent "$agent")"
  local manifest="$target/$manifest_file"
  local conflicts=()
  local name dest src link_target

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
    return 3
  fi
}

check_retired_skill_conflicts() {
  local target="$canonical_skills_dir"
  local manifest="$target/$manifest_file"
  local conflicts=()
  local name dest

  read_manifest "$manifest"

  for name in "${retired_skill_names[@]}"; do
    dest="$target/$name"
    [ -e "$dest" ] || [ -L "$dest" ] || continue
    # Leave companion-pack skills (e.g. wen-pm to-prd/to-issues) untouched.
    is_foreign_managed_skill "$dest" && continue
    is_managed_retired_skill "$name" "$dest" && continue
    [ "$force" -eq 1 ] || conflicts+=("$name")
  done

  if [ "${#conflicts[@]}" -gt 0 ]; then
    echo "Refusing to retire existing unmarked canonical skills in $target:" >&2
    printf '  %s\n' "${conflicts[@]}" >&2
    echo "Re-run with --force to back them up outside the active skills directory." >&2
    return 3
  fi
}

retire_canonical_skills() {
  local target="$canonical_skills_dir"
  local manifest="$target/$manifest_file"
  local name dest backup

  read_manifest "$manifest"

  for name in "${retired_skill_names[@]}"; do
    dest="$target/$name"
    [ -e "$dest" ] || [ -L "$dest" ] || continue
    if is_foreign_managed_skill "$dest"; then
      echo "Keeping foreign-managed skill (not retiring): $dest"
      continue
    fi
    if is_managed_retired_skill "$name" "$dest"; then
      run rm -rf "$dest"
      echo "Removed retired managed skill: $dest"
      continue
    fi

    if [ "$force" -eq 1 ]; then
      backup="$(backup_path "$retired_skills_backup_dir/$name")"
      run mkdir -p "$retired_skills_backup_dir"
      run mv "$dest" "$backup"
      echo "Backed up retired unmarked skill: $dest -> $backup"
    fi
  done
}

archive_legacy_agents_skills() {
  if [ "$archive_legacy_agents" -eq 1 ]; then
    echo "--archive-legacy-agents is no longer needed; $canonical_skills_dir is canonical."
  fi
}

entry_import_mode() {
  local entry="$1"
  local link_target resolved_target

  if [ ! -L "$entry" ]; then
    echo "copy"
    return
  fi

  link_target="$(readlink "$entry")"
  resolved_target="$(physical_dir "$entry")"
  if is_known_agent_skill_link "$link_target" || is_known_agent_skill_link "$resolved_target"; then
    echo "copy"
  else
    echo "link"
  fi
}

external_entries_match() {
  local left="$1"
  local right="$2"
  local left_mode right_mode left_target right_target

  left_mode="$(entry_import_mode "$left")"
  right_mode="$(entry_import_mode "$right")"
  [ "$left_mode" = "$right_mode" ] || return 1

  if [ "$left_mode" = "link" ]; then
    left_target="$(physical_dir "$left")"
    right_target="$(physical_dir "$right")"
    [ "$left_target" = "$right_target" ]
    return
  fi

  diff -qr "$left/" "$right/" >/dev/null 2>&1
}

external_names=()
external_paths=()
external_owners=()

register_external_entry() {
  local owner="$1"
  local name="$2"
  local entry="$3"
  local i

  i=0
  while [ "$i" -lt "${#external_names[@]}" ]; do
    if [ "${external_names[$i]}" = "$name" ]; then
      if external_entries_match "${external_paths[$i]}" "$entry"; then
        return 0
      fi
      echo "Refusing to merge different external skills named '$name':" >&2
      echo "  ${external_owners[$i]}: ${external_paths[$i]}" >&2
      echo "  $owner: $entry" >&2
      echo "Resolve the name collision before syncing; no canonical skills were changed." >&2
      return 3
    fi
    i=$((i + 1))
  done

  external_names+=("$name")
  external_paths+=("$entry")
  external_owners+=("$owner")
}

scan_external_entries() {
  local owner="$1"
  local target="$2"
  local use_manifest="$3"
  local entry name

  [ -d "$target" ] || return 0

  if [ "$use_manifest" -eq 1 ]; then
    read_manifest "$target/$manifest_file"
  else
    manifest_names=()
  fi

  for entry in "$target"/* "$target"/.[!.]* "$target"/..?*; do
    [ -e "$entry" ] || [ -L "$entry" ] || continue
    name="$(basename "$entry")"
    case "$name" in
      "."|".."|"$manifest_file") continue ;;
    esac
    contains "$name" "${retired_skill_names[@]}" && continue
    contains "$name" "${skill_names[@]}" && continue
    if [ "${#manifest_names[@]}" -gt 0 ] && contains "$name" "${manifest_names[@]}"; then
      continue
    fi
    [ -d "$entry" ] || [ -L "$entry" ] || continue
    if [ -L "$entry" ] && [ ! -e "$entry" ]; then
      continue
    fi
    register_external_entry "$owner" "$name" "$entry"
  done
}

preflight_external_skill_conflicts() {
  local agent target

  [ "$force" -eq 1 ] || return 0

  external_names=()
  external_paths=()
  external_owners=()

  scan_external_entries "canonical" "$canonical_skills_dir" 1
  for agent in "${validated_agents[@]}"; do
    target="$(target_for_agent "$agent")"
    [ "$target" = "$canonical_skills_dir" ] && continue
    link_points_to_canonical "$target" && continue
    scan_external_entries "$agent" "$target" 0
  done
}

copy_skill_entry() {
  local src="$1"
  local dest="$2"
  local link_target resolved_target

  if [ -L "$src" ]; then
    link_target="$(readlink "$src")"
    resolved_target="$(physical_dir "$src")"
    if ! is_known_agent_skill_link "$link_target" && ! is_known_agent_skill_link "$resolved_target"; then
      run ln -s "$resolved_target" "$dest"
      return
    fi
  fi

  run mkdir -p "$dest"
  run rsync -a --exclude ".DS_Store" "$src/" "$dest/"
}

import_existing_skills() {
  local agent="$1"
  local target="$2"
  local canonical="$canonical_skills_dir"
  local entry name dest imported link_target

  [ -d "$target" ] || return 0
  [ "$target" = "$canonical" ] && return 0
  link_points_to_canonical "$target" && return 0

  imported=0
  run mkdir -p "$canonical"

  for entry in "$target"/* "$target"/.[!.]* "$target"/..?*; do
    [ -e "$entry" ] || [ -L "$entry" ] || continue
    name="$(basename "$entry")"
    case "$name" in
      "."|".."|"$manifest_file") continue ;;
    esac
    contains "$name" "${retired_skill_names[@]}" && continue
    contains "$name" "${skill_names[@]}" && continue
    [ -d "$entry" ] || [ -L "$entry" ] || continue
    if [ -L "$entry" ] && [ ! -e "$entry" ]; then
      continue
    fi
    dest="$canonical/$name"
    if [ -L "$dest" ]; then
      link_target="$(readlink "$dest")"
      if is_known_agent_skill_link "$link_target"; then
        run rm "$dest"
      else
        continue
      fi
    elif [ -e "$dest" ]; then
      continue
    fi
    copy_skill_entry "$entry" "$dest"
    imported=$((imported + 1))
  done

  if [ "$imported" -gt 0 ]; then
    echo "Imported $imported existing $agent skills into canonical: $canonical"
  fi
}

backup_path() {
  local path="$1"
  local stamp candidate n

  stamp="$(date +%Y%m%d%H%M%S)"
  candidate="$path.wen-engineering-backup-$stamp"
  n=1
  while [ -e "$candidate" ] || [ -L "$candidate" ]; do
    candidate="$path.wen-engineering-backup-$stamp-$n"
    n=$((n + 1))
  done

  echo "$candidate"
}

ensure_agent_link() {
  local agent="$1"
  local target canonical parent link_target backup

  target="$(target_for_agent "$agent")"
  canonical="$canonical_skills_dir"

  [ "$target" = "$canonical" ] && return 0

  if link_points_to_canonical "$target"; then
    echo "Linked $agent skills: $target -> $canonical"
    return 0
  elif [ -L "$target" ]; then
    link_target="$(readlink "$target")"
    [ "$force" -eq 1 ] || {
      echo "Refusing to replace existing $agent skills link: $target" >&2
      echo "Re-run with --force to point it at $canonical." >&2
      return 3
    }
    run rm "$target"
  elif [ -e "$target" ]; then
    [ "$force" -eq 1 ] || {
      echo "Refusing to replace existing $agent skills directory with a symlink: $target" >&2
      echo "Re-run with --force to migrate missing entries into $canonical and back it up." >&2
      return 3
    }
    backup="$(backup_path "$target")"
    run mv "$target" "$backup"
    echo "Backed up existing $agent skills to $backup"
  fi

  parent="$(dirname "$target")"
  run mkdir -p "$parent"
  run ln -s "$canonical" "$target"
  echo "Linked $agent skills: $target -> $canonical"
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
  local name dest old

  run mkdir -p "$target"

  read_manifest "$manifest"

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

append_agent() {
  local agent="$1"
  if [ "${#validated_agents[@]}" -eq 0 ]; then
    validated_agents+=("$agent")
    return
  fi
  contains "$agent" "${validated_agents[@]}" || validated_agents+=("$agent")
}

IFS=',' read -r -a requested_agents <<< "$agents"
validated_agents=()
for agent in "${requested_agents[@]}"; do
  case "$agent" in
    all)
      append_agent codex
      append_agent claude
      append_agent zcode
      append_agent kimi
      ;;
    both)
      append_agent codex
      append_agent claude
      ;;
    codex|claude|zcode|kimi) append_agent "$agent" ;;
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

preflight_canonical_topology
preflight_agent_link_conflicts
preflight_third_party_notice
check_target_conflicts agents
check_retired_skill_conflicts
preflight_external_skill_conflicts
preflight_broken_reverse_link_conflicts
clean_broken_reverse_links
retire_canonical_skills

sync_target agents
sync_third_party_notice "$canonical_skills_dir"

if [ "$force" -eq 1 ]; then
  for agent in "${validated_agents[@]}"; do
    import_existing_skills "$agent" "$(target_for_agent "$agent")"
  done
fi

for agent in "${validated_agents[@]}"; do
  ensure_agent_link "$agent"
done

archive_legacy_agents_skills
