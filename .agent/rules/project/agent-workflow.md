# Agent Workflow

Applies to: repository-wide agent behavior
Source: `README.md`, `skills/setup-project-harness/SKILL.md`, user decisions in this project

## Rules

- [MUST] Treat `AGENTS.md` as the source of truth for project-level agent instructions.
- [MUST] Keep `CLAUDE.md` aligned by pointing it to `AGENTS.md`; do not maintain a divergent Claude-only instruction file.
- [MUST] Read the relevant `.agent/rules/**` files before changing matching work.
- [SHOULD] Proceed on clear, reversible edits after a concise plan; ask only for destructive changes, genuine ambiguity, or user-owned taste decisions.
- [SHOULD] Prefer repo evidence over assumptions, and mark harmless unknowns as open decisions instead of blocking work.
- [FORBID] Adding broad, generic best-practice rules that do not prevent a concrete drift risk in this repo.

## Verify

- `test -f AGENTS.md`
- `test -L CLAUDE.md && readlink CLAUDE.md`
- `find .agent/rules -maxdepth 3 -type f`

## Exceptions

- If symlinks are unavailable, `CLAUDE.md` may be a one-line stub that points to `AGENTS.md`.
