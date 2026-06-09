# AGENTS.md

This repository uses AI coding agents for real engineering work, not vibe coding. Use skills, progressive disclosure, project domain language, and judgment.

## Project Overview

WEN Engineering Skills is a local engineering-skills workspace for building concise, composable skills that help Codex, Claude, and other coding agents align user intent, repo evidence, and agent judgment.

## Core Directives

- **Plan first**: for non-trivial work, start with a concise bullet plan and unresolved questions. Proceed on clear, reversible implementation steps; ask only when the decision is genuinely user-owned or destructive.
- **Use skills**: prefer project skills such as `/setup-project-harness` and `/skill-review` when they fit the task.
- **Progressive disclosure**: do not pack every rule into this file. Read only the relevant `.agents/rules/**`, `README.md`, and `skills/**` files before editing.
- **Domain language**: use this repo's terms: skills, harness, progressive disclosure, user bridge, repo evidence, agent judgment, and rules as guardrails.
- **Feedback loop**: after changing a skill, verify frontmatter, description length, references, and README/index consistency. Line count is advisory except for strict setup/init skills.
- **Code quality**: keep skill instructions short, active, and operational. Move templates or rarely needed detail to one-level reference files.
- **Judgment**: rules guide behavior. When evidence conflicts with a rule, explain the conflict and choose the smallest reversible path or ask the user.

## Development Commands

This repo currently has no package manager, build, lint, typecheck, or test command.

- List skills: `find skills -maxdepth 2 -name SKILL.md -print | sort`
- Sync skills into Codex and Claude: `./scripts/sync-skills.sh --agents codex,claude`
- Check skill descriptions: `python3 - <<'PY'\nfrom pathlib import Path\nfor p in sorted(Path('skills').glob('*/SKILL.md')):\n    for line in p.read_text().splitlines():\n        if line.startswith('description:'):\n            d=line.split(':',1)[1].strip(); print(len(d), p, d)\nPY`
- Check advisory skill line counts: `wc -l skills/*/SKILL.md` (do not fail strict setup/init skills for length)

## Agent Skills

- **Issue tracker**: GitHub issues for `cswfww123/wen-engineering`; use `gh` as described in `docs/agents/issue-tracker.md`.
- **Triage labels**: use the canonical labels in `docs/agents/triage-labels.md`: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, and `wontfix`.
- **Domain docs**: single-context layout; read `CONTEXT.md` and relevant ADRs when they exist, following `docs/agents/domain.md`.

## Rule Index

Agents must read the relevant files under `.agents/rules/` before editing matching work.

- `.agents/rules/project/` — project identity, collaboration, verification, and harness boundaries
- `.agents/rules/skills/` — skill authoring and skill review rules

## Engineering Practices

- **Small vertical slices**: make the smallest useful change, then verify it.
- **Review new skills**: use `/skill-review` before accepting a new or changed skill.
- **Documentation**: update `README.md` when the skill index or repository layout changes.
- **Self-improvement**: when repeated mistakes reveal a missing boundary, add or tighten the smallest relevant rule.
- **Handoff**: for long tasks, summarize changed files, standards established, verification, and remaining unknowns.

## Reference Files

- `README.md` — project philosophy, skill index, and repository layout
- `docs/agents/*.md` — issue tracker, triage label, and domain documentation contracts
- `scripts/sync-skills.sh` — batch sync all repo skills into local Codex and Claude skill directories
- `skills/**/SKILL.md` — project skills
- `skills/setup-project-harness/AGENTS_TEMPLATE.md` — generated `AGENTS.md` reference shape
- `skills/setup-project-harness/RULE_TEMPLATE.md` — `.agents/rules/**` reference shape
- `.agents/rules/**` — detailed project rules

Always do real engineering: align on intent, change in small verified steps, and let human taste plus agent judgment both do their best work.
