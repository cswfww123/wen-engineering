---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Use /tdd where possible, at pre-agreed seams.

Run typechecking regularly, single test files regularly, and the full test suite once at the end.

Done means **walkthrough-proven**: the app runs and every Covered clause / AC bullet passes on its real path, with per-row runtime evidence (§2.4). Tests green + diff looks right is not Done on its own.

Once done, pick a review weight from `/code-review` **Pick weight** and follow it. Simple fixes (`none`) skip `/code-review`. Medium fixes use light review. Large requirements use full review, which includes Verifier.

Code edits happen in an isolated local worktree and merge back to the current branch once the slice passes. Worktree setup, merge-back, cleanup: [WORKTREE.md](WORKTREE.md). Commit your work to the current branch.

## WEN process (required — read before writing code)

These steps **bind** how the steps above are executed in this pack. They do not
replace TDD / typecheck / walkthrough / review / commit.

### 0. Route and bound

- Clear bounded request **or** one implementation-frontier ticket only.
- Intent not ready → stop; do not invent Expected (see project lifecycle docs if present).
- Note layer (`frontend` | `backend` | `full-stack` | `non-UI`) for fidelity later.
- UI layers: if a package-root `DESIGN.md` exists (Google Labs visual identity), treat it as **visual environment** for fidelity — tokens + Do's/Don'ts. Missing identity with multi-screen UI drift → optional `/to-design-md`, not a blocker for non-UI tickets.
- **Design source present (原型图 / 设计稿 / Figma / 截图 / HTML 原型 / pinned winner) → it is product AC.** Extract its observable details as **pin rows** for this slice (chat table or ticket body is enough — `docs/prd-authority.md` §2) before the first edit, and name the source path in the Executor brief.
- Look before you write (ponytail reuse rung): a helper, type, or pattern already on this surface or a few files over → reuse it. Same-surface chrome is the **refuse-to-pass** form of that rung.
- UI chrome (filter / picker / search / empty-state / chip / toolbar control): load [SAME-SURFACE.md](../code-review/SAME-SURFACE.md) **before** the first control edit. Name the **owner** already on that screen (or `new — no sibling`) in the Executor brief. Extra instances **extend the owner**. User 样式不一样 / 不能复用 / 为什么新写 of sibling controls is a same-surface hit, not a restyle.
- Tracked work (frontier, bug-report conversion, HITL, claim): load
  [TRACKED-WORK.md](TRACKED-WORK.md) **before** edits.

### 0b. Intent authority (hard)

When choosing what AC to build and what review must prove, use this order:

1. **Product requirements / PRD / in-repo product doc — including its design pin / 原型图 rows** (`docs/requirements/*`, `docs/prd/*`, user-named PRD path) — primary *product behavior* source when present.
2. **Accepted eng spec / implementation tickets** derived from that product source.
3. **Explicit user-authorized deltas** only when labeled as relative to the product doc (e.g. grill row `相对 PRD: …` accepted in session, or ticket Out-of-scope with PRD ref). Unlabeled chat “MVP” does **not** override the product doc.
4. **Grill / chat residual** — eng seams and pins the product doc does not specify.
5. **Code / tests** — environment facts after ship; not a license to drop product-doc behavior mid-implement.

Binding:

- Multi-slice work with a detailed product doc and no eng spec yet → prefer stop and route **`/grill-code`** (default entry: sweep + residual poles) — do not invent a parallel “grill AC supersedes PRD” package.
- Before first production edit: name the **product baseline path** (or “none”), the **design source path** (or “none”), and **accepted PRD deltas** (or “none”) in the working notes / Executor brief. If the parent spec has a PRD Inventory, list the `SRC`s (PRD clauses **and pin rows**) this ticket `Covers`.
- Implement to grill recap while leaving unlabeled PRD gaps, then reporting “grill AC 满足” as Pass, is **wrong AC** — prohibited outcome.
- Done report **source** field must list product-doc path when used; if any claimed AC is a PRD delta, list those deltas explicitly.
- Ticket body still listing 残差 / 下张票收口 / partial for a `Covers` SRC → split a follow-up ticket or accept a labeled delta; `complete` is unavailable.
- **Last ticket / “已按 PRD 实现”:** run `/alignment-review` **prd-walk** against the **original product doc** (`docs/prd-authority.md` §5) before claiming the package delivered. Any `缺` → the package is not delivered.

