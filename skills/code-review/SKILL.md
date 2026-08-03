---
name: code-review
description: Review the changes since a fixed point (commit, branch, tag, or merge-base) along two axes — Standards (does the code follow this repo's documented coding standards?) and Spec (does the code match what the originating issue/PRD asked for?). Runs both reviews in parallel sub-agents and reports them side by side. Use when the user wants to review a branch, a PR, work-in-progress changes, or asks to "review since X".
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

End with a one-line summary: total findings per axis, the worst issue _within each axis_ (if any), **incomplete-surface**: `clean` | findings | `n/a`, and **ui-fidelity** when UI changed. Don't pick a single winner across axes — that's the reranking the separation exists to prevent.

## Why two axes

A change can pass one axis and fail the other:

- Code that follows every standard but implements the wrong thing → **Standards pass, Spec fail.**
- Code that does exactly what the issue asked but breaks the project's conventions → **Spec pass, Standards fail.**

Reporting them separately stops one axis from masking the other.

## WEN process (required)

Keep Matt's two axes (Standards + Spec) and process steps 1–5 above. This section
binds **how** subagents are used when the host has a spawn runtime.

### Hard-try Reviewer / Verifier

**Before** step 5 Aggregate, load [DISPATCH.md](DISPATCH.md) and:

1. **Must try** parallel subagents for **Standards** and **Spec** (Matt step 4).
   Prefer pack role `Reviewer` per axis; else host `general-purpose` / multi-step
   worker with Matt's prompts **or** [AGENT-BRIEFS.md](AGENT-BRIEFS.md).
2. **Correctness is required** for any diff that touches production-reachable
   code (not pure docs/comments/config-only renames). Incomplete production
   surface is a **blocking** Correctness class — see
   [INCOMPLETE-SURFACE.md](INCOMPLETE-SURFACE.md). That class includes **quiet
   critical path** and **log-unsafe** logging. Correctness **must** run the
   forensic log-chain checklist on applicable paths and require **fail-open**
   logging (log failure never fails business) —
   [FORENSIC-OBSERVABILITY.md](FORENSIC-OBSERVABILITY.md). Optional extra axes
   when warranted: **Performance**, **Security**, **Ponytail** — same hard-try;
   report each under its own heading (no cross-axis renorming). Detail:
   [REVIEW-AXES.md](REVIEW-AXES.md), [PROJECT-LENSES.md](PROJECT-LENSES.md).
3. **UI Fidelity is required** when the diff changes user-visible UI (frontend
   or full-stack UI subset). Hard-try a Reviewer on the **UI Fidelity** axis
   ([REVIEW-AXES.md](REVIEW-AXES.md), [AGENT-BRIEFS.md](AGENT-BRIEFS.md)). Packet
   must include design pin path@version (or checklist-only waiver), UI contract
   subset, optional `DESIGN.md`, and fidelity evidence (screenshot path(s)
   and/or checklist vs pin). Missing pin without waiver, or no evidence while
   claiming fidelity, **blocks** `Pass`. Backend-only / non-UI →
   `ui-fidelity: n/a`.
4. After candidates: **must try** pack `Verifier` (or parent Verification
   Reviewer). Keep findings only at confidence `>=80`. Incomplete surface
   (including quiet path / log-unsafe) that survives verification **blocks**
   `Pass`. In-scope UI Fidelity fail / missing evidence **blocks** `Pass`.
5. Soft fail only after an attempt (or when no subagent runtime exists). Never
   abort because pack roles are undefined.
6. **Forbidden:** parent solo-reviews a non-empty diff while a subagent runtime
   exists without at least one Reviewer (or host-general) attempt. Skipping
   spawn without an attempt is a **process-bug**; do not report a clean `Pass`
   as if independent review ran.

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
- **UI Fidelity:** when in scope, verdict cannot be `Pass` without pin+evidence
  or checklist-only waiver + checklist evidence. Parent prose alone is invalid.
- Final report **must** include **`agents used`** (Reviewer / Verifier /
  host-general / parent-fallback per axis) and an explicit
  **incomplete-surface** line: `clean` | findings | `n/a` (docs-only), and
  **observability** when the diff touches applicable paths. When a product doc
  was in evidence, also state **prd-alignment**: `aligned` | `authorized-deltas`
  | `unauthorized-partial` (blocks Pass). When UI changed, also state
  **ui-fidelity**: `pass` | `fail` | `blocked-no-pin` | `n/a`. If review used
  **parent-fallback** for a required axis, state **confidence: degraded** and
  do not imply independent multi-agent review.
