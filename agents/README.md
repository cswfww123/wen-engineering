# Subagents (WEN) — portable workers

**Canonical location:** `agents/` (this directory).

These are **host-agnostic role briefs** for orchestration: a strong parent routes;
workers run a bounded job and return a short report. They are not Claude-only.

| name | Role | Mutates tree? |
| --- | --- | --- |
| `Executor` | One bounded implement/fix task | Yes |
| `Reviewer` | Read-only review (axis optional via brief) | No |
| `Verifier` | Read-only verdict gate | No |

## Body vs frontmatter

- **Markdown body** = portable system prompt. Any coding agent that supports
  subagents / task workers can paste or load it.
- **YAML frontmatter** = optional host adapters (e.g. Claude Code `name` /
  `model` / `disallowedTools`). Other hosts may ignore unknown fields.

Do **not** re-implement a host’s built-in explore/plan/general workers under the
same names. This pack only adds the three roles above.

## Discovery (examples)

| Host | How these load |
| --- | --- |
| Claude Code | `.claude/agents/` → symlinks here |
| Codex / other | Point subagent config at `agents/*.md`, or inject the body as the worker system prompt |
| Manual | Parent pastes the body + a task brief |

## Dispatch (skills)

Skills that implement, review, verify, or apply authorized fixes **must try** the
mapped role when a subagent runtime exists, then fall back — never hard-fail.
See `docs/agents/orchestration.md`.

| Step | Try first | Fallback |
| --- | --- | --- |
| Implement / authorized fix | `Executor` | host general worker → parent |
| Review axes (code diff) | `Reviewer` × axis | parent + `skills/code-review/AGENT-BRIEFS.md` |
| Review axes (design/plan after diagnosis) | `Reviewer` × design axis | parent + `docs/agents/DESIGN-REVIEW-BRIEF.md` |
| Verdict gate | `Verifier` | parent Verification Reviewer |
| Research | host explore/search worker | parent |

Design/plan review reuses **`Reviewer`** + optional **`Verifier`** — do not add a
fourth role. Prefer a **different model** than the proposal author. Full packet
and axis text: [docs/agents/DESIGN-REVIEW-BRIEF.md](../docs/agents/DESIGN-REVIEW-BRIEF.md).

## Parent responsibilities

- Route, authority, and user decisions stay with the parent.
- Every spawn needs a brief: goal, scope, constraints, verify; Reviewer adds
  **axis**; fix runs list eligible findings + behavior contract.
- After multi-slice fix proposals from diagnosis, freeze a design packet and try
  design-axis Reviewers before `/implement` (see orchestration + DESIGN-REVIEW-BRIEF).
