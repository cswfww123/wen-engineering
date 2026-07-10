#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
sync_script="$repo_root/scripts/sync-skills.sh"
test_root="$(mktemp -d "${TMPDIR:-/tmp}/wen-sync-skills.XXXXXX")"

cleanup() {
  rm -rf "$test_root"
}
trap cleanup EXIT HUP INT TERM

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

new_fixture() {
  local name="$1"

  fixture_root="$test_root/$name"
  fixture_repo="$fixture_root/repo"
  fixture_home="$fixture_root/home"
  fixture_canonical="$fixture_home/.agents/skills"
  fixture_codex="$fixture_home/.codex/skills"
  fixture_claude="$fixture_home/.claude/skills"
  fixture_zcode="$fixture_home/.zcode/skills"
  fixture_kimi="$fixture_home/gstack/.kimi/skills"

  mkdir -p "$fixture_repo/scripts" "$fixture_repo/skills/active" "$fixture_home"
  cp "$sync_script" "$fixture_repo/scripts/sync-skills.sh"
  if [ -f "$repo_root/THIRD_PARTY_NOTICES.md" ]; then
    cp "$repo_root/THIRD_PARTY_NOTICES.md" "$fixture_repo/THIRD_PARTY_NOTICES.md"
  fi
  printf '%s\n' '---' 'name: active' 'description: Fixture skill.' '---' > "$fixture_repo/skills/active/SKILL.md"
}

run_fixture() {
  env \
    HOME="$fixture_home" \
    AGENTS_SKILLS_DIR="$fixture_canonical" \
    CODEX_SKILLS_DIR="$fixture_codex" \
    CLAUDE_SKILLS_DIR="$fixture_claude" \
    ZCODE_SKILLS_DIR="$fixture_zcode" \
    KIMI_SKILLS_DIR="$fixture_kimi" \
    bash "$fixture_repo/scripts/sync-skills.sh" --mode link "$@"
}

test_unmarked_retired_skill_blocks_without_force() {
  local status

  new_fixture "unmarked-retired-no-force"
  mkdir -p "$fixture_canonical/to-prd"
  printf '%s\n' 'custom retired skill' > "$fixture_canonical/to-prd/SKILL.md"

  if run_fixture --agents codex > "$fixture_root/output" 2>&1; then
    fail "unmarked canonical to-prd should block sync without --force"
  else
    status=$?
  fi

  [ "$status" -eq 3 ] || fail "expected conflict exit 3, got $status"
  grep -q 'to-prd' "$fixture_root/output" || fail "conflict output should name to-prd"
  grep -q 'custom retired skill' "$fixture_canonical/to-prd/SKILL.md" || fail "blocked sync changed the retired skill"
  [ ! -e "$fixture_canonical/active" ] || fail "blocked sync should not make partial canonical changes"
}

