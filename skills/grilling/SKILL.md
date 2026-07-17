---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview me about this until we share understanding. Resolve decision dependencies in order. For every question or batch surface, give your **recommended answer** first.

## Surfaces, not micro-Qs

- Default unit is a **decision surface** (one product/architecture cut), not every implementation detail.
- **Batch / diff (default for engineering & tables):** load repo facts → post a **recommended full answer** (table or closed set, usually **5–8 rows**, hard cap **10** without my ok) → I reply `按推荐` or **diffs only** (row id → change/delete). Do **not** grind one row per turn unless I reject the batch form.
- One-at-a-time single questions only when the surface is a **binary fork with deep blast radius**, or I said “继续深烤 / one by one”.
- >10 open rows or serial micro-questions need my explicit “继续深烤”. Prefer parking implementation detail for blueprint / tdd / executor after close.

One-line replies such as `按推荐` or `按推荐，除第 2 行→无效` are success.

## Facts vs decisions

- If a *fact* is in the environment (code, schema, tests, ADRs), **look it up** — do not ask me.
- The *decisions* are mine — put each surface to me and wait.
- Do **not** implement until I confirm shared understanding (and any archive gate the parent skill requires).

## Anti rubber-stamp

If I accept the full recommended table **unchanged 2 times in a row** (or keep saying only `按推荐` across surfaces), do **not** open more low-risk rows. Next message: **2–3 high-risk decisions only** (visibility/privacy, transaction boundaries, half-finished surfaces like backend-only SSE, irreversible schema, shared-branch blast radius). Force an explicit choice on those; everything else stays on the last recommended table unless I diff it.

## Keep it short

- One surface per turn (a batch table = one surface).
- Do not re-read this file every turn after first load.
