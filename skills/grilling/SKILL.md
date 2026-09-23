---
name: grilling
description: Interview loop for /grill-me and /grill-code. Use when stress-testing a plan or idea, or when another skill runs a grill.
---

Interview the user relentlessly until you reach a shared understanding. Map this as a **design tree**: every decision branches into the decisions that hang off it.

Work the tree in **rounds**. The **frontier** is every decision whose prerequisites are already settled — the questions you can ask _now_ without guessing at answers you haven't heard yet. Ask the whole frontier in one round: number each question and give your recommended answer. Then wait for the user's answers before the next round.

Each question should be formatted like so:

```
❓ **Q1** - **<question title>**: <question body, might be multiple paragraphs, including multiple choices>

➡️ <your recommended answer>
```

When several decisions share settled prerequisites, use a **frontier table**: one row per open decision, recommended answer in its own column; the user replies `按推荐` or **diffs only** (row id → change/delete). Prefer **5–8** rows per round (hard cap **10** without explicit “继续深烤”). One-at-a-time single questions only for a binary fork with deep blast radius, or when the user said “one by one”. `/grill-code` adds the coding rules (conflict facts, PRD deltas, implement handoff); this loop does not.

Each round the user answers reshapes the tree — settled decisions push the frontier outward and unblock questions that depended on them. Recompute the frontier and ask the next round. A question whose answer depends on another question still open in this round belongs to a _later_ round, not this one.

Finding _facts_ is your job, never the user's. When a frontier question needs a fact from the environment (filesystem, tools, and — only on a `/grill-code` session — code, schema, tests, ADRs), dispatch a sub-agent to find it — don't ask the user for anything you could look up yourself. Don't block on it: a running exploration is an unsettled prerequisite, so only the questions downstream of it wait for the sub-agent to report — ask the rest of the frontier now. The _decisions_ are the user's — put each to them and wait.

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding. Same-session work needs no decision file. Parents own anything durable: `/grill-me` stays in chat; `/grill-code` archives only for cross-session handoff; wayfinder writes the ticket.

## Which parent

| Session | Parent | This loop does not |
| --- | --- | --- |
| Plan, idea, decision, no repo | `/grill-me` | Scan code, PRD deltas, offer `/implement` |
| Codebase, wire, schema, residual eng seam | `/grill-code` | Re-author settled product behavior |

Coding-only rules live in `/grill-code`, not here: conflict-fact tables, `相对 PRD` labels, MVP boundary, anti rubber-stamp, implement handoff.

### Keep it short

- One frontier surface per turn (a batch table = one round).
- Do not re-read this file every turn after first load.
