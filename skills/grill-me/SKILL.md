---
name: grill-me
description: A relentless interview to sharpen a plan or design.
disable-model-invocation: true
---

Run a `/grilling` session.

For engineering work, also run `/domain-modeling` so glossary terms and ADRs
update as decisions crystallize (shared language, not a separate phase).

Routing / anti-invention when in a coding repo: `docs/lifecycle.md` (LIGHT G;
HEAVY product fog stays in PM, not this skill).

## Batch / diff mode (default for tables)

When the open question is a **mapping table, closed set, or multi-row checklist**
(common under `/wayfinder`):

1. Load repo facts first; post a **recommended full answer** (table or set).
2. Ask the human to accept or reply with **diffs only** (row id → change / delete).
3. Do not grind one row per turn unless the human rejects the batch form.

One-line human replies such as `按推荐` or `按推荐，除第 2 行→无效` are success.

## Keep it short

- One decision surface at a time (a table counts as one surface in batch mode).
- Do not re-read `/grilling` or this file every turn after the first load.
- When invoked from Wayfinder, write the decision onto the ticket on close; do
  not demand the human re-paste Destination or prior DECs.
