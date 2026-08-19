---
name: code-review
description: Review a diff since a fixed point. Picks light (one Slice Reviewer) or full (Standards/Spec/Correctness, plus UI Fidelity when a pin or restyle exists). Use when reviewing a branch, PR, implement slice, or "review since X".
---

Two-axis review of the diff between `HEAD` and a fixed point the user supplies:

- **Standards** — does the code conform to this repo's documented coding standards?
- **Spec** — does the code faithfully implement the originating issue / PRD / spec?

Both axes run as **parallel sub-agents** so they don't pollute each other's context, then this skill aggregates their findings.

The issue tracker should have been provided to you — run `/setup-project-harness` if `docs/agents/issue-tracker.md` is missing.

## Process

### 1. Pin the fixed point

Whatever the user said is the fixed point — a commit SHA, branch name, tag, `main`, `HEAD~5`, etc. If they didn't specify one, ask for it.

Capture the diff command once: `git diff <fixed-point>...HEAD` (three-dot, so the comparison is against the merge-base). Also note the list of commits via `git log <fixed-point>..HEAD --oneline`.

Before going further, confirm the fixed point resolves (`git rev-parse <fixed-point>`) and the diff is non-empty. A bad ref or empty diff should fail here — not inside two parallel sub-agents.

### 2. Identify the spec source

Look for the originating intent sources (collect **all** that apply; do not stop at the first hit if a product doc and a session AC both exist):

1. Issue references in the commit messages (`#123`, `Closes #45`, GitLab `!67`, etc.) — fetch via the workflow in `docs/agents/issue-tracker.md`.
2. A path the user passed as an argument (product doc, eng spec, ticket).
3. A product requirements / PRD / eng-spec file under `docs/`, `docs/requirements/`, `docs/prd/`, `specs/`, or `.scratch/` matching the branch name or feature.
4. Explicit session decisions **only when labeled as accepted PRD deltas** (e.g. grill `相对 PRD: …`) or written ticket Out-of-scope with PRD ref — not unlabeled chat MVP.
5. If nothing is found, ask the user where the spec is. If they say there isn't one, the **Spec** sub-agent will skip and report "no spec available".

**Authority when sources conflict:**

| Rank | Source | Role |
| --- | --- | --- |
| 1 | Active product requirements / PRD | Product behavior baseline |
| 2 | Eng spec / implementation tickets derived from it | Slice AC |
| 3 | Explicit accepted `相对 PRD` deltas | Authorized deviations only |
| 4 | Grill / chat residual | Eng seams the product doc does not specify |

- Matching grill AC while missing unlabeled product-doc behavior → **Spec finding** (partial/missing). **Not** “non-blocking because grill AC 满足.”
- Unauthorized product-doc partial → fixability `needs-user-decision` or blocking Spec gap; **cannot** aggregate to Pass by preferring session AC.
- “Code wins” does **not** apply to product intent vs PRD.
- Slice review does **not** replace package **prd-walk** (`docs/prd-authority.md` §5) when the last ticket closes or the user asks 已按 PRD 实现.

### 3. Identify the standards sources

Anything in the repo that documents how code should be written, such as `CODING_STANDARDS.md` or `CONTRIBUTING.md`.

On top of whatever the repo documents, the Standards axis always carries the **smell baseline** below — a fixed set of Fowler code smells (_Refactoring_, ch.3) that applies even when a repo documents nothing. Two rules bind it:

- **The repo overrides.** A documented repo standard always wins; where it endorses something the baseline would flag, suppress the smell.
- **Always a judgement call.** Each smell is a labelled heuristic ("possible Feature Envy"), never a hard violation — and, like any standard here, skip anything tooling already enforces.

Each smell reads *what it is* → *how to fix*; match it against the diff:

