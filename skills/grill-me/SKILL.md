---
name: grill-me
description: A relentless interview to sharpen a plan or design.
disable-model-invocation: true
---

Run a `/grilling` session (load `grilling` once; follow its **frontier-round** + batch/surface rules).

Matt-upstream shape: **shared understanding in the conversation is enough.** Do not invent a paper trail for work that finishes in this session.

## When to skip this skill entirely

If the user already has clear AC, a bug, or a single eng slice → prefer **`/implement`** (L1). Do not open grill (or force docs) to look thorough.

## Engineering defaults (coding repos)

1. **Facts first (non-blocking)** — map existing tables, bridges, call sites, tests, ADRs/CONTEXT before asking. Prefer code over stale process docs. Non-trivial lookups: dispatch explore/sub-agents; only hold back decisions that depend on those facts — still post the rest of the frontier this round.
2. **MVP hard boundary early** — on the **first** frontier surface (or immediately after Q1 storage/shape), post a table with:
   - **In scope this round** (minimal shippable behavior)
   - **Explicitly out** (red-dot/SSE/enum/search/… unless required for correctness of the core path)
   - **Open risks**
   Get accept/diff **before** expanding into summary APIs, realtime, renames, or refactors.
3. **Frontier batch tables** — each round posts only the **frontier** (decisions with settled prerequisites). Preferred shape: one markdown table of **5–8** product/architecture decisions (max **10** without “继续深烤”). Recompute the frontier after my answers. Implementation minutiae → park for implement / tdd, do not serial-grill.
4. **Environment constraints (auto, do not interview me for these)** — from codebase + open tracker only:
   - Prefer existing wire values, enums, APIs, and identity patterns already in production paths.
   - Treat dangerous legacy (silent tenant/user fallback, dual sources of money facts, etc.) as **do-not-copy**, not as a recommended design.
   - Default proposals stay **in-environment** (aliases, adapters, fail-closed). **Environment-changing** work (wire/protocol renames, isolation semantics) is out of scope unless I explicitly ask for a migration.
5. **`/domain-modeling` only when terms actually change** — do **not** load it as a mandatory epic and do **not** create `CONTEXT.md` / ADRs for a trivial pin. If a durable glossary/ADR is truly needed (hard to reverse + surprising + real trade-off), update sparingly; never dump unshipped implementation plans into CONTEXT.
6. **Routing / anti-invention** — if present: `docs/lifecycle.md` (LIGHT G; HEAVY product fog stays in PM).
7. **Wrong human in the room** — if several frontier decisions need product/business/ops and I am not the owner, **stop serial-grilling me**. Park those rows and offer `/to-questionnaire`. Do not invent Expected / market / user value.
8. **Filled questionnaire ingest (no re-confirm)** — if I paste a filled `/to-questionnaire` (or `问卷已填` + path):
   - Treat non-empty **选择** / **回答** as **settled product input** — do **not** re-ask those Q-ids.
   - Re-ask only blanks, bare `Z` without text, or clear contradictions.
   - Prefer **`/to-spec`** when product scope is multi-slice; do **not** also invent a parallel long-lived decision file if the spec will hold the decisions.
   - If this session continues as grill: only the **engineering residual** frontier. Cite closed questionnaire Q-ids; never restart product discovery.

## Close gate (default: no new files)

When we share understanding, **stop or offer implement** — **without** writing a decision document by default.

### Default (same session / simple pin) — **no artifact**

Use when any of these hold (usual case):

- I will implement or keep working **in this chat**
- Scope is a small eng pin, bug path, or few decisions already answered
- Nothing needs another agent/session to re-read a file

**Do:**

1. Short chat recap (in/out scope + settled choices) — message only, not a repo file.
2. Snippet rule scan **only if** the recap freezes code/SQL/templates (same checks as below); fix the snippet in the recap.
3. High-risk list **only if** real blast-radius forks were decided; if I rubber-stamped, force explicit ack on those 2–3 only.
4. Next: `/implement` in-session when I ask to build — implementer uses **this thread + code**, not a mandatory `decision-*.md`.

**Do not:**

- Create `.scratch/**/decision-*.md`, `docs/decisions/**`, or “archive for completeness”
- Ask me whether to save/delete/archive the grill
- Open `/to-spec` or Wayfinder just to have a place to put paper

### Durable archive — **only when handoff needs it**

Write a decision file **only if** at least one is true:

- Work continues in **another session/agent** and I did not get a ticket/spec yet
- Handing a **multi-slice** package into `/to-spec` and the settled table is too large to retype (prefer putting decisions **into the spec**, not a second rotting file)
- An open **Wayfinder** ticket must record the resolution (write **on the ticket**, not a parallel doc)
- I **explicitly** asked to archive

If you write one:

- Prefer tracker/ticket/spec body over a new `docs/decisions/` path
- `.scratch/<feature>/decision-*.md` is local-only scaffolding; **do not** ask me to promote it; after `/to-spec` or implement merges, treat it as **non-authoritative** (do not reload by default)
- Include: decision table, in/out scope, leftovers, TDD seams **in scope only**
- Run snippet rule scan on any frozen code/SQL/templates:

| Check | Fail if |
|---|---|
| Time API | raw `Instant.now()`, `new Date()`, `System.currentTimeMillis()` where project forbids them |
| Auth context | `LoginContextHolder` (or equivalent) on unsafe paths (MQ, `@Scheduled`, raw executors) |
| Module / layer | cross-module mapper grabs, wrong layer for the seam |
| Iron laws | e.g. “notice failure must not roll back credit” violated by proposed txn shape |
| Tests vs AC | AC asserts field copy / time / visibility but test strategy says “don’t test that surface” |

Never freeze a sample the repo’s contract tests would reject.

## Implement handoff (when I order build)

Do not treat “grill done” as silent auth to push shared branches.

1. **AC path** — use this conversation’s settled scope (and ticket/spec if any). **Do not require** a decision file for same-session build.
2. **`/tdd` (or project equivalent)** — Red → Green → Refactor at agreed seams. **Red evidence required** when claiming behavior change.
3. **Reviewer → Verifier** (or project review skill) before commit; incomplete surface is blocking.
4. **Git** — follow repo push protocol.

## Artifact hygiene (automatic — never ask me)

- **Authoritative after ship:** code, tests, open tracker items, short invariants — not closed grill notes.
- **Closed / delivered / resolved** tracker artifacts: do not load as “how to build now.”
- **Process files** created only for handoff: after consume (spec written, ticket closed, or same-session implement done), stop citing them; delete or cold-ignore without prompting.
- Conflicts between old process docs and code → **code wins**; do not interview me to reconcile.

## Keep it short

- One frontier surface per turn (batch table = one round).
- Do not re-read `/grilling` or this file every turn after first load.
- Wayfinder: write the decision onto the ticket on close; do not demand re-paste of Destination / prior DECs.
