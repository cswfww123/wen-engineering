# Product-doc authority gates on LIGHT L2

Status: accepted

## Context

A detailed in-repo product requirements doc is already honest enough to code
against (LIGHT L2: `/to-spec` → `/to-tickets` → `/implement`). The pack already
ranked that doc above grill chat. In practice, agents still:

- opened a full product grill and accepted unlabeled or loosely labeled MVP
  shrinks (`相对 PRD` rows that later the user revoked with “按原文”)
- synthesized REQs without a clause-level inventory of 验收 points and 场景 rows
- treated ticket `Supports` and “main path demoable” as coverage
- marked tickets `complete` while the body still listed residuals
- answered “已按 PRD 实现” against the **eng spec / grill AC**, not the original
  product doc

The failure is not “PRD too vague.” It is missing **hard gates** on coverage and
completion.

## Decision

1. Canonical protocol lives in [docs/prd-authority.md](../prd-authority.md).
2. Named multi-slice product docs route to L2. Grill is residual-only; every
   product-behavior change is a labeled `相对 PRD` delta with class
   `doc-change` or `eng-read`.
3. `/to-spec` cannot `accepted` a PRD-sourced spec without a **PRD Inventory**
   (source clause → surface → REQ | HITL | OUT). Dual surfaces are two rows.
4. `/to-tickets` coverage is inventory `SRC` in some ticket **`Covers`**.
   `Supports` does not count. Honest `complete` forbids leftover 残差 in the
   ticket body.
5. Closing the last ticket of a PRD-sourced spec, or answering “已按 PRD 实现”,
   requires a **prd-walk**: `/alignment-review` against the **original product
   doc**. Any `缺` blocks delivered / “已按 PRD 实现.”
6. User “按原文” revokes listed delta ids via L3 `/product-fog` only — not a
   full re-grill, and not a pack-failure story.

No new user-invoked slash command. `prd-walk` is a required mode of the
existing `/alignment-review` skill.

## Consequences

- L2 gains two fail-closed artifacts: Inventory (publish time) and prd-walk
  (package close). Default L2 still does **not** run alignment-review after
  every ticket publish.
- Grill remains first-class for residual poles. It must not re-author a settled
  product doc.
- Historical specs without an Inventory are not rewritten. New PRD-sourced
  work and reopen-via-按原文 must follow the gates.