- **Mysterious Name** — a function, variable, or type whose name doesn't reveal what it does or holds. → rename it; if no honest name comes, the design's murky.
- **Duplicated Code** — the same logic shape appears in more than one hunk or file in the change. → extract the shared shape, call it from both.
- **Feature Envy** — a method that reaches into another object's data more than its own. → move the method onto the data it envies.
- **Data Clumps** — the same few fields or params keep travelling together (a type wanting to be born). → bundle them into one type, pass that.
- **Primitive Obsession** — a primitive or string standing in for a domain concept that deserves its own type. → give the concept its own small type.
- **Repeated Switches** — the same `switch`/`if`-cascade on the same type recurs across the change. → replace with polymorphism, or one map both sites share.
- **Shotgun Surgery** — one logical change forces scattered edits across many files in the diff. → gather what changes together into one module.
- **Divergent Change** — one file or module is edited for several unrelated reasons. → split so each module changes for one reason.
- **Speculative Generality** — abstraction, parameters, or hooks added for needs the spec doesn't have. → delete it; inline back until a real need shows.
- **Message Chains** — long `a.b().c().d()` navigation the caller shouldn't depend on. → hide the walk behind one method on the first object.
- **Middle Man** — a class or function that mostly just delegates onward. → cut it, call the real target direct.
- **Refused Bequest** — a subclass or implementer that ignores or overrides most of what it inherits. → drop the inheritance, use composition.

### 4. Spawn both sub-agents in parallel

Send a single message with two `Agent` tool calls. Use the `general-purpose` subagent for both.

**Standards sub-agent prompt** — include:

- The full diff command and commit list.
- The list of standards-source files you found in step 3, **plus the smell baseline from step 3** pasted in full — the sub-agent has no other access to it.
- The brief: "Report — per file/hunk where relevant — (a) every place the diff violates a documented standard: cite the standard (file + the rule); and (b) any baseline smell you spot: name it and quote the hunk. Distinguish hard violations from judgement calls — documented-standard breaches can be hard, but baseline smells are always judgement calls, and a documented repo standard overrides the baseline. Skip anything tooling enforces. Under 400 words."

**Spec sub-agent prompt** — include:

- The diff command and commit list.
- The path or fetched contents of **every** intent source from step 2 (product doc + eng spec/tickets + accepted PRD deltas list, or “none”).
- The authority rank above.
- The brief: "Dual-read product baseline and session/ticket AC. Report: (a) product-doc / spec requirements missing or partial without an explicit accepted PRD delta; (b) behaviour in the diff that wasn't asked for (scope creep); (c) requirements that look implemented but where the implementation looks wrong; (d) any place session AC was used to paper over PRD gaps. Quote the product-doc or spec line for each finding. Do not dismiss PRD gaps as non-blocking solely because grill AC matched. Under 400 words."

If the spec is missing, skip the Spec sub-agent and note this in the final report.

### 5. Aggregate

Present the reports under `## Standards`, `## Spec`, and (when run) `## Correctness` / `## UI Fidelity` / other extra-axis headings, verbatim or lightly cleaned. Do **not** merge or rerank findings across axes (see _Why two axes_).

End with a one-line summary: **review-weight**, total findings per worker, the
worst issue _within each heading_ (if any), **incomplete-surface**: `clean` |
findings | `n/a`, and **ui-fidelity** when that axis ran (else `n/a`). Don't
pick a single winner across axes — that's the reranking the separation exists
to prevent. Light reports under `## Slice` instead of Standards/Spec.

## Why two axes

A change can pass one axis and fail the other:

- Code that follows every standard but implements the wrong thing → **Standards pass, Spec fail.**
- Code that does exactly what the issue asked but breaks the project's conventions → **Spec pass, Standards fail.**

Reporting them separately stops one axis from masking the other.

## WEN process (required)

Keep Matt's two axes (Standards + Spec) and process steps 1–5 above. This section
binds **how** subagents are used when the host has a spawn runtime.

### Diff gate (before any Reviewer)

Read the **full** diff, not only `--stat`. Every hunk must belong to the stated
AC / review scope. Revert extra hunks first. A dirty tree is not ready for
review.

### Pick weight

Record **`review-weight`**: `light` | `full`. This table is the only owner of
which workers run.

| Default | When |
| --- | --- |
| **light** | `/implement` of a bounded slice |
| **full** | standalone `/code-review` of a branch, PR, or named range |

**Escalate light → full** when **any** of these is true:

- New or restyled user-visible chrome, or a design pin exists to compare
- Money, authz, tenant isolation, state machine, dual-write, migration, or wire/protocol rename
- External / async / webhook / MQ / third-party path (forensic logs apply)
- Frontend and backend in one slice, or more than two production modules with distinct control flow

Visibility, default, enablement, or copy of **existing** chrome — no pin, no
restyle — stays **light**.

### Hard-try Reviewer / Verifier

