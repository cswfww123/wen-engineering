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

### Brief quality (hard)

Subagent context is **cold and disposable**. Workers do not see the parent
chat, prior decisions, or “what we already looked at.” Many hosts also run
workers on **weaker / cheaper models**. The spawn prompt is therefore the
worker’s entire environment — not a polite summary.

1. **Self-contained by default.** A fresh agent must be able to finish (or
   correctly `blocked`) from the brief alone. No “as we discussed,” no bare
   ticket IDs without AC text, no “fix the review findings” without the list.
2. **Minimum is a floor, not the target.** Skipping recommended fields to save
   tokens is a **process bug** when it forces the worker to guess.
3. **Paste evidence; do not only point.** Prefer short excerpts the worker can
   act on: AC quotes, error stacks, key signatures, failing test names, allowed
   file list, diff fixed-point commands **and** (when small) the diff itself.
   Paths to long docs are fine *in addition*, not as a substitute for the
   decision-critical lines.
4. **One spawn = one vertical slice** (or one authorized fix list). Do not dump
   a multi-feature roadmap into a single cold context.
5. **System role short, task brief long.** `agents/*.md` is the portable role
   contract. Detail lives in the per-spawn user/task brief from skills’
   `DISPATCH.md` templates.
6. **Thin brief → expect `blocked`.** Workers are instructed to stop rather
   than invent product intent, scope, or Expected behavior.

### Brief minimum (must)

| Agent | Brief must include |
| --- | --- |
| `Executor` | goal, scope, AC or fix list, constraints, verify commands, authority (no tracker unless granted) |
| `Reviewer` | review packet + **one axis** (or explicit all-axes). Packet may be a **code diff** (`skills/code-review/AGENT-BRIEFS.md`) or a **design/plan** (`docs/agents/DESIGN-REVIEW-BRIEF.md`) |
| `Verifier` | candidates + same scope fixed point (diff fixed point **or** design packet) |

### Brief recommended (default for every spawn)

Use the full templates in skill dispatch files. In short:

| Agent | Also include (recommended) |
| --- | --- |
| `Executor` | why/context; product baseline path + accepted PRD deltas (or `none`); in/out of scope files; pattern refs (paths + what to copy); seams/APIs/enums to reuse; **same-surface chrome owner** on UI slices; exact verify commands; blocked conditions; return schema. Full text: `skills/implement/DISPATCH.md` |
| `Reviewer` | same review packet for every axis worker: fixed-point commands and/or diff text, changed files, commit list, intent/standards sources **with quotes for critical lines**, project shape/lenses when needed, **axis name + axis brief body** from `AGENT-BRIEFS.md` or `DESIGN-REVIEW-BRIEF.md` (paste axis text — do not assume the worker will open the pack). Full text: `skills/code-review/DISPATCH.md` |
| `Verifier` | full candidate list with file:line + evidence; identical fixed point; confidence bar; Pass rules (incomplete-surface, observability, same-surface, unauthorized PRD partial). Full text: `skills/code-review/DISPATCH.md` |

## Skill mapping

| Skill / moment | Must try | Then |
| --- | --- | --- |
| `/implement` Execute (evidence loop, fidelity prep, verification runs that need edits) | `Executor` | host general → parent |
| `/implement` after `/code-review` when verdict is not Pass and fixes are authorized | `Executor` (fix list) | host general → parent |
| `/code-review` axis passes | `Reviewer` × weight (`none`: nobody; `light`: 1 Slice; `full`: Standards+Spec+Correctness, +UI Fidelity when in scope) | parent sequential briefs |
| `/code-review` validation gate | `Verifier` (`full` always; `light` only if the Slice Reviewer filed candidates; `none` never) | parent Verification Reviewer |
| `/code-review` Auto-fix (user or `/implement` authorized) | `Executor` with eligible findings + fix contract | host general → parent (same per-fix verify/revert rules) |
| After `/diagnosing-bugs` (or any multi-slice fix **proposal**) before code | `Reviewer` × design axes (`DESIGN-REVIEW-BRIEF.md`); prefer a **different model** than the proposal author | optional `Verifier` → user HITL → `/implement` or `/to-spec` |
| Research before edit | host explore/search worker | parent |

Standalone `/code-review` without fix authority stays report-only (no `Executor`).
User says “fix these” / “修一下” / equivalent → treat as fix authority for listed
or eligible findings, then dispatch `Executor`.

### Design / plan review (no new agent)

Reuse **`Reviewer`** + optional **`Verifier`** on a frozen **design packet** (root
cause evidence + proposal text), not a diff. Full briefs:
[DESIGN-REVIEW-BRIEF.md](DESIGN-REVIEW-BRIEF.md).

```text
diagnosis / proposal frozen
  → Reviewer (root-cause-fit) + Reviewer (architecture)  [prefer other model]
  → optional Verifier
  → user scopes MVP (/grill-code if open)
  → /implement  or  /to-spec → /to-tickets → /implement
```

Do **not** invent a fourth pack agent for “architecture review.” Do **not** treat
same-session self-approval by the proposal author as this step.

## Non-goals

- Agents do not replace skills; skills remain process owners.
- Agents do not own tracker state by default.
- Do not proliferate agent types per review axis.
- Do not shadow host built-in worker type names.
- Do not hardcode a single product (Claude Code / Codex / …) into role bodies.
