# AGENTS.md

This repository uses AI coding agents for real engineering work, not vibe coding. Use skills, progressive disclosure, project domain language, and judgment.

## Project Overview

WEN Engineering Skills is a local engineering-skills workspace for building concise, composable skills that help Codex, Claude, and other coding agents align user intent, repo evidence, and agent judgment.

## Core Directives

- **Plan first**: for non-trivial work, start with a concise bullet plan and unresolved questions. Proceed on clear, reversible implementation steps; ask only when the decision is genuinely user-owned or destructive.
- **Persistent work**: use the session todo list only for tactical, same-session steps. Default multi-session coding path is `/to-spec` then `/to-tickets` then `/implement`. System test plan/QA live in optional companion `wen-test` (`/to-test-plan`, `/qa-run`), not this pack. Use technical `/wayfinder` only for multi-session engineering fog. Product fog → team's product process (optional `/pm-intake`). Scope FE/BE gates to the ticket layer. Implement one frontier ticket at a time in a fresh context.
- **Use skills**: prefer project skills such as `/setup-project-harness` and `/skill-review` when they fit the task.
- **Progressive disclosure**: do not pack every rule into this file. Read only the relevant `.agents/rules/**`, `README.md`, and `skills/**` files before editing.
- **Domain language**: use this repo's terms: skills, harness, progressive disclosure, user bridge, repo evidence, agent judgment, and rules as guardrails.
- **Feedback loop**: after changing a skill, verify frontmatter, description length, references, and README/index consistency. Line count is advisory except for strict setup/init skills.
- **Code quality**: keep skill instructions short, active, and operational. Move templates or rarely needed detail to one-level reference files.
- **Judgment**: rules guide behavior. When evidence conflicts with a rule, explain the conflict and choose the smallest reversible path or ask the user.

## Development Commands

This repo has no package manager, build, lint, or typecheck suite. It has a
shell fixture for skill-sync migration safety.

- List skills: `find skills -maxdepth 2 -name SKILL.md -print | sort`
- Sync skills into shared agent directory and link Codex, Claude, ZCode, and Kimi: `./scripts/sync-skills.sh --agents all`
- Check shell syntax: `bash -n scripts/sync-skills.sh scripts/test-sync-skills.sh`
- Test sync migration safety: `./scripts/test-sync-skills.sh`
- Check skill descriptions:

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
- Check advisory skill line counts: `wc -l skills/*/SKILL.md` (do not fail strict setup/init skills for length)

## Agent Skills

- **Issue tracker**: GitHub issues for `cswfww123/wen-engineering`; use `gh` as described in `docs/agents/issue-tracker.md`.
- **Lifecycle**: use `docs/lifecycle.md` and `docs/boundaries.md` for coding routes; optional `wen-pm` / `wen-test` are external layers.
- **Triage labels**: use the canonical labels in `docs/agents/triage-labels.md`: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, and `wontfix`.
- **Domain docs**: single-context layout; read `CONTEXT.md` and relevant ADRs when they exist, following `docs/agents/domain.md`.

## Rule Index

Agents must read the relevant files under `.agents/rules/` before editing matching work.

- `.agents/rules/project/` — project identity, collaboration, verification, and harness boundaries
- `.agents/rules/skills/` — skill authoring and skill review rules
- `.agents/rules/invariants/` — shared mutable state (balance/quota/counter/inventory/state machine): require the invariant, concurrency contract, and concurrency test seam

## Engineering Practices

- **Small vertical slices**: make the smallest useful change, then verify it.
- **Review new skills**: use `/skill-review` before accepting a new or changed skill.
- **Documentation**: update `README.md` when the skill index or repository layout changes.
- **Self-improvement**: when repeated mistakes reveal a missing boundary, add or tighten the smallest relevant rule.
- **Handoff**: for long tasks, summarize changed files, standards established, verification, and remaining unknowns.

## Reference Files

- `README.md` — project philosophy, skill index, and repository layout
- `docs/lifecycle.md` — canonical work routing, artifact model, completion gates, and legacy compatibility
- `docs/boundaries.md` — engineering vs PM fog ownership and handoff contract
- `docs/handoff-package.md` — PM delivery package, UI admission, dual completion gates
- `docs/agents/*.md` — issue tracker, triage label, and domain documentation contracts
- `scripts/sync-skills.sh` — batch sync all repo skills into `~/.agents/skills` and link local agent skill directories
- `skills/**/SKILL.md` — project skills
- `skills/setup-project-harness/AGENTS_TEMPLATE.md` — generated `AGENTS.md` reference shape
- `skills/setup-project-harness/RULE_TEMPLATE.md` — `.agents/rules/**` reference shape
- `.agents/rules/**` — detailed project rules

Always do real engineering: align on intent, change in small verified steps, and let human taste plus agent judgment both do their best work.