test_force_backs_up_unmarked_retired_skill() {
  local backups=()

  new_fixture "unmarked-retired-force"
  mkdir -p "$fixture_canonical/to-prd"
  printf '%s\n' 'custom retired skill' > "$fixture_canonical/to-prd/SKILL.md"

  run_fixture --agents codex --force > "$fixture_root/output" 2>&1

  [ ! -e "$fixture_canonical/to-prd" ] && [ ! -L "$fixture_canonical/to-prd" ] || fail "--force left to-prd discoverable"
  backups=("$fixture_home/.agents/.wen-engineering-retired-skills"/to-prd.wen-engineering-backup-*)
  [ -e "${backups[0]}" ] || fail "--force did not back up unmarked to-prd"
  [ "${#backups[@]}" -eq 1 ] || fail "expected one retired-skill backup"
  case "${backups[0]}" in
    "$fixture_canonical"/*) fail "retired backup must be outside the active skills root" ;;
  esac
  grep -q 'custom retired skill' "${backups[0]}/SKILL.md" || fail "retired backup did not preserve custom content"
  [ -L "$fixture_canonical/active" ] || fail "forced sync did not install active skill"
  [ -L "$fixture_codex" ] || fail "forced sync did not link Codex to canonical skills"
}

test_managed_retired_skills_are_removed() {
  new_fixture "managed-retired"
  mkdir -p "$fixture_repo/skills/to-prd"
  printf '%s\n' 'retired repo source' > "$fixture_repo/skills/to-prd/SKILL.md"
  mkdir -p "$fixture_canonical/to-prd" "$fixture_canonical/to-issues" "$fixture_canonical/obsolete-managed" "$fixture_canonical/unrelated"
  printf '%s\n' 'old manifest copy' > "$fixture_canonical/to-prd/SKILL.md"
  printf '%s\n' 'old marked copy' > "$fixture_canonical/to-issues/SKILL.md"
  printf '%s\n' 'old generic manifest copy' > "$fixture_canonical/obsolete-managed/SKILL.md"
  printf '%s\n' 'managed-by: wen-engineering' > "$fixture_canonical/to-issues/.wen-engineering-managed"
  printf '%s\n' 'keep me' > "$fixture_canonical/unrelated/SKILL.md"
  printf '%s\n' '# Managed by fixture' 'to-prd' 'obsolete-managed' > "$fixture_canonical/.wen-engineering-skills-manifest"

  run_fixture --agents codex > "$fixture_root/output" 2>&1

  [ ! -e "$fixture_canonical/to-prd" ] && [ ! -L "$fixture_canonical/to-prd" ] || fail "old manifest copy of to-prd was not removed"
  [ ! -e "$fixture_canonical/to-issues" ] && [ ! -L "$fixture_canonical/to-issues" ] || fail "marked copy of to-issues was not removed"
  [ ! -e "$fixture_canonical/obsolete-managed" ] || fail "generic old manifest entry was not removed"
  ! grep -q '^to-prd$' "$fixture_canonical/.wen-engineering-skills-manifest" || fail "new manifest retained to-prd"
  ! grep -q '^to-issues$' "$fixture_canonical/.wen-engineering-skills-manifest" || fail "new manifest retained to-issues"
  grep -q 'keep me' "$fixture_canonical/unrelated/SKILL.md" || fail "sync changed an unrelated canonical skill"
}

test_agent_import_does_not_resurrect_retired_skills() {
  new_fixture "agent-import"
  mkdir -p \
    "$fixture_codex/to-prd" "$fixture_codex/external-codex" \
    "$fixture_claude/to-issues" "$fixture_claude/external-claude" \
    "$fixture_zcode/to-prd" "$fixture_zcode/external-zcode" \
    "$fixture_kimi/to-issues" "$fixture_kimi/external-kimi"
  printf '%s\n' 'retired agent copy' > "$fixture_codex/to-prd/SKILL.md"
  printf '%s\n' 'second retired agent copy' > "$fixture_claude/to-issues/SKILL.md"
  printf '%s\n' 'third retired agent copy' > "$fixture_zcode/to-prd/SKILL.md"
  printf '%s\n' 'fourth retired agent copy' > "$fixture_kimi/to-issues/SKILL.md"
  printf '%s\n' 'preserve Codex skill' > "$fixture_codex/external-codex/SKILL.md"
  printf '%s\n' 'preserve Claude skill' > "$fixture_claude/external-claude/SKILL.md"
  printf '%s\n' 'preserve ZCode skill' > "$fixture_zcode/external-zcode/SKILL.md"
  printf '%s\n' 'preserve Kimi skill' > "$fixture_kimi/external-kimi/SKILL.md"

  run_fixture --agents all --force > "$fixture_root/output" 2>&1

  [ ! -e "$fixture_canonical/to-prd" ] && [ ! -L "$fixture_canonical/to-prd" ] || fail "agent import resurrected to-prd"
  [ ! -e "$fixture_canonical/to-issues" ] && [ ! -L "$fixture_canonical/to-issues" ] || fail "agent import resurrected to-issues"
  grep -q 'preserve Codex skill' "$fixture_canonical/external-codex/SKILL.md" || fail "agent import lost an unrelated Codex skill"
  grep -q 'preserve Claude skill' "$fixture_canonical/external-claude/SKILL.md" || fail "agent import lost an unrelated Claude skill"
  grep -q 'preserve ZCode skill' "$fixture_canonical/external-zcode/SKILL.md" || fail "agent import lost an unrelated ZCode skill"
  grep -q 'preserve Kimi skill' "$fixture_canonical/external-kimi/SKILL.md" || fail "agent import lost an unrelated Kimi skill"
  [ -L "$fixture_codex" ] || fail "Codex skills directory was not linked to canonical"
  [ -L "$fixture_claude" ] || fail "Claude skills directory was not linked to canonical"
  [ -L "$fixture_zcode" ] || fail "ZCode skills directory was not linked to canonical"
  [ -L "$fixture_kimi" ] || fail "Kimi skills directory was not linked to canonical"
  [ ! -e "$fixture_codex/to-prd" ] && [ ! -L "$fixture_codex/to-prd" ] || fail "retired skill remains discoverable through Codex"
  [ ! -e "$fixture_claude/to-issues" ] && [ ! -L "$fixture_claude/to-issues" ] || fail "retired skill remains discoverable through Claude"
  [ ! -e "$fixture_zcode/to-prd" ] && [ ! -L "$fixture_zcode/to-prd" ] || fail "retired skill remains discoverable through ZCode"
  [ ! -e "$fixture_kimi/to-issues" ] && [ ! -L "$fixture_kimi/to-issues" ] || fail "retired skill remains discoverable through Kimi"
}

test_unmarked_active_conflict_is_preserved() {
  local status

  new_fixture "active-conflict"
  mkdir -p "$fixture_canonical/active" "$fixture_canonical/unrelated"
  printf '%s\n' 'custom active skill' > "$fixture_canonical/active/SKILL.md"
  printf '%s\n' 'keep unrelated skill' > "$fixture_canonical/unrelated/SKILL.md"

  if run_fixture --agents codex > "$fixture_root/output" 2>&1; then
    fail "unmarked active skill should block sync without --force"
  else
    status=$?
  fi

  [ "$status" -eq 3 ] || fail "expected active conflict exit 3, got $status"
  grep -q 'custom active skill' "$fixture_canonical/active/SKILL.md" || fail "conflict handling overwrote the active skill"
  grep -q 'keep unrelated skill' "$fixture_canonical/unrelated/SKILL.md" || fail "conflict handling changed an unrelated skill"
  [ ! -e "$fixture_canonical/.wen-engineering-skills-manifest" ] || fail "conflict handling wrote a partial manifest"
  [ ! -e "$fixture_codex" ] && [ ! -L "$fixture_codex" ] || fail "conflict handling changed the Codex skills target"
}

test_agent_root_conflict_has_zero_canonical_mutation() {
  local status

  new_fixture "agent-root-preflight"
  mkdir -p "$fixture_canonical/to-prd" "$fixture_claude/custom-claude"
  printf '%s\n' 'old managed retired skill' > "$fixture_canonical/to-prd/SKILL.md"
  printf '%s\n' '# Managed by fixture' 'to-prd' > "$fixture_canonical/.wen-engineering-skills-manifest"
  printf '%s\n' 'keep Claude root' > "$fixture_claude/custom-claude/SKILL.md"
  cp "$fixture_canonical/.wen-engineering-skills-manifest" "$fixture_root/manifest.before"

  if run_fixture --agents all > "$fixture_root/output" 2>&1; then
    fail "an existing selected agent root should block sync without --force"
  else
    status=$?
  fi

  [ "$status" -eq 3 ] || fail "expected agent-root conflict exit 3, got $status"
  grep -q 'No canonical skills were changed' "$fixture_root/output" || fail "agent-root conflict did not report zero mutation"
  cmp -s "$fixture_root/manifest.before" "$fixture_canonical/.wen-engineering-skills-manifest" || fail "agent-root conflict changed the canonical manifest"
  grep -q 'old managed retired skill' "$fixture_canonical/to-prd/SKILL.md" || fail "agent-root preflight retired a canonical skill"
  [ ! -e "$fixture_canonical/active" ] && [ ! -L "$fixture_canonical/active" ] || fail "agent-root conflict installed a partial active skill"
  [ ! -e "$fixture_codex" ] && [ ! -L "$fixture_codex" ] || fail "agent-root preflight partially linked Codex"
  grep -q 'keep Claude root' "$fixture_claude/custom-claude/SKILL.md" || fail "agent-root preflight changed Claude"
}

test_invalid_manifest_path_is_refused_before_mutation() {
  local status

  new_fixture "invalid-manifest-path"
  mkdir -p "$fixture_canonical" "$fixture_home/.agents/sentinel"
  printf '%s\n' 'keep parent directory' > "$fixture_home/.agents/sentinel/value"
  printf '%s\n' '# Managed by fixture' '..' > "$fixture_canonical/.wen-engineering-skills-manifest"

  if run_fixture --agents codex --force > "$fixture_root/output" 2>&1; then
    fail "a manifest traversal name should block sync"
  else
    status=$?
  fi

  [ "$status" -eq 3 ] || fail "expected invalid-manifest exit 3, got $status"
  grep -q 'invalid managed skill name' "$fixture_root/output" || fail "invalid manifest output did not explain the refusal"
  grep -q 'keep parent directory' "$fixture_home/.agents/sentinel/value" || fail "invalid manifest escaped the canonical root"
  [ ! -e "$fixture_canonical/active" ] && [ ! -L "$fixture_canonical/active" ] || fail "invalid manifest installed a partial active skill"
}

test_canonical_reverse_link_is_refused_without_mutation() {
  local status

  new_fixture "canonical-reverse-link"
  mkdir -p "$fixture_codex/external" "$(dirname "$fixture_canonical")"
  printf '%s\n' 'keep reverse-linked skill' > "$fixture_codex/external/SKILL.md"
  ln -s "$fixture_codex" "$fixture_canonical"

  if run_fixture --agents codex --force > "$fixture_root/output" 2>&1; then
    fail "a canonical reverse link should be refused even with --force"
  else
    status=$?
  fi

  [ "$status" -eq 3 ] || fail "expected reverse-link conflict exit 3, got $status"
  grep -q 'canonical skills root' "$fixture_root/output" || fail "reverse-link refusal did not explain the canonical root"
  [ -L "$fixture_canonical" ] || fail "reverse-link preflight replaced the canonical link"
  [ "$(readlink "$fixture_canonical")" = "$fixture_codex" ] || fail "reverse-link preflight rewired canonical"
  [ ! -L "$fixture_codex" ] || fail "reverse-link preflight rewired Codex into a loop"
  grep -q 'keep reverse-linked skill' "$fixture_codex/external/SKILL.md" || fail "reverse-link preflight changed Codex content"
  [ ! -e "$fixture_codex/active" ] && [ ! -L "$fixture_codex/active" ] || fail "reverse-link preflight installed a partial active skill"
  [ ! -e "$fixture_codex/.wen-engineering-skills-manifest" ] || fail "reverse-link preflight wrote a manifest through the link"
}

test_canonical_parent_alias_is_refused_without_mutation() {
  local status

  new_fixture "canonical-parent-alias"
  mkdir -p "$fixture_codex/external"
  printf '%s\n' 'keep physically aliased skill' > "$fixture_codex/external/SKILL.md"
  ln -s "$fixture_home/.codex" "$fixture_home/.agents"

  if run_fixture --agents codex --force > "$fixture_root/output" 2>&1; then
    fail "a canonical parent alias should be refused even when the leaf is not a symlink"
  else
    status=$?
  fi

  [ "$status" -eq 3 ] || fail "expected parent-alias conflict exit 3, got $status"
  grep -q 'unsafe canonical/codex skills topology' "$fixture_root/output" || fail "parent-alias refusal did not explain the topology"
  [ -L "$fixture_home/.agents" ] || fail "parent-alias preflight replaced the parent link"
  [ ! -L "$fixture_codex" ] || fail "parent-alias preflight rewired Codex"
  grep -q 'keep physically aliased skill' "$fixture_codex/external/SKILL.md" || fail "parent-alias preflight changed Codex content"
  [ ! -e "$fixture_codex/active" ] && [ ! -L "$fixture_codex/active" ] || fail "parent-alias preflight installed a partial active skill"
  [ ! -e "$fixture_codex/.wen-engineering-skills-manifest" ] || fail "parent-alias preflight wrote a manifest"

  new_fixture "canonical-parent-alias-missing-leaf"
  mkdir -p "$fixture_home/.codex"
  ln -s "$fixture_home/.codex" "$fixture_home/.agents"
  if run_fixture --agents codex --force > "$fixture_root/output" 2>&1; then
    fail "a parent alias should be refused before either skills leaf exists"
  else
    status=$?
  fi

  [ "$status" -eq 3 ] || fail "expected missing-leaf parent-alias exit 3, got $status"
  [ ! -e "$fixture_codex" ] && [ ! -L "$fixture_codex" ] || fail "missing-leaf parent alias created or linked the agent root"
}

test_different_external_skill_namesakes_block_before_mutation() {
  local status

  new_fixture "external-name-collision"
  mkdir -p "$fixture_codex/shared-name" "$fixture_claude/shared-name"
  printf '%s\n' 'Codex version' > "$fixture_codex/shared-name/SKILL.md"
  printf '%s\n' 'Claude version' > "$fixture_claude/shared-name/SKILL.md"

  if run_fixture --agents codex,claude --force > "$fixture_root/output" 2>&1; then
    fail "different same-name external skills should block forced migration"
  else
    status=$?
  fi

  [ "$status" -eq 3 ] || fail "expected external collision exit 3, got $status"
  grep -q "different external skills named 'shared-name'" "$fixture_root/output" || fail "external collision output did not name the skill"
  [ ! -e "$fixture_canonical" ] && [ ! -L "$fixture_canonical" ] || fail "external collision created canonical state"
  [ ! -L "$fixture_codex" ] && [ ! -L "$fixture_claude" ] || fail "external collision replaced an agent root"
  grep -q 'Codex version' "$fixture_codex/shared-name/SKILL.md" || fail "external collision changed Codex content"
  grep -q 'Claude version' "$fixture_claude/shared-name/SKILL.md" || fail "external collision changed Claude content"
}

test_identical_external_skill_namesakes_merge_safely() {
  new_fixture "identical-external-name"
  mkdir -p "$fixture_codex/shared-name" "$fixture_claude/shared-name"
  printf '%s\n' 'same external skill' > "$fixture_codex/shared-name/SKILL.md"
  printf '%s\n' 'same external skill' > "$fixture_claude/shared-name/SKILL.md"

  run_fixture --agents codex,claude --force > "$fixture_root/output" 2>&1

  grep -q 'same external skill' "$fixture_canonical/shared-name/SKILL.md" || fail "identical external skill was not imported"
  [ -L "$fixture_codex" ] && [ -L "$fixture_claude" ] || fail "identical external skills did not finish shared-root linking"
}

test_kimi_relative_symlink_keeps_its_target() {
  local expected_target

  new_fixture "kimi-relative-symlink"
  mkdir -p "$fixture_kimi" "$(dirname "$fixture_kimi")/shared/external-relative"
  printf '%s\n' 'Kimi relative external skill' > "$(dirname "$fixture_kimi")/shared/external-relative/SKILL.md"
  ln -s ../shared/external-relative "$fixture_kimi/external-relative"
  expected_target="$(cd "$(dirname "$fixture_kimi")/shared/external-relative" && pwd -P)"

  run_fixture --agents kimi --force > "$fixture_root/output" 2>&1

  [ -L "$fixture_canonical/external-relative" ] || fail "Kimi relative skill was not preserved as a link"
  [ "$(readlink "$fixture_canonical/external-relative")" = "$expected_target" ] || fail "Kimi relative link was not rebased to its absolute target"
  grep -q 'Kimi relative external skill' "$fixture_canonical/external-relative/SKILL.md" || fail "rebased Kimi link does not resolve to the original skill"
  [ -L "$fixture_kimi" ] || fail "Kimi root was not linked to canonical"
  [ "$(readlink "$fixture_kimi")" = "$fixture_canonical" ] || fail "Kimi root points at the wrong canonical directory"
}

test_third_party_notice_is_packaged_and_conflict_safe() {
  local status

  new_fixture "third-party-notice-install"
  run_fixture --agents codex > "$fixture_root/output" 2>&1

  cmp -s "$fixture_repo/THIRD_PARTY_NOTICES.md" "$fixture_canonical/WEN_THIRD_PARTY_NOTICES.md" || fail "canonical third-party notice does not match the repo notice"
  grep -q '^managed-by: wen-engineering$' "$fixture_canonical/.wen-engineering-third-party-notice-managed" || fail "canonical third-party notice has no managed marker"
  [ -L "$fixture_codex" ] || fail "notice installation did not finish agent linking"

  new_fixture "third-party-notice-update"
  mkdir -p "$fixture_canonical"
  printf '%s\n' 'old managed notice' > "$fixture_canonical/WEN_THIRD_PARTY_NOTICES.md"
  printf '%s\n' 'managed-by: wen-engineering' > "$fixture_canonical/.wen-engineering-third-party-notice-managed"
  run_fixture --agents codex > "$fixture_root/output" 2>&1
  cmp -s "$fixture_repo/THIRD_PARTY_NOTICES.md" "$fixture_canonical/WEN_THIRD_PARTY_NOTICES.md" || fail "managed third-party notice was not updated"

  new_fixture "third-party-notice-conflict"
  mkdir -p "$fixture_canonical"
  printf '%s\n' 'user-owned notice' > "$fixture_canonical/WEN_THIRD_PARTY_NOTICES.md"
  if run_fixture --agents codex --force > "$fixture_root/output" 2>&1; then
    fail "an unmarked third-party notice conflict should block even with --force"
  else
    status=$?
  fi

  [ "$status" -eq 3 ] || fail "expected third-party notice conflict exit 3, got $status"
  grep -q 'unmarked canonical notice' "$fixture_root/output" || fail "notice conflict output did not explain the refusal"
  grep -q 'user-owned notice' "$fixture_canonical/WEN_THIRD_PARTY_NOTICES.md" || fail "notice conflict overwrote user content"
  [ ! -e "$fixture_canonical/active" ] && [ ! -L "$fixture_canonical/active" ] || fail "notice conflict installed a partial active skill"
  [ ! -e "$fixture_canonical/.wen-engineering-skills-manifest" ] || fail "notice conflict wrote a partial manifest"
}

test_broken_reverse_links_require_ownership_or_backup() {
  local status
  local link_target
  local backups=()

  new_fixture "broken-reverse-link-no-force"
  mkdir -p "$fixture_canonical"
  link_target="$fixture_codex/user-owned"
  ln -s "$link_target" "$fixture_canonical/user-owned"

  if run_fixture --agents codex > "$fixture_root/output" 2>&1; then
    fail "an unmarked broken reverse link should block normal sync"
  else
    status=$?
  fi

  [ "$status" -eq 3 ] || fail "expected broken-link conflict exit 3, got $status"
  grep -q 'unmarked broken reverse links' "$fixture_root/output" || fail "broken-link conflict did not explain the refusal"
  [ -L "$fixture_canonical/user-owned" ] || fail "normal sync deleted an unmarked broken link"
  [ "$(readlink "$fixture_canonical/user-owned")" = "$link_target" ] || fail "normal sync rewrote an unmarked broken link"
  [ ! -e "$fixture_canonical/active" ] && [ ! -L "$fixture_canonical/active" ] || fail "broken-link conflict installed a partial active skill"
  [ ! -e "$fixture_codex" ] && [ ! -L "$fixture_codex" ] || fail "broken-link conflict changed the Codex root"

  new_fixture "broken-reverse-link-force"
  mkdir -p "$fixture_canonical"
  link_target="$fixture_codex/user-owned"
  ln -s "$link_target" "$fixture_canonical/user-owned"
  run_fixture --agents codex --force > "$fixture_root/output" 2>&1

  [ ! -e "$fixture_canonical/user-owned" ] && [ ! -L "$fixture_canonical/user-owned" ] || fail "forced sync left a broken reverse link active"
  backups=("$fixture_home/.agents/.wen-engineering-displaced-skills"/user-owned.wen-engineering-backup-*)
  [ "${#backups[@]}" -eq 1 ] && [ -L "${backups[0]}" ] || fail "forced sync did not back up the broken reverse link"
  [ "$(readlink "${backups[0]}")" = "$link_target" ] || fail "broken-link backup did not preserve its target"
  [ -L "$fixture_canonical/active" ] || fail "forced broken-link migration did not install the active skill"
  [ -L "$fixture_codex" ] || fail "forced broken-link migration did not link Codex"

  new_fixture "broken-reverse-link-managed"
  mkdir -p "$fixture_canonical"
  ln -s "$fixture_codex/obsolete-managed" "$fixture_canonical/obsolete-managed"
  printf '%s\n' '# Managed by fixture' 'obsolete-managed' > "$fixture_canonical/.wen-engineering-skills-manifest"
  run_fixture --agents codex > "$fixture_root/output" 2>&1

  [ ! -e "$fixture_canonical/obsolete-managed" ] && [ ! -L "$fixture_canonical/obsolete-managed" ] || fail "normal sync retained a proven managed broken link"
  [ -L "$fixture_canonical/active" ] || fail "managed broken-link cleanup did not install the active skill"
  [ -L "$fixture_codex" ] || fail "managed broken-link cleanup did not link Codex"
}

test_unmarked_retired_skill_blocks_without_force
test_force_backs_up_unmarked_retired_skill
test_managed_retired_skills_are_removed
test_agent_import_does_not_resurrect_retired_skills
test_unmarked_active_conflict_is_preserved
test_agent_root_conflict_has_zero_canonical_mutation
test_invalid_manifest_path_is_refused_before_mutation
test_canonical_reverse_link_is_refused_without_mutation
test_canonical_parent_alias_is_refused_without_mutation
test_different_external_skill_namesakes_block_before_mutation
test_identical_external_skill_namesakes_merge_safely
test_kimi_relative_symlink_keeps_its_target
test_third_party_notice_is_packaged_and_conflict_safe
test_broken_reverse_links_require_ownership_or_backup
echo "PASS: sync-skills safety fixture"
