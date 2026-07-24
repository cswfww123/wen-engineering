# Design / plan review briefs (reuse Reviewer + Verifier)

**No new agent type.** After diagnosis (or any multi-slice fix proposal) and
**before** `/implement` or `/to-spec`, parent may dispatch pack `Reviewer` with a
**design packet** instead of a code diff. Optional `Verifier` merges candidates.

Use when:

- `/diagnosing-bugs` returns a root cause **and** a multi-step fix architecture
- an agent proposes P0/P1/P2 (or similar) beyond a single bounded change
- the user wants an independent check for over-engineering, missing alternatives,
  or diagnosis→fix mismatch

Do **not** use this for a fixed code delta — that remains
`skills/code-review/AGENT-BRIEFS.md` + `/code-review`.

## Anti-rubber-stamp rules

1. **Different model when the host allows.** Prefer a Reviewer model **other than**
   the session that authored the proposal. Same-model re-read is fallback only.
2. **Do not spawn Reviewer in the same generative turn that wrote the plan** as
   a self-approval. Parent freezes the packet, then spawns.
3. **Read-only.** No production edits, no tracker mutation, no “while we’re here”
   implement.
4. **Parent owns HITL.** Reviewer may recommend; only the user pins MVP scope
   (`/grill-me` when decisions remain open).

## Design packet (parent assembles)

Minimum fixed point — paste into every Reviewer/Verifier brief:

| Field | Content |
| --- | --- |
| Symptom | User-visible failure + time window |
| Root cause (1–2 sentences) | Mechanism only, not the wish-list architecture |
| Evidence | Red-capable command/probe + key output; control path if any |
| Code path | Entry → fail site (files/symbols) |
| Proposal under review | Full plan text (P0/P1/P2 or equivalent) — **not** pre-approved |
| Constraints | e.g. minimal shippable fix first; no new infra unless proven needed |
| Explicit out | What the proposal must **not** silently expand into |

Root cause and proposal are **separate**: a hard root cause does not bless a
large design.

## Spawn shape

```text
Parent freezes design packet
  ├─ Reviewer × root-cause-fit   (prefer other model)
  ├─ Reviewer × architecture     (prefer other model; parallel OK)
  └─ optional Verifier           (merge candidates → one verdict)
User HITL /grill-me if Ask User or scope still open
  → bounded-fix → /implement
  → multi-slice → /to-spec → (/alignment-review if risky) → /to-tickets → /implement
```

Hard try `Reviewer` / `Verifier` per `orchestration.md`; soft-fail to parent with
the same brief text.

---

## Axis: root-cause-fit

You are pack **Reviewer**, axis **root-cause-fit**. Read-only. Do not edit code.

Read the **design packet** first (symptom, root cause, evidence, code path), then
the proposal. Stay on whether the proposed work **actually closes the diagnosed
failure**.

Check:

- Does P0 (or the smallest claimed fix) map 1:1 to the evidenced root cause?
- Would the red probe/test go green if only that minimal fix shipped?
- Are failure messages / retry / classification paths aligned with the exception
  shape in evidence (not only the happy-path unit tests)?
- Did the proposal smuggle unrelated improvements as “required for the bug”?
- Is anything labeled must-do that has **no** evidence in the packet?

Return under 400 words:

- **verdict lean:** `aligned` | `partial` | `misaligned` (for this axis only)
- findings: claim in proposal → contradicting or missing evidence
- **must / should / defer** re-cut of proposal items for *this bug only*
- at least one **smaller fix** that still addresses the root cause (or state why
  impossible)
- fixability-style tags: `report-only` | `needs-user-decision` (no auto-fix)
- likely false positives discarded (brief)

Do **not** praise the plan. Do **not** invent product requirements. If evidence
is thin, say what cannot be verified.

---

## Axis: architecture

You are pack **Reviewer**, axis **architecture**. Read-only. Do not edit code.

Assume root cause may be correct; challenge **shape, scope, and sequencing** of
the proposal against a real codebase (trace seams if packet paths exist).

Check:

- Over-engineering: new services, Redis/cluster quotas, adaptive controllers,
  multi-task priority fabrics — required **now** or YAGNI?
- Missing alternatives: in-process limits, fewer API calls, cache, row retry,
  job mutual exclusion — smaller seams that fit existing modules?
- Coupling: does the design invent dual sources of truth or quiet critical paths?
- Sequencing: what ships first for production safety vs speed ambitions?
- Repo fit: ownership, existing rate-limit/retry/import patterns — extend vs replace?

Return under 400 words:

- **verdict lean:** `sound` | `trim` | `rework` (for this axis only)
- findings with smallest correction (prefer delete/defer over new platforms)
- alternative design (1–2 sentences) that is **smaller** and still credible
- **must / should / defer** for non-P0 items
- risks if the large design ships first
- `needs-user-decision` items the parent must not invent

Use deep-module language only if it clarifies a seam (`skills/codebase-design`
vocabulary optional). No code edits. No rubber-stamp Pass on a wishlist.

---

## Optional: Verifier (design packet)

You are pack **Verifier** for a **design/plan** review (not a code diff).

Input: design packet + candidate findings from root-cause-fit and architecture
Reviewers (or parent-run briefs).

Re-check evidence. Drop speculation, praise, and “nice to have” dressed as
blockers. Prefer fewer true positives.

Return **exactly one** verdict:

| Verdict | Meaning |
| --- | --- |
| `Pass` | Proposal (or a stated minimal subset) is fit to enter `/implement` or `/to-spec` **as scoped** |
| `Changes Required` | Packet or proposal must be rewritten before coding (misaligned or dangerous scope) |
| `Needs User Decision` | Engineering residual open; parent must HITL /grill-me before route |

Also return:

- surviving findings only (with why not FP)
- **recommended scope for next step:** `implement-minimal` | `spec-and-slice` | `blocked`
- rejected groups (brief)
- verification gaps (what you could not check without more repo/runtime access)

`Pass` does **not** authorize production edits — only that the plan is coherent
enough for the named next skill. User still authorizes `/implement`.

---

## Parent paste template

```text
Role: Reviewer | axis: root-cause-fit  (or architecture)
Model: prefer different from proposal author
Authority: read-only; no edits; no tracker

## Design packet
- Symptom:
- Root cause:
- Evidence (command + RED output):
- Code path:
- Constraints:
- Explicit out:

## Proposal under review
<paste full plan>

## Output
Follow docs/agents/DESIGN-REVIEW-BRIEF.md for this axis.
```

After axes return, optional:

```text
Role: Verifier | design-plan gate
Authority: read-only
Design packet: <same fixed point>
Candidates: <Reviewer findings>
Follow DESIGN-REVIEW-BRIEF.md Verifier section.
```