### 0c. Isolate (default for code edits)

Work in a local worktree `worktree/<slug>` off the integration branch; record the integration branch at run start; never reuse another session's worktree. Docs-only runs, no-commit runs, and user-asked-in-place stay in the main checkout. Full setup, merge-back, and cleanup rules: [WORKTREE.md](WORKTREE.md).

### 1. Hard-try Executor before non-trivial edits

**Before** the first non-trivial production edit (and for each subsequent
vertical slice), run the dispatch ladder. Load [DISPATCH.md](DISPATCH.md) once
per session.

1. **Must try** spawn pack role `Executor` if the host can load it; else spawn
   the host's general multi-step / coding subagent with the **Executor system
   text + brief** from [DISPATCH.md](DISPATCH.md).
2. **Spawn with the recommended full brief** (not a one-liner). Subagent
   context is cold/disposable and often a weaker model — paste AC, design
   source paths, scope, pattern refs, verify + walkthrough commands,
   authority, and decision-critical evidence. Thin briefs are a process bug.
3. **UI / design-pin slices: spawn Executor on the parent-tier model when the
   host allows** — fidelity work degrades fast on weaker models.
4. If spawn fails or no subagent runtime exists → parent performs the same
   bounded slice in-session (soft fail).
5. **Never** abort because Executor is missing. Parent bulk-implements a
   multi-slice feature without at least one Executor (or host-general) attempt
   recorded for that slice only when no runtime exists.

Tiny one-line mechanical edits may stay in parent when cheaper.

### 2. Evidence loop (via Executor ladder)

Per slice, Executor (or fallback) does:

1. Confirm / record seams with the user or ticket AC.
2. `/tdd` red → green at those seams (or authorized GREEN baseline for
   mechanical docs/config). Green must lock the **real** domain step at the
   seam — not a config constant that sidesteps a sibling path's source of truth
   (see [incomplete surface](../code-review/INCOMPLETE-SURFACE.md)).
3. `/simplify` when the delta is non-trivial.
4. **Walkthrough — the behavior gate (blocking).** Start the app with the
   brief's startup commands and drive **every Covered SRC / AC bullet through
   its real path**. A CRUD surface runs the fixed script: **新建 → 列表出现 →
   编辑 → 详情回显 → 删除 → 列表消失 → 一次校验失败路径**. UI rows return a
   screenshot each; API rows return request + response. Executor reports each
   step's **actual result** (what appeared / what errored). A Covered row with
   no runtime evidence is not Done. The environment cannot run the app →
   report `blocked (env: <what's missing>)` and let the user route; a silent
   skip is a blocked path. Layer verify commands (typecheck/tests) from the
   brief run alongside.
5. **Fidelity vs design source.** Ticket carries pin rows / 原型图 → Executor
   opens the design files **itself** (paths from the brief's Design source
   field) and returns a per-row **原型 vs 实现** comparison (side-by-side
   screenshots for UI). This evidence is owed under **every** review weight —
   weight decides review workers, never evidence. Restyling a lookalike to
   match sibling chrome is **same-surface**, not fidelity
   ([SAME-SURFACE.md](../code-review/SAME-SURFACE.md)). Light visibility of
   untouched existing chrome: one path screenshot. A checklist-only waiver
   comes from an explicit user grant and lists its rows.
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
| **none** | Do not run `/code-review`. Do not spawn a Reviewer or a Verifier. Record `review-weight: none` plus one sentence naming the seam (for example "existing-field serializer annotation"). The walkthrough (§2.4) + test loop above is the gate. Then commit when authorized. |
| **light** | One Slice Reviewer. Verifier only if that reviewer filed a candidate. |
| **full** | Full `/code-review`, then Verifier even when candidates are `none`. |

A serializer or annotation that keeps the field name, path, and message name
is **`none`**. Do not call that a wire/protocol rename.

**Evidence is weight-independent.** Walkthrough results (§2.4) and fidelity
evidence (§2.5) are Done criteria owed under every weight; `none` / `light`
skip review *workers*, never evidence.

