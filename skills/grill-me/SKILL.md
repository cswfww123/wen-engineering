---
name: grill-me
description: A relentless interview to sharpen a plan or design.
disable-model-invocation: true
---

Run a `/grilling` session (load `grilling` once; follow its batch/surface rules).

## Engineering defaults (coding repos)

1. **Facts first** — map existing tables, bridges, call sites, tests, ADRs/CONTEXT before asking.
2. **MVP hard boundary early** — on the **first** decision surface (or immediately after Q1 storage/shape), post a table with:
   - **In scope this round** (minimal shippable behavior)
   - **Explicitly out** (red-dot/SSE/enum/search/… unless required for correctness of the core path)
   - **Open risks**
   Get accept/diff **before** expanding into summary APIs, realtime, renames, or refactors.
3. **Batch decision table** — preferred close shape: one markdown table of **5–8** product/architecture decisions (max **10** without “继续深烤”). Implementation minutiae (Noop log wording, Map vs record, commit-constant placement) → park for implement / tdd, do not serial-grill.
4. **`/domain-modeling` (minimal, not a separate epic)** — as terms crystallize, update glossary / domain notes in-session. Prefer a **one-line term** + optional ADR *draft*; do **not** push unshipped decisions into canonical CONTEXT/ADR as final truth.
5. **Routing / anti-invention** — if present: `docs/lifecycle.md` (LIGHT G; HEAVY product fog stays in PM).

## Close gate (before “shared understanding” is done)

When decisions are accepted, **archive then stop** (or ask whether to implement). Archive must pass:

### A. Decision artifact

Write a single source of truth the implementer can follow without re-grilling, e.g.:

- `.scratch/<feature>/decision-*.md`, or
- repo-visible `docs/decisions/` / ticket attachment when the team needs cross-machine AC

Include: decision table, **in/out scope**, commit/PR split if any, leftovers (`needs-triage`), and **TDD red seams** only for behaviors in scope.

If the artifact lives under gitignored `.scratch/`, **say so on close** and offer: (1) leave local-only, (2) copy summary into a trackable path, or (3) refine ADR after ship. Do not silently assume other agents/machines will see it.

### B. Snippet rule scan (mandatory)

Any code/SQL/template frozen in the decision doc is **production input**. Before writing or after paste, scan against project rules (read matching `.agents/rules/**` / AGENTS Mistakes):

| Check | Fail if |
|---|---|
| Time API | raw `Instant.now()`, `new Date()`, `System.currentTimeMillis()` where project forbids them |
| Auth context | `LoginContextHolder` (or equivalent) on unsafe paths (MQ, `@Scheduled`, raw executors) |
| Module / layer | cross-module mapper grabs, wrong layer for the seam |
| Iron laws | e.g. “notice failure must not roll back credit” violated by proposed txn shape |
| Tests vs AC | AC asserts field copy / time / visibility but test strategy says “don’t test that surface” |

**Fix the snippet in the archive** to use sanctioned helpers and safe identity passing. Never freeze a sample that the repo’s contract tests would reject.

### C. High-risk recap

Close message lists the **2–3** decisions with real blast radius (who sees data, txn isolation, half-finished producer/consumer pairs). If I only ever said `按推荐`, re-state those and require one explicit ack or diff.

## Implement handoff (when I order build)

Do not treat “grill done” as silent auth to push shared branches.

1. **AC path** — implementer reads the decision file first; no re-inventing scope.
2. **`/tdd` (or project equivalent)** — one behavior Red → Green → Refactor per seam listed in the archive. **Red evidence required** (failing test output or verifier `tdd-evidence: missing`).
3. **Reviewer → Verifier** (or project review skill) before commit; incomplete surface is blocking.
4. **Git** — follow repo push protocol; shared `test`/`main` is not a free push just because grill finished.

## Keep it short

- One surface per turn (batch table = one).
- Do not re-read `/grilling` or this file every turn after first load.
- Wayfinder: write the decision onto the ticket on close; do not demand re-paste of Destination / prior DECs.
