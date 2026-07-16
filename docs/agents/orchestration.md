# Orchestration (subagents)

Companion to [lifecycle.md](../lifecycle.md) and [agents/README.md](../../agents/README.md).
Portable role briefs live in `agents/`; host adapters (e.g. Claude Code
`.claude/agents/` symlinks) are optional discovery, not a lock-in.

## Rules

1. **Host built-ins stay host-owned.** Do not shadow explore / plan / general
   workers with pack-owned names on that host.
2. **Incremental roles only.** Pack workers: `Executor`, `Reviewer`, `Verifier`
   (Capitalized `name` when the host uses frontmatter).
3. **Hard try, soft fail.** When a skill step maps to a pack role, the parent
   **must attempt** that worker if a subagent runtime can load it. If missing or
   spawn fails, **fall back** — never hard-fail the flow.
4. **Parent owns** route, authority, tracker, and user HITL.
5. **Prompts are portable.** The markdown body is the contract; YAML frontmatter
   is host-optional metadata.

## Dispatch ladder (required)

```text
Parent (strong model) — route, authority, HITL, final ownership
  ├─ host explore / plan / search   → research (use host built-in when present)
  ├─ Executor (required try)        → implement, authorized review fixes
  │     └─ else host general worker → else parent
  ├─ Reviewer (required try)        → each review axis (parallel OK)
  │     └─ else parent + AGENT-BRIEFS
  └─ Verifier (required try)        → Pass / Changes Required / Needs User Decision
        └─ else parent Verification Reviewer
```

### How to “try”

1. If no subagent/tool runtime → parent does the step.
2. Else if pack worker `name` (or body) is loadable → spawn with a full brief.
3. Else if step is execution-like → try the host’s general multi-step worker with
   the same brief (skills ship self-contained `DISPATCH.md` bodies under
   `implement/` and `code-review/` so target repos need not clone this pack).
4. Else → parent runs the step in-session using the same briefs/checklists.
5. **Never** stop a skill with “agent not found” / “Executor missing”.
6. **Must attempt:** when a runtime exists, skipping spawn without an attempt is
   a process bug. Soft fail only after try, or when no runtime exists.
7. Done reports should record `agents used` (pack role | host-general |
   parent-fallback).

### Brief minimum

| Agent | Brief must include |
| --- | --- |
| `Executor` | goal, scope, AC or fix list, constraints, verify commands, authority (no tracker unless granted) |
| `Reviewer` | review packet + **one axis** (or explicit all-axes) |
| `Verifier` | candidates + same scope fixed point |

## Skill mapping

| Skill / moment | Must try | Then |
| --- | --- | --- |
| `/implement` Execute (evidence loop, fidelity prep, verification runs that need edits) | `Executor` | host general → parent |
| `/implement` after `/code-review` when verdict is not Pass and fixes are authorized | `Executor` (fix list) | host general → parent |
| `/code-review` axis passes | `Reviewer` × 6 (parallel if possible) | parent sequential briefs |
| `/code-review` validation gate | `Verifier` | parent Verification Reviewer |
| `/code-review` Auto-fix (user or `/implement` authorized) | `Executor` with eligible findings + fix contract | host general → parent (same per-fix verify/revert rules) |
| Research before edit | host explore/search worker | parent |

Standalone `/code-review` without fix authority stays report-only (no `Executor`).
User says “fix these” / “修一下” / equivalent → treat as fix authority for listed
or eligible findings, then dispatch `Executor`.

## Non-goals

- Agents do not replace skills; skills remain process owners.
- Agents do not own tracker state by default.
- Do not proliferate agent types per review axis.
- Do not shadow host built-in worker type names.
- Do not hardcode a single product (Claude Code / Codex / …) into role bodies.