1. Record a review fixed point that isolates this ticket/task delta. In the
   worktree flow the fixed point is the **branch base** (`git diff
   <base>..HEAD` inside the worktree). Skip when weight is `none`.
2. Run `/code-review` against that fixed point when weight is `light` or
   `full`. Pass the **product baseline path**, **design source paths**, and any
   **accepted PRD deltas** into intent evidence — not grill-only AC. When UI
   Fidelity is in scope, pass **pin rows + fidelity evidence paths**.
3. Verdict not `Pass` and fixes in scope → hard-try **Executor** again with
   the eligible fix list + fix contract from code-review.
4. Complete only this ticket/task; the parent **spec** closes elsewhere.
5. `Pass` requires: no incomplete surface for claimed AC; no product-doc gap
   without an explicit accepted PRD delta; pin rows either evidenced or
   user-waived; no same-surface lookalike; parent-fallback runs reported as
   `confidence: degraded` (prefer an independent `/code-review` or human gate
   before merge).

### 4. Commit, merge back, clean up

Commit only when authorized. A slice missing walkthrough evidence (§2.4) or
carrying an incomplete production surface for its AC stays uncommitted.
Worktree runs merge back after the review weight was applied and §5 Done
criteria hold; sequence and cleanup per [WORKTREE.md](WORKTREE.md). Then close
the ticket — never before the merge lands.

### 5. Close the ticket

When this run implemented a tracked ticket and the work is actually done,
**close that ticket in the same run**. An open ticket after a finished slice
reads as "not done". Do this after the merge-back lands (or the commit /
authorized uncommitted delta), and after the review weight for this slice was
applied.

Done means all of these:

- every Covered SRC / AC bullet has **walkthrough runtime evidence** (§2.4)
- pin rows have fidelity evidence or an explicit user-granted waiver (§2.5)
- the required review weight was applied
- no incomplete production surface remains for the claimed AC
- the ticket body is free of 残差 / 下张票收口 / partial for every `Covers` SRC
- **PRD-sourced `Covers` → mini prd-walk:** walk this ticket's Covered SRCs
  against the **original product doc** using the walkthrough results; any `缺`
  → follow-up ticket or labeled accepted delta, and this ticket stays open

Close through the configured tracker (see `docs/agents/issue-tracker.md` when
that is the adapter). Comment with the acceptance result, the walkthrough
evidence, the review weight and verdict, and the commit link. Then close the
issue and **read it back**. Done is invalid if the read-back still shows
`open`.

Leave the ticket open and say so in the Done report when the slice stopped
unfinished (review `Changes Required`, blocked incomplete surface, failed
prd-walk `缺`, or a body still listing 残差). Never report "done" while the
ticket is still open. Parent specs close via the package prd-walk (§0b), not
here.

### Done report (mandatory fields)

1. **task / ticket / source** — include product-doc path **and** design-source
   path when present; grill AC never stands in as the only source beside a PRD
2. **walkthrough evidence** — per Covered row: step → actual result
   (screenshot / request+response paths), or `blocked (env: …)`
3. **fidelity** — per pin row 原型 vs 实现 outcome | `n/a` (non-UI) |
   user-granted waiver (rows listed)
4. **review-weight + verdict** — `none | light | full` + code-review verdict;
   add `confidence: degraded` when any required worker used parent-fallback or
   spawn was skipped without attempt (also list `agents used`)
5. **PRD deltas** — `none` | accepted `相对 PRD` rows used as AC | gaps found
   (a gap forces non-Pass; never bury it as “known non-blocking”)
6. **quality flags** — one line: `incomplete-surface: … · observability: … ·
   same-surface: …`
7. **ticket + merge-back** — `closed #<n> (read-back: closed)` | `left open
   (<why>)` | `n/a`; merge-back `<integration-branch>@<sha>` | `held` | `n/a
   (in-place)`; worktree cleanup `removed` | `left: <list + why>`; commit
   status
8. **blockers / next frontier** — including prd-walk result when run
   (`SRC × 过/缺/有意 delta`; `缺` forces non-delivered)
