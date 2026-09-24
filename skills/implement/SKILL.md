---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Once done, pick a review weight from `/code-review` **Pick weight** and follow it. Simple fixes (`none`) skip `/code-review`. Medium fixes use light review. Large requirements use full review, which includes Verifier.

Commit your work to the current branch.

## WEN process (required — read before writing code)

These steps **bind** how the Matt steps above are executed in this pack. They
do not replace TDD / typecheck / review / commit.

### 0. Route and bound

- Clear bounded request **or** one implementation-frontier ticket only.
- Intent not ready → stop; do not invent Expected (see project lifecycle docs if present).
- Note layer (`frontend` | `backend` | `full-stack` | `non-UI`) for fidelity later.
- UI layers: if a package-root `DESIGN.md` exists (Google Labs visual identity), treat it as **visual environment** for fidelity — tokens + Do's/Don'ts. Missing identity with multi-screen UI drift → optional `/to-design-md`, not a blocker for non-UI tickets.
- Look before you write (ponytail reuse rung): a helper, type, or pattern already on this surface or a few files over → reuse it. Same-surface chrome is the **refuse-to-pass** form of that rung.
- UI chrome (filter / picker / search / empty-state / chip / toolbar control): load [SAME-SURFACE.md](../code-review/SAME-SURFACE.md) **before** the first control edit. Name the **owner** already on that screen (or `new — no sibling`) in the Executor brief. Extra instances **extend the owner**. User 样式不一样 / 不能复用 / 为什么新写 of sibling controls is a same-surface hit, not a restyle. Shortest new `Select` beside the owner is not lazy.
- Tracked work (frontier, bug-report conversion, HITL, claim): load
  [TRACKED-WORK.md](TRACKED-WORK.md) **before** edits.

### 0b. Intent authority (hard)

When choosing what AC to build and what Spec review must prove, use this order:

1. **Product requirements / PRD / in-repo product doc** (`docs/requirements/*`, `docs/prd/*`, user-named PRD path) — primary *product behavior* source when present.
2. **Accepted eng spec / implementation tickets** derived from that product source.
3. **Explicit user-authorized deltas** only when labeled as relative to the product doc (e.g. grill row `相对 PRD: …` accepted in session, or ticket Out-of-scope with PRD ref). Unlabeled chat “MVP” does **not** override the product doc.
4. **Grill / chat residual** — eng seams and pins the product doc does not specify.
5. **Code / tests** — environment facts after ship; not a license to drop product-doc behavior mid-implement.

Binding:

- Multi-slice work with a detailed product doc and no eng spec yet → prefer stop and route **`/to-spec`** (do not invent a parallel “grill AC supersedes PRD” package).
- Before first production edit: name the **product baseline path** (or “none”) and **accepted PRD deltas** (or “none”) in the working notes / Executor brief. If the parent spec has a PRD Inventory, list the `SRC`s this ticket `Covers`.
- **Forbidden:** treat grill recap alone as full AC when an active product doc covers the same surface; implement to grill while leaving unlabeled PRD gaps, then report “grill AC 满足” as Pass.
- Done report **source** field must list product doc path when used; if any claimed AC is a PRD delta, list those deltas explicitly under incomplete/deferred or accepted-delta.
- **Forbidden complete:** ticket body still listing 残差 / 下张票收口 / partial for a `Covers` SRC. Split a follow-up ticket or accept a labeled delta — do not `complete`.
- **Last ticket / “已按 PRD 实现”:** run `/alignment-review` **prd-walk** against the **original product doc** (`docs/prd-authority.md` §5) before claiming the package delivered. Any `缺` → do not say 已按 PRD 实现; do not mark the parent delivered.

### 1. Hard-try Executor before non-trivial edits

**Before** the first non-trivial production edit (and for each subsequent
vertical slice), run the dispatch ladder. Load [DISPATCH.md](DISPATCH.md) once
per session.

1. **Must try** spawn pack role `Executor` if the host can load it; else spawn
   the host's general multi-step / coding subagent with the **Executor system
   text + brief** from [DISPATCH.md](DISPATCH.md).
2. **Spawn with the recommended full brief** (not a one-liner). Subagent
   context is cold/disposable and often a weaker model — paste AC, scope,
   pattern refs, verify commands, authority, and decision-critical evidence.
   Thin briefs are a process bug; see [DISPATCH.md](DISPATCH.md) and
   orchestration Brief quality.
