# AGENTS.md

WEN Engineering Skills: composable coding skills for AI agents. Standalone or linked with optional `wen-pm` / `wen-test` (no hard deps).

## Route (choose track first)

**LIGHT (default — daily coding):** start at the smallest step that fits.

- Clear bug / AC / pure eng → `/implement` (one context, one delta; `/code-review` before close)
- Settled multi-slice → `/to-spec` → `/to-tickets` → `/implement`
- Same-session plan pin → `/grill-with-docs` (in-flow, not optional fluff)
- Mild intent gap in coding context → `/product-fog` → one next skill (often grill)
- Multi-session eng fog → `/wayfinder` (prefer grill first if one session is enough)

**HEAVY (fuzzy product need):** do not invent value or start coding pipelines.

- Worth-doing / target user / market / vague idea → full PM (`wen-pm` `/pm-intake` or team process) → then LIGHT multi-slice
- Never invent Expected, user value, or market bets

Also: FE/BE fidelity gates scoped to the ticket layer; session todos are tactical only (durable work = spec, tickets, or Wayfinder map).

## Rules

- Read the relevant `.agents/rules/**` before matching edits.
- Skills stay short and operational; detail in one-level references.
- After skill edits: verify frontmatter, description length, references, README/index consistency.
- When evidence conflicts with a rule, explain and take the smallest reversible path or ask.
- Tracker: GitHub issues for `cswfww123/wen-engineering` via `docs/agents/issue-tracker.md`. Labels: `docs/agents/triage-labels.md`. Domain: `docs/agents/domain.md`.

## Commands

No package manager, build, lint, or typecheck suite. Shell fixtures only:

- List skills: `find skills -maxdepth 2 -name SKILL.md -print | sort`
- Sync agents: `./scripts/sync-skills.sh --agents all`
- Shell syntax: `bash -n scripts/sync-skills.sh scripts/test-sync-skills.sh`
- Migration tests: `./scripts/test-sync-skills.sh`
- Description lengths:

```bash
python3 - <<'PY'
from pathlib import Path
for p in sorted(Path('skills').glob('*/SKILL.md')):
    for line in p.read_text().splitlines():
        if line.startswith('description:'):
            d=line.split(':',1)[1].strip()
            print(len(d), p, d)
PY
```

- Advisory line counts: `wc -l skills/*/SKILL.md`

## References

- `docs/lifecycle.md` — LIGHT vs HEAVY routes, artifacts, gates
- `docs/boundaries.md` — pack ownership
- `docs/handoff-package.md` — delivery package and dual gates
- `README.md` — philosophy and skill index
- `.agents/rules/**`
- `skills/**/SKILL.md`
