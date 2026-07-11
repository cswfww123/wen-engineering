# Agent Workflow

Applies to: repository-wide agent behavior
Source: `README.md`, `docs/lifecycle.md`, `docs/boundaries.md`, `skills/setup-project-harness/SKILL.md`, user decisions in this project

## Rules

- [MUST] Treat `AGENTS.md` as the source of truth for project-level agent instructions.
- [MUST] Keep `CLAUDE.md` aligned by pointing it to `AGENTS.md`; do not maintain a divergent Claude-only instruction file.
- [MUST] Read the relevant `.agents/rules/**` files before changing matching work.
- [SHOULD] Proceed on clear, reversible edits after a concise plan; ask only for destructive changes, genuine ambiguity, or user-owned taste decisions.
- [SHOULD] Prefer repo evidence over assumptions, and mark harmless unknowns as open decisions instead of blocking work.
- [FORBID] Adding broad, generic best-practice rules that do not prevent a concrete drift risk in this repo.
- [MUST] Keep this pack coding-focused and **composable**: works alone or linked with optional `wen-pm` / `wen-test`. Never fail a coding task solely because another pack is missing.
- [MUST] Do not run product discovery or own system QA here (`to-test-plan` / `qa-run` are `wen-test` when used).
- [MUST] When product intent is open, stop and hand to the product/design owner (mention `/pm-intake` only if `wen-pm` is in use).
- [MUST] Scope gates to ticket layer: frontend-only UI fidelity when UI changes; backend-only API fidelity without UI pins; do not implement out-of-scope layers without authority.
- [SHOULD] Bounded work → `/implement`; multi-slice → `/to-spec` → `/to-tickets` → `/implement`; recommend `wen-test` for system QA when installed; technical `/wayfinder` only for multi-session engineering fog.
- [MUST] Implement one ready implementation-frontier ticket at a time in a fresh context, and load `/code-review` before closing it.
- [FORBID] Planning persistent work as "Phase 1/2/3" items inside the session todo list when it should instead become a spec, ticket graph, or technical Wayfinder decision map.
- [FORBID] Using Wayfinder or `/to-spec` to invent product value, Expected behavior after rejection, or market bets.

## Verify

- A settled multi-slice feature ends with a published spec and executable tickets, not a todo list that only the current session can see.
- Product fog is redirected to PM; technical multi-session fog may end with a durable Wayfinder map and one cleared decision frontier.
- Tracked implementation closes only after its isolated delta passes verification and `/code-review`.
- `test -f AGENTS.md`
- `test -L CLAUDE.md && readlink CLAUDE.md`
- `find .agents/rules -maxdepth 3 -type f`

## Exceptions

- If symlinks are unavailable, `CLAUDE.md` may be a one-line stub that points to `AGENTS.md`.
