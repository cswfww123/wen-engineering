---
name: implement
description: "Implement a bug fix, clear AC, one slice, or one tracked ticket: parent plans a fixed brief, Executor runs it, parent accepts, reviews, merges, closes the ticket."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Use /tdd at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Done means **walkthrough-proven**: the app runs and every Covered clause / AC bullet passes on its real path, with per-row runtime evidence the parent has checked (§3). Tests green + diff looks right is not Done on its own.

Once done, pick a review weight from `/code-review` **Pick weight** and follow it.

Invoking `/implement` authorizes **local** commits on the current branch (no push, no PR) unless the user says not to commit this run. Code edits happen in an isolated local worktree and merge back to the current branch once the slice is accepted: [WORKTREE.md](WORKTREE.md).

## WEN process (required — read before writing code)

These steps bind how the steps above run in this pack.

### 0. Route, bound, record intent

- Clear bounded request **or** one implementation-frontier ticket only. Intent not ready → stop; do not invent Expected.
- Note layer (`frontend` | `backend` | `full-stack` | `non-UI`). UI layer or a design source in play → load [UI.md](UI.md) before the first production edit (pin rows, chrome owner, fidelity).
- Tracked work (frontier, bug-report conversion, HITL, claim) → load [TRACKED-WORK.md](TRACKED-WORK.md) before edits.
- **Intent authority:** apply the rank in [PRD-AUTHORITY.md](../to-spec/PRD-AUTHORITY.md) as written. Before the first production edit, record in working notes: product baseline path, design source path, accepted `相对 PRD` deltas (each or `none`), and — when the spec has a PRD Inventory — the `SRC`s (clauses **and pin rows**) this ticket `Covers`.
- Multi-slice work with a detailed product doc and no eng spec yet → stop and route `/grill-code`.
- A `Covers` SRC whose ticket body still lists 残差 / 下张票收口 / partial → split a follow-up ticket or accept a labeled delta; `complete` is unavailable.
- **Last ticket / “已按 PRD 实现”:** run `/alignment-review` **prd-walk** against the original product doc (PRD-AUTHORITY §5) before claiming the package delivered. Any `缺` → not delivered.

### 0c. Isolate (default for code edits)

Work in a local worktree `worktree/<slug>` off the integration branch; record the integration branch at run start; never reuse another session's worktree. Docs-only runs, "don't commit" runs, and user-asked-in-place stay in the main checkout. Setup, merge-back, cleanup: [WORKTREE.md](WORKTREE.md).

### 1. Plan the slice (parent)

The Executor is often a weaker model that executes the brief literally. Every judgment call is the parent's, resolved **before** dispatch into the brief ([DISPATCH.md](DISPATCH.md) **Implementation brief**):

- **Acceptance** — final AC as concrete behavior with literal values (not SRC ids alone, not "per spec").
- **Files** — exact edit allowlist; read-first files with line ranges and what to copy; existing `file:symbol` to reuse (look for it yourself — the worker does not search).
- **Plan** — ordered edits, one line each. Binding.
- **Tests** — test file, test name, literal expected value per seam. Seams come from the spec's Testing Decisions or the ticket's Behavior gate; confirm with the user only when neither names them. A docs/config/mechanical slice with no behavior change writes `Tests: none — GREEN baseline`: the existing suite passing before and after is its evidence.
- **Baseline** — run the suite in the worktree before dispatch; list the tests already failing as `Already failing` (or `none`). In-place runs also list files dirty before the run as `Do not touch`.
- **Real source of truth** — where the slice reads a domain fact (rate, tax, owner), name the service/table the sibling path uses. No config stand-in in the plan.
- **Log points** — on external / async / webhook / MQ / state-machine paths, list each decision boundary and its fields ([FORENSIC-OBSERVABILITY.md](../code-review/FORENSIC-OBSERVABILITY.md)); else `none`.

- **Walkthrough table** — one row per Covered SRC / AC bullet: exact action, expected observation, evidence path. CRUD surfaces instantiate the fixed script with real field values: 新建 → 列表出现 → 编辑 → 详情回显 → 删除 → 列表消失 → 一次校验失败. API rows give the exact request; UI rows give URL + state. Put startup command, URL, login (env var names, never the secret), and seed data in the brief.
- **Stop conditions** — the observable triggers for `blocked` on this slice.

A decision the parent cannot settle → the slice is `blocked` on that named question; do not dispatch and hope. When the finished plan is already about as long as the code change (mechanical, one or two files), the parent makes the edit itself and skips §2 — the Executor's value is context isolation and running long verification/walkthrough.

### 2. Dispatch Executor (hard try)

Load [DISPATCH.md](DISPATCH.md) once per session. Per slice:

1. **Must try** pack role `Executor`; else the host's general coding subagent with the DISPATCH **Executor system text** + brief.
2. One slice per spawn; every brief line filled from §1. A new brief per slice.
3. Only after a recorded spawn failure, or when no subagent runtime exists, the parent implements the slice itself (`confidence: degraded`). Never abort because Executor is missing.

### 3. Accept (parent — the worker's report is a claim)

Run every check yourself; none is waived by the worker's `status: done`:

`<base>` = the worktree branch point. `git add -N .` first, so new files, staged, and committed changes all show.