**Before** step 5 Aggregate, load [DISPATCH.md](DISPATCH.md). Spawn only the
workers this weight names. Prefer pack `Reviewer` / `Verifier`; else host
`general-purpose` with [AGENT-BRIEFS.md](AGENT-BRIEFS.md).

**Light**

1. One `Reviewer` with the **Slice** brief: AC coverage, extra hunks, broken
   paths, incomplete-surface scan.
2. Incomplete surface and fail-open logging stay **blocking** on production
   diffs ([INCOMPLETE-SURFACE.md](INCOMPLETE-SURFACE.md),
   [FORENSIC-OBSERVABILITY.md](FORENSIC-OBSERVABILITY.md)). Light folds that
   class into the Slice Reviewer — it does not drop the check.
3. `ui-fidelity: n/a`. No UI Fidelity worker.
4. Newly shown existing chrome still needs parent evidence of that path (one
   screenshot or one checklist item) before `/implement` Done.
5. **Verifier** only when the Slice Reviewer filed a candidate.

**Full**

1. Parallel `Reviewer`s: **Standards** + **Spec** (Matt step 4). Plus
   **Correctness** on production-reachable code (skip only docs / comment /
   config-rename). Forensic log-chain on applicable paths; logging is
   fail-open. Optional extra axes when warranted: **Performance**,
   **Security**, **Ponytail**. Detail: [REVIEW-AXES.md](REVIEW-AXES.md),
   [PROJECT-LENSES.md](PROJECT-LENSES.md).
2. **UI Fidelity** when full **and** (new/restyled chrome **or** a design pin
   exists). Packet: pin@version or checklist-only waiver, UI contract subset,
   optional `DESIGN.md`, screenshot and/or checklist. Missing pin without
   waiver, or no evidence while claiming fidelity, **blocks** `Pass`.
   Otherwise `ui-fidelity: n/a`.
3. After candidates: **must try** `Verifier`. Keep findings at confidence
   `>=80`. Incomplete surface (including quiet path / log-unsafe) and
   in-scope UI Fidelity fail / missing evidence **block** `Pass`.

Matt step 4 (two parallel axes) applies to **full**. Light uses the single
Slice Reviewer instead.

**Verifier briefs (both weights):** paste each candidate with file:line and
evidence. When Reviewers filed none, write `none`. The brief is candidates +
fixed point — not a verdict, and not a pre-waived evidence bar.

Soft fail only after an attempt (or when no subagent runtime exists). Never
abort because pack roles are undefined.

Parent solo-reviews a non-empty diff while a runtime exists, without at least
one Reviewer (or host-general) attempt → process-bug. Do not report a clean
`Pass` as independent review.

### Default scope and auto-fix

- If no fixed point is given, review local staged + unstaged (`git diff --cached`,
  `git diff`) and status; for a branch, use three-dot against the named base.
- Standalone review is **report-only**. Auto-fix only when the user authorized
  fixes or `/implement` supplied an already-authorized code scope; preserve
  **how not what**; prefer small Ponytail/Standards fixes. Hard-try `Executor`
  for authorized fixes ([DISPATCH.md](DISPATCH.md)). Never auto-fix on public
  PR audits without explicit ask.
- This skill never closes a ticket. When loaded from `/implement`, return
  `Pass` / `Changes Required` / `Needs User Decision`.
- **Spec vs product doc:** unauthorized product-doc partial/missing (no accepted
  `相对 PRD` delta) → verdict cannot be `Pass`; use `Changes Required` or
  `Needs User Decision`. Do not bury under “known non-blocking / grill AC ok.”
- **UI Fidelity:** when that axis is in scope, verdict cannot be `Pass`
  without pin+evidence or checklist-only waiver + checklist evidence. Parent
  prose alone is invalid.
- Final report **must** include **`review-weight`**: `light` | `full`,
  **`agents used`** (Reviewer / Verifier / host-general / parent-fallback per
  worker), and **incomplete-surface**: `clean` | findings | `n/a` (docs-only),
  and **observability** when the diff touches applicable paths. When a product
  doc was in evidence, also state **prd-alignment**: `aligned` |
  `authorized-deltas` | `unauthorized-partial` (blocks Pass). When UI Fidelity
  ran, also state **ui-fidelity**: `pass` | `fail` | `blocked-no-pin`; on light
  or non-UI, `n/a`. If review used **parent-fallback** for a required worker,
  state **confidence: degraded** and do not imply independent multi-agent
  review.
