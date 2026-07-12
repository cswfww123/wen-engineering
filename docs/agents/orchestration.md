# Orchestration (subagents)

Companion to [lifecycle.md](../lifecycle.md) and [Agents/README.md](../../Agents/README.md)
(`.claude/agents/` symlinks to `Agents/` for Claude Code discovery).

## Rules

1. **Built-ins stay built-in.** Do not ship project agents named `Explore`,
   `Plan`, or `general-purpose`.
2. **Incremental only.** Project agents: `Executor`, `Reviewer`, `Verifier`
   (Capitalized `name` in frontmatter).
3. **Hard try, soft fail.** When a skill step maps to a project agent, the parent
   **must attempt** that agent if the Agent tool and definition exist. If missing
   or spawn fails, **fall back** — never hard-fail the flow.
4. **Parent owns** route, authority, tracker, and user HITL.

## Dispatch ladder (required)

```text
Parent (strong model) — route, authority, HITL, final ownership
  ├─ built-in Explore / Plan     → research (never project-overridden)
  ├─ Executor (required try)     → implement, authorized review fixes
  │     └─ else general-purpose → else parent
  ├─ Reviewer (required try)     → each review axis (parallel OK)
  │     └─ else parent + AGENT-BRIEFS
  └─ Verifier (required try)     → Pass / Changes Required / Needs User Decision
        └─ else parent Verification Reviewer
```

### How to “try”

1. If Agent tool is unavailable → parent does the step (or built-in only).
2. Else if project agent `name` is in the registry → spawn it with a full brief.
3. Else if step is execution-like → try built-in `general-purpose` with the same brief.
4. Else → parent runs the step in-session using the same briefs/checklists.
5. **Never** stop a skill with “agent not found” / “Executor missing”.

### Brief minimum

| Agent | Brief must include |
| --- | --- |
| `Executor` | goal, scope, AC or fix list, constraints, verify commands, authority (no tracker unless granted) |
| `Reviewer` | review packet + **one axis** (or explicit all-axes) |
| `Verifier` | candidates + same scope fixed point |

## Skill mapping

| Skill / moment | Must try | Then |
| --- | --- | --- |
| `/implement` Execute (evidence loop, fidelity prep, verification runs that need edits) | `Executor` | GP → parent |
| `/implement` after `/code-review` when verdict is not Pass and fixes are authorized | `Executor` (fix list) | GP → parent |
| `/code-review` axis passes | `Reviewer` × 6 (parallel if possible) | parent sequential briefs |
| `/code-review` validation gate | `Verifier` | parent Verification Reviewer |
| `/code-review` Auto-fix (user or `/implement` authorized) | `Executor` with eligible findings + fix contract | GP → parent (same per-fix verify/revert rules) |
| Research before edit | built-in Explore | parent |

Standalone `/code-review` without fix authority stays report-only (no `Executor`).
User says “fix these” / “修一下” / equivalent → treat as fix authority for listed
or eligible findings, then dispatch `Executor`.

## Non-goals

- Agents do not replace skills; skills remain process owners.
- Agents do not own tracker state by default.
- Do not proliferate agent types per review axis.
- Do not override built-in agent type names.