1. Re-run each brief verify command in the worktree; exit codes match the report; only `Already failing` tests fail.
2. `git diff --name-only <base>` ⊆ the brief's edit allowlist (in-place: minus `Do not touch`), and `git status --porcelain` shows nothing else. Read every `off-plan edits` line the report lists.
3. `git diff -U0 <base> | grep '^+' | grep -nE 'TODO|FIXME|HACK|XXX|待接入|后续|临时|\.skip\(|\.only\(|@Disabled|@Ignore|@ts-ignore|eslint-disable|as any'` is empty; read the test-file diff — no weakened, deleted, or skipped assertion.
4. Test-bearing slice: the report's S2 output shows the new test failing for the AC's reason. GREEN-baseline slice: check 1 is the evidence. Fix-list brief: each fix's check output.
5. Open every walkthrough evidence file; compare it with the row's expected observation yourself. UI: judge pin rows against the design source ([UI.md](UI.md)). A row reported `blocked (env: …)` → confirm the missing fact yourself (run the startup/login step); confirmed → stop and report it to the user — this is not a rejection.
6. Judge the diff for incomplete surface ([INCOMPLETE-SURFACE.md](../code-review/INCOMPLETE-SURFACE.md)): real domain step on every production path of this AC; planned log points present; logging fail-open. Logging foundation missing on an applicable path → `observability: foundation-missing`, point at `/setup-logging`, stop.

The parent's own edits (§1 skip, or takeover) run checks 1–3, 5, 6 the same way.

A failed check → new brief to Executor naming the check, its exact output, and the fix. After 2 rejections of one slice, the parent takes it over or marks it `blocked`. All pass → `/simplify` when the delta is non-trivial (re-run 1–3 after), then commit in the worktree referencing the ticket. **Accepted** = every check above passed.

### 4. Review

Pick **`review-weight`** from `/code-review` **Pick weight** before spawning anyone; it owns which workers run and the rule that weight never waives §3 evidence.

- **`none`** — no `/code-review`, no Reviewer, no Verifier. Record `review-weight: none` plus one sentence naming the seam (e.g. "existing-field serializer annotation" — that keeps field name, path, and message name, so it is not a wire rename).
- **`light` / `full`** — run `/code-review` against the worktree branch base (`git diff <base>..HEAD`). Pass product baseline, design source paths, accepted PRD deltas, and (UI Fidelity in scope) pin rows + evidence paths as intent evidence.

Verdict not `Pass` with fixes in scope → Executor with the DISPATCH **Fix-list brief**, then §3 again (check 4 = the per-fix check outputs). `Pass` requires: §3 accepted; no product-doc gap without an accepted delta; pin rows evidenced or user-waived; no same-surface lookalike. Parent-fallback workers → `confidence: degraded` (prefer an independent review or human gate before merge).

### 5. Merge back, clean up

After §3 accepted and §4 applied, merge back and clean up per [WORKTREE.md](WORKTREE.md). An unaccepted slice stays unmerged. Afterwards `git status` in the main checkout is clean except files declared unrelated.

### 6. Close the ticket

A tracked ticket this run finished closes **in the same run**, after the merge lands. Done means all of:

- §3 accepted: every Covered row has parent-checked runtime evidence (or `blocked (env: …)` reported), pin rows judged against the design source or user-waived
- review weight applied; no incomplete surface for the claimed AC
- ticket body free of 残差 / 下张票收口 / partial for every `Covers` SRC
- PRD-sourced `Covers` → mini prd-walk of this ticket's SRCs against the original product doc using the walkthrough evidence; any `缺` → follow-up ticket or labeled accepted delta, and this ticket stays open

Close through the configured tracker (`docs/agents/issue-tracker.md`): comment the acceptance result, walkthrough evidence, review weight + verdict, commit link; close; **read it back** — Done is invalid while it still reads `open`. Unfinished slice (review `Changes Required`, blocked, prd-walk `缺`, 残差 in body) → leave it open and say why.

This was the spec's **last** open child → run the package prd-walk (§0). No `缺` → close the parent spec by the tracker's closeout sequence and read it back; else name what holds it open. Under `/implement-spec` skip this paragraph — its step 9 closes the spec after the branch review.

### Done report (mandatory fields)

1. **task / ticket / source** — product-doc path **and** design-source path when present
2. **walkthrough** — per Covered row: action → actual result (evidence path), or `blocked (env: …)`
3. **fidelity** — per pin row 原型 vs 实现 (parent-judged) | `n/a` | user waiver (rows listed)
4. **review-weight + verdict** — `none | light | full` + verdict; `agents used`; `confidence: degraded` when any required worker was parent-fallback
5. **PRD deltas** — `none` | accepted `相对 PRD` rows used | gaps (a gap forces non-Pass)
6. **quality** — `accept: passed | rejected <n>× (<check>)` · `incomplete-surface` · `observability` · `same-surface`
7. **ticket + merge-back** — `closed #<n> (read-back: closed)` | `left open (<why>)` | `n/a`; `<integration-branch>@<sha>` | `held` | `n/a (in-place)`; worktree `removed` | `left: <why>`
8. **blockers / next frontier** — prd-walk result when run (`SRC × 过/缺/有意 delta`)
