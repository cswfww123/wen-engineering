---
name: grilling
description: Grill the user relentlessly about a plan, decision, or idea. Use when the user wants to stress-test their thinking, or uses any 'grill' trigger phrases.
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled — the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Each question should be formatted like so:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

For engineering batch surfaces (recommended tables), the same idea applies as a **frontier table**: one row per open decision, recommended answer in its own column; the user replies `按推荐` or **diffs only** (row id → change/delete). Prefer **5–8** rows per round (hard cap **10** without explicit “继续深烤”). One-at-a-time single questions only for a binary fork with deep blast radius, or when the user said “one by one”.

Each round the user answers reshapes the tree — settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, code, schema, tests, ADRs), dispatch a sub-agent to find it — don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report — ask the rest of the frontier now. The _decisions_ are the user's — put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding. Parent skills may require a durable archive only for **cross-session handoff** — same-session work needs no decision file.

## WEN pack deltas

### Conflicting live sources & product docs

- **Conflicting live sources** (enum vs write path vs SQL/report vs sibling service) are **decisions**, not auto-resolved “code wins.” Show a short source→value table and recommend; wait for `按推荐` / diff. Never close an open pole with “无需再问.”
- **Active product requirements / PRD:** settled product-doc behavior is **already decided** — do not re-grill it as open product poles. Only residual gaps and eng seams go on the frontier. Any recommendation that narrows/defers/changes PRD behavior must be labeled `相对 PRD: …` before the user can accept it; unlabeled PRD overrides are invalid even if they say `按推荐`.
- **Bare `/implement` while frontier open:** recap open recommended rows and wait for `按推荐` / diffs. If they insist without answering, implement only settled rows; do not invent answers for open A/B or alignment targets.

### Anti rubber-stamp

If the user accepts the full recommended table **unchanged 2 times in a row** (or keeps saying only `按推荐`), do **not** open more low-risk rows. Next message: **2–3 high-risk decisions only** (visibility/privacy, transaction boundaries, half-finished surfaces, irreversible schema, shared-branch blast radius, money/stats 口径, historical backfill, dual write paths). Force an explicit choice on those; everything else stays on the last recommended table unless they diff it.

### Close → next hop (when frontier is empty)

Parent skills (`grill-me`, wayfinder) own durable archives. Before offering build, state **one** next hop — do not default to “spec + prototype”:

| Settled | Next | Avoid |
| --- | --- | --- |
| Behavior AC enough; no UI / pin already exists | `/implement` or L2 tickets | Multi-variant `/prototype` |
| Multi-slice handoff | `/to-spec` → `/to-tickets` | Chat-only package |
| Only appearance still open | `/prototype` then pin | Prototype as production fidelity |
| High-fidelity pin already versioned | implement + UI fidelity gate | Re-opening look variants |

### Keep it short

- One frontier surface per turn (a batch table = one round).
- Do not re-read this file every turn after first load.
