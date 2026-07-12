# AGENTS.md

WEN Engineering Skills pack. Standalone or linked with optional `wen-pm` / `wen-test` (no hard deps).

## Route

- **LIGHT (default):** clear bug/AC → `/implement`; multi-slice → `/to-spec` → `/to-tickets` → `/implement`; same-session pin → `/grilling`; mild coding intent gap → `/product-fog`; multi-session eng fog → `/wayfinder` (prefer grill first).
- **HEAVY:** fuzzy product need (worth-doing / user / market) → full PM (`wen-pm` `/pm-intake` or team process) first. Never invent Expected, user value, or market bets.
- Durable work lives in specs, tickets, or Wayfinder maps — not session todos. Details: `docs/lifecycle.md`, `docs/boundaries.md`.

## Wiring

- Tracker / labels / domain: `docs/agents/issue-tracker.md`, `triage-labels.md`, `domain.md`
- Domain habit: when terms matter, read `CONTEXT.md` / `docs/adr/` (see `docs/agents/domain.md` and formats in `docs/domain/`). On conflict, ask. When a term or hard-to-reverse decision crystallizes, update glossary/ADR inline — no invented language, no batch-at-end dumps.
- Project constraints: `.agents/rules/**` (read only when the edit matches)
- Subagents (Claude Code): `.claude/agents/` incremental only — `Executor`, `Reviewer`, `Verifier` (Capitalized names). Do not override built-ins (`Explore` / `Plan` / `general-purpose`). Skills **must try** the mapped agent, then fall back (GP/parent); never hard-fail if missing. Details: `.claude/agents/README.md`, `docs/agents/orchestration.md`
- Keep this file short. Permanent instructions depreciate — prune what the current model already does.

## Mistakes

Failure-driven only. Add a line when the model already failed here and will likely fail again; delete when a newer model no longer trips. Prefer a checkable command or a hard forbid.

- [ ] After skill edits: verify frontmatter, description length, one-level references, README/index consistency.

## Commands

Proven only:

- List skills: `find skills -maxdepth 2 -name SKILL.md -print | sort`
- Sync agents: `./scripts/sync-skills.sh --agents all`
- Migration tests: `./scripts/test-sync-skills.sh`
