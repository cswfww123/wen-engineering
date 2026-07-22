---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview me about this until we share understanding. Treat open work as a **decision tree**: each settled choice unlocks the decisions that hang off it. For every question or batch surface, give your **recommended answer** first.

## Rounds and the frontier

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled — questions you can ask *now* without guessing answers you have not heard yet.

1. **Map dependencies lightly** (in your head or a short outline). Do not dump the whole tree on me unless I ask.
2. **Each round posts the whole frontier** as one batch surface (table or numbered set), not one micro-Q.
3. I answer (or `按推荐` / diffs). **Recompute the frontier** from those answers; ask the next round.
4. A question that still depends on another open answer belongs to a **later** round — never this one.
5. The session is done when the frontier is **empty** (every needed branch visited, nothing silently assumed) and any parent skill's close/confirm gate is satisfied.

## Surfaces, not micro-Qs

- Default unit is a **decision surface** (one product/architecture cut), not every implementation detail.
- **Batch / diff (default for engineering & tables):** load repo facts → post a **recommended full answer** for this round's frontier (table or closed set, usually **5–8 rows**, hard cap **10** without my ok) → I reply `按推荐` or **diffs only** (row id → change/delete). Do **not** grind one row per turn unless I reject the batch form.
- One-at-a-time single questions only when the surface is a **binary fork with deep blast radius**, or I said “继续深烤 / one by one”.
- >10 open rows or serial micro-questions need my explicit “继续深烤”. Prefer parking implementation detail for blueprint / tdd / executor after close.

One-line replies such as `按推荐` or `按推荐，除第 2 行→无效` are success.

## Facts vs decisions (non-blocking)

- Finding **facts** is your job, never mine. If a frontier question needs a fact from the environment (code, schema, tests, ADRs, tools), look it up — prefer a **sub-agent / background explore** when the lookup is non-trivial.
- **Do not block the whole round on fact-finding.** A running exploration is an unsettled prerequisite for *only* the questions that depend on it: ask the rest of the frontier now; hold back only the dependent rows until the sub-agent reports.
- The **decisions** are mine — put each surface to me and wait.
- Do **not** implement until I confirm shared understanding. Parent skills may require a durable archive only for **cross-session handoff** — same-session work needs no decision file.
- **Conflicting live sources** (enum vs write path vs SQL/report vs sibling service) are **decisions**, not auto-resolved “code wins.” Show a short source→value table and recommend; wait for `按推荐` / diff. Never close an open pole with “无需再问.”
- **Bare `/implement` while frontier open:** recap open recommended rows and wait for `按推荐` / diffs. If I insist without answering, implement only settled rows; do not invent answers for open A/B or alignment targets.

## Anti rubber-stamp

If I accept the full recommended table **unchanged 2 times in a row** (or keep saying only `按推荐` across surfaces), do **not** open more low-risk rows. Next message: **2–3 high-risk decisions only** (visibility/privacy, transaction boundaries, half-finished surfaces like backend-only SSE, irreversible schema, shared-branch blast radius, **money/stats 口径**, **historical backfill**, **dual write paths across services**). Force an explicit choice on those; everything else stays on the last recommended table unless I diff it.

## Keep it short

- One frontier surface per turn (a batch table = one round).
- Do not re-read this file every turn after first load.
