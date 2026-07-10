# Agent Workflow

Applies to: repository-wide agent behavior
Source: `README.md`, `skills/setup-project-harness/SKILL.md`, user decisions in this project

## Rules

- [MUST] Treat `AGENTS.md` as the source of truth for project-level agent instructions.
- [MUST] Keep `CLAUDE.md` aligned by pointing it to `AGENTS.md`; do not maintain a divergent Claude-only instruction file.
- [MUST] Read the relevant `.agents/rules/**` files before changing matching work.
- [SHOULD] Proceed on clear, reversible edits after a concise plan; ask only for destructive changes, genuine ambiguity, or user-owned taste decisions.
- [SHOULD] Prefer repo evidence over assumptions, and mark harmless unknowns as open decisions instead of blocking work.
- [FORBID] Adding broad, generic best-practice rules that do not prevent a concrete drift risk in this repo.
- [SHOULD] Use the session todo list only for tactical, same-session steps. Send clear bounded work directly to `/implement`; send settled multi-slice work through `/to-spec` then `/to-tickets`; use `/wayfinder` first when material product or architecture decisions remain unresolved.
- [MUST] Implement one ready implementation-frontier ticket at a time in a fresh context, and load `/code-review` before closing it.
- [FORBID] Planning persistent work as "Phase 1/2/3" items inside the session todo list when it should instead become a spec, ticket graph, or Wayfinder decision map.

## Verify

- A settled multi-slice feature ends with a published spec and executable tickets, not a todo list that only the current session can see.
- Foggy ambitious work ends with a durable Wayfinder map and one cleared decision frontier.
- Tracked implementation closes only after its isolated delta passes verification and `/code-review`.
- `test -f AGENTS.md`
- `test -L CLAUDE.md && readlink CLAUDE.md`
- `find .agents/rules -maxdepth 3 -type f`

## Exceptions

- If symlinks are unavailable, `CLAUDE.md` may be a one-line stub that points to `AGENTS.md`.