3. If spawn fails or no subagent runtime exists → parent performs the same
   bounded slice in-session (soft fail).
4. **Never** abort because Executor is missing.
5. **Forbidden:** parent bulk-implements a multi-slice feature while a subagent
   runtime exists **without at least one Executor (or host-general) attempt**
   recorded for that slice.

Tiny one-line mechanical edits may stay in parent when cheaper.

### 2. Evidence loop (via Executor ladder)

Per slice, Executor (or fallback) does:

1. Confirm / record seams with the user or ticket AC.
2. `/tdd` red → green at those seams (or authorized GREEN baseline for
   mechanical docs/config). Green must lock the **real** domain step at the
   seam — not a config constant that sidesteps a sibling path's source of truth
   (see [incomplete surface](../code-review/INCOMPLETE-SURFACE.md)).
3. `/simplify` when the delta is non-trivial.
4. Project verification for this layer (behavior gate).
5. Fidelity when applicable (API vs stated contract; UI vs design pin when
   `/code-review` will mark UI Fidelity in scope). New/restyled chrome or a
   pin: collect pin@version (or checklist-only waiver) plus screenshot and/or
   checklist **before review**. Light visibility/default of existing chrome:
   one path screenshot or checklist item before Done — not a UI Fidelity
   worker. Do not claim UI fidelity without that evidence. Restyling a
   lookalike to match sibling chrome is **same-surface**, not light
   visibility ([SAME-SURFACE.md](../code-review/SAME-SURFACE.md)).
6. **Incomplete-surface + forensic observability self-check** before claiming
   the slice ready for review: production paths for this AC must be complete.
   Deferred markers, placeholders, dual-source domain facts, config stand-ins,
   **quiet critical paths**, and **log-unsafe** logging on live paths are
   forbidden — finish the real step or **stop and report a blocker**.
   Classifier: [INCOMPLETE-SURFACE.md](../code-review/INCOMPLETE-SURFACE.md).
   On external/async/webhook/MQ/third-party/state-machine paths: instrument
   decision boundaries (ingress, branch/skip, before→after, external outcome
   including empty, fan-out) with correlatable field logs; **logging is
   fail-open** — log/MDC/metrics failure must never fail or gate business.
   If the project lacks a required logging foundation, report
   `observability: foundation-missing`, point at `/setup-logging`, and stop
   rather than shipping quiet paths. Contract:
   [FORENSIC-OBSERVABILITY.md](../code-review/FORENSIC-OBSERVABILITY.md).

Parent re-issues a **new** Executor brief per slice — not one mega-todo dump
that never dispatches.

### 3. Review

Pick **`review-weight`** from `/code-review` **Pick weight** before spawning
anyone. Size, not a stretched risk word, decides:

| Weight | Do |
| --- | --- |
| **none** | Do not run `/code-review`. Do not spawn a Reviewer or a Verifier. Record `review-weight: none` plus one sentence naming the seam (for example "existing-field serializer annotation"). The test loop above is the gate. Then commit when authorized. |
| **light** | One Slice Reviewer. Verifier only if that reviewer filed a candidate. |
| **full** | Full `/code-review`, then Verifier even when candidates are `none`. |

A serializer or annotation that keeps the field name, path, and message name
is **`none`**. Do not call that a wire/protocol rename.

1. Record a review fixed point that isolates this ticket/task delta. Skip this
   step when weight is `none`.
2. Run `/code-review` against that fixed point only when weight is `light` or
   `full`. That skill names the workers — do not spawn four axes on a light
   slice, and do not spawn Verifier on a clean light slice or on `none`.
   Pass the **product baseline path** and any **accepted PRD deltas** into
   intent evidence — not grill-only AC. When UI Fidelity is in scope, pass
   **design pin + fidelity evidence paths**. On **light**, if existing chrome
   newly appears on a path, collect one screenshot or one checklist item of
   that path before Done (parent evidence, not a UI Fidelity worker).
3. If verdict is not `Pass` and fixes are in scope (`/implement` authorizes
   in-scope behavior-preserving fixes): hard-try **Executor** again with the
   eligible fix list + fix contract from code-review.
4. Do not close a parent **spec**; complete only this ticket/task.
5. **`Pass` is invalid** if an incomplete surface remains for claimed AC —
   even when Standards looks clean and thin tests are green.
