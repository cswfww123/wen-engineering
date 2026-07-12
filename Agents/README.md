# Claude Code subagents (WEN) — incremental only

**Canonical location in this repo:** `Agents/` (this directory).

Claude Code loads project agents from `.claude/agents/`, which in this repo is
symlinked to these files so definitions are not duplicated.

**Do not override built-ins.** Leave Claude Code’s `Explore`, `Plan`, and
`general-purpose` alone. This folder only adds WEN-shaped workers.

| name | Role | Default model | Mutates tree? |
| --- | --- | --- | --- |
| `Executor` | Execution / Coder + authorized review fixes | `sonnet` | Yes (inherits tools) |
| `Reviewer` | Report-only review (axis via brief) | `sonnet` | No |
| `Verifier` | Critical-path verdict gate | `opus` | No |

`name` uses **Capitalized** identifiers (e.g. `Executor`). Override `model` per
file (`haiku` / `sonnet` / `opus` / `inherit`).

## Hard dispatch (skills)

Skills that mutate or gate code **must** follow the ladder in
`docs/agents/orchestration.md` (not “maybe if you feel like it”):

| Step | Try first | Fallback (no error) |
| --- | --- | --- |
| Implement / authorized fix | `Executor` | `general-purpose` → parent |
| Review axes | `Reviewer` × axis | parent + `AGENT-BRIEFS` |
| Verdict gate | `Verifier` | parent Verification Reviewer |
| Research | built-in `Explore` | parent |

Missing definition, Agent tool absent, or spawn failure → **continue on the next
fallback**. Never abort a skill because a project subagent is missing.

## Parent responsibilities

- Route, authority, and HITL stay in the main session.
- Brief: goal, scope, constraints, verify; Reviewer adds **axis**; fix runs list
  eligible findings + behavior contract.
