# Skill Review

Applies to: reviewing new or changed skill folders before acceptance
Source: `docs/invocation.md`, `skills/skill-review/SKILL.md`, user report that overlong descriptions caused Codex skill discovery failures

## Rules

- [MUST] Review the `description:` first; if the agent cannot discover the skill, the rest of the skill cannot help.
- [MUST] Flag descriptions over 180 characters as too long.
- [SHOULD] Prefer descriptions under 120 characters.
- [MUST] Review the invocation boundary: user-invoked skills should not carry model trigger prose, and model-invoked skills need concrete trigger language.
- [MUST] Check trigger clarity, progressive disclosure, judgment preservation, output clarity, side effects, and reference depth.
- [MUST] For model-invoked side effects, require an explicit matching request or active authorized orchestration, bounded reversible changes, and no new tracker/relationship/canonical-plan/manifest/deployment/external-system authority.
- [MUST] Require evidence-only research/prototype skills to preserve production behavior; require code-editing disciplines to stay inside the authorized diff and provide verification plus rollback or behavior-preservation boundaries.
- [SHOULD] Treat `SKILL.md` line count as a review signal. Ask whether the extra content is core workflow or reference detail before suggesting cuts.
- [MUST] Treat strict setup/init skills as process specifications; review them for completeness and sequencing before compactness.
- [SHOULD] Return findings first, ordered by severity, with file and line references when possible.
- [SHOULD] Suggest the smallest edit that fixes the issue while preserving the author's intent.
- [FORBID] Accepting a model-invoked skill that expands scope through destructive, shared-state, canonical-publication, deployment, or external-system side effects.
- [SHOULD] Flag setup pointers that are soft dependencies disguised as hard preconditions.

## Verify

- `python3 - <<'PY'\nfrom pathlib import Path\nfor p in sorted(Path('skills').glob('*/SKILL.md')):\n    for line in p.read_text().splitlines():\n        if line.startswith('description:'):\n            d=line.split(':',1)[1].strip(); print(len(d), p, d)\nPY`
- `find skills -maxdepth 3 -type f -print | sort`
- Check `docs/invocation.md` for user-invoked/model-invoked expectations.

## Exceptions

- Longer descriptions can be acceptable only when still under 180 characters and materially improve discovery.
- Ordinary skills may exceed line-count guidance when the extra instructions are required for safe invocation.
- Strict setup/init skills may exceed ordinary `SKILL.md` line-count guidance when required for mandatory flow.