6. **`Pass` is invalid** when Spec / Slice review finds product-doc behavior
   missing/partial **without** an explicit accepted PRD delta for that gap —
   do not reclassify as “known non-blocking because grill AC matched.”
7. **`Pass` is invalid** when UI Fidelity is in scope and design pin is missing
   without checklist-only waiver, or fidelity evidence (screenshot/checklist)
   is missing.
8. **`Pass` is invalid** when a same-surface lookalike remains (new widget +
   CSS beside the owner of that family). Light `ui-fidelity: n/a` does not
   waive it. Classifier: [SAME-SURFACE.md](../code-review/SAME-SURFACE.md).
9. If Executor or a required review worker used **parent-fallback** (no
   independent worker attempt): Done report **confidence: degraded**; do not
   present as a full multi-agent Pass — prefer a further independent
   `/code-review` or human gate before merge.

### 4. Commit

Commit only when authorized, on the current branch. Do **not** commit a slice
that still carries an incomplete production surface for its AC.

After the commit, `git status` is clean except files declared unrelated before
the commit (e.g. local `.scratch/`). Uncommitted leftovers of reverted hunks
fail Done — do not report a clean slice.

### 5. Close the ticket

When this run implemented a tracked ticket and the work is actually done,
**close that ticket in the same run**. An open ticket after a finished slice
reads as "not done". Do this after the commit (or after the authorized
uncommitted delta, when commit was not granted), and after the review weight
for this slice has been applied (`none` recorded, or `light`/`full` verdict
`Pass`).

Done means all of these:

- the ticket's acceptance criteria are met
- the required review weight was applied
- no incomplete production surface remains for the claimed AC
- the ticket body does not still list 残差 / 下张票收口 / partial for a `Covers` SRC

Close through the configured tracker (see `docs/agents/issue-tracker.md` when
that is the adapter). Comment with the acceptance result, the verification
command and result, the review weight and verdict, and the commit link. Then
close the issue and **read it back**. Done is invalid if the read-back still
shows `open`.

Do **not** close:

- a parent **spec** (only this implementation ticket)
- a ticket that is not done, including review `Changes Required`, a blocked
  incomplete surface, a failed prd-walk (`缺`), or a body that still lists 残差
- a ticket this run did not implement

If the slice stopped unfinished, leave the ticket open and say so in the Done
report. Never report "done" while the ticket is still open.

### Done report (mandatory fields)

- task / ticket / source (**include product-doc path when present**; do not list
  grill AC as the only source alongside a PRD)
- **PRD deltas**: `none` | list of accepted `相对 PRD` rows used as AC
- fixed point
- files changed
- **review-weight**: `none` | `light` | `full` (from `/code-review` Pick weight). `none` includes the one-line reason and `code-review verdict: skipped`.
- behavior-gate + fidelity (or n/a)
- **UI fidelity evidence** (when UI Fidelity ran, or light parent path check):
  pin path@version | checklist-only waiver | one path screenshot/checklist;
  else `n/a`
- **same-surface** (UI chrome slices): `owner-extended` | `new-no-sibling` |
  `n/a` (non-UI) | findings (lookalike — cannot Pass)
- **ui-fidelity** (from review): `pass` | `fail` | `blocked-no-pin` | `n/a`
- **incomplete-surface check**: `clean` | `blocked` (cite signal) | `n/a` (docs/config only)
- **observability**: `instrumented` | `foundation-missing` | `quiet-path` | `log-unsafe` | `n/a`
- code-review verdict
- **confidence**: `normal` | `degraded` (required when any required worker used
  parent-fallback, or spawn was skipped without attempt)
- **`agents used`**: e.g. `Executor` | `host-general` | `parent-fallback` (and
  for review: `Reviewer` / `Verifier` / fallback) — if parent did the work,
  say so explicitly and why (no runtime / spawn failed)
- **ticket**: `closed #<n> (read-back: closed)` | `left open (<why>)` | `n/a` (no tracked ticket). `closed` requires the read-back. An open ticket cannot be reported as done.
- tracker update, commit status, next frontier or blocker
- **unauthorized PRD partials** (if any): must force non-Pass or explicit
  user decision — never bury under “known non-blocking”
- **prd-walk** (last ticket of a PRD-sourced spec, or user asked 已按 PRD 实现):
  `n/a` | table (`SRC` × `过`/`缺`/`有意 delta`). `缺` forces non-delivered.
