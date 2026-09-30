# Grill-first entry: requirements default into /grill-code, agent-owned routing

Status: accepted

Supersedes in part:

- ADR 0004 §3's entry order ("settled multi-slice work -> `/to-spec`"):
  requirements now default into G `/grill-code`; L2 becomes the usual
  post-grill hop (direct entry survives as the zero-pole exception)
- ADR 0007 decision 2's door rule ("Named multi-slice product docs route to
  L2"): grill residual-only becomes a **mode lock** inside the entry, not an
  entry lock. ADR 0007's gates 3–6 (Inventory, Covers, prd-walk, 按原文) are
  unchanged.

## Context

Real sessions exposed three defects in the settled-package door model:

1. **The requirement×codebase collision sweep had no owner.** The method (map
   tables, call sites, tests, contract/seal tests, management surfaces) lived
   in `/grill-code`'s "Facts first" defaults — but that skill was door-locked
   for PRD packages. The routed-to skill (`/to-spec`) held only "explore the
   repo" plus a clause-level Inventory that catches PRD-internal contradictions
   and unmapped terms, not environment collisions (sealed contract tests,
   half-built bases, missing management CRUD). Sessions improvised the sweep
   off-book as a chat "Step 0".
2. **The HITL loop had no arrow.** `/to-spec` fail-closes on HITL rows but its
   contract forbids interviewing; `/grill-code` could close them but only
   "after `/to-spec`". Each skill's entry text bounced the
   PRD-with-unknown-conflicts case, so no single documented door admitted it.
3. **Doorplate and door rule disagreed.** grill-code's public description
   advertised exactly the needed intake ("interview against a codebase — wire
   alignment, PRD deltas") while its body refused PRD packages. A user routing
   by description hit a locked door: "需求无法从任何入口进".

Human routing is also weaker than agent routing at this pack's scale: the user
cannot remember every skill; the agent reads the router docs.

## Decision

1. **Requirements default into G `/grill-code`.** Incoming work that is not a
   bug (`/diagnosing-bugs`), not clear-AC/one-slice (L1 `/implement`), and not
   fuzzy-product (HEAVY gate) enters `/grill-code` first — PRD packages
   included.
2. **Entry sweep before first frontier (hard gate).** With a PRD package: map
   each requirement family to live write paths, schema, contract/seal tests,
   sibling services, and the management surface that owns its CRUD; post a
   collision table. Zero open poles → hop straight L2 `/to-spec` (or L1).
3. **PRD authority becomes a mode lock.** Inside the grill the frontier
   carries residual poles only (contradictions, unmapped terms, eng seams);
   product-behavior changes must be labeled `相对 PRD` deltas
   (`doc-change` / `eng-read`). The prd-authority §2–5 gates are unchanged and
   the Inventory becomes the backstop: HITL rows surfacing after a grill pass
   trigger **one** residual round on exactly those rows before `accepted`.
4. **Agent owns entry routing; invocation flags unchanged.**
   `docs/invocation.md` gains an entry-classification clause: the agent
   classifies the request per lifecycle and enters the matching flow by
   loading its `SKILL.md`; slash commands remain manual overrides. No
   `disable-model-invocation` flag flips. Mid-flow hops still wait for the
   user's order (grill close gate → `/implement` | 「开干」).

## Consequences

- A fresh PRD with unknown codebase conflicts has one door: `/grill-code`
  (sweep → residual frontier → labeled deltas → `/to-spec`). No improvised
  Step 0.
- `/to-spec` is repositioned as the post-grill synthesis hop; direct entry
  stays valid, with the PRD Inventory as the fail-closed backstop.
- The full-product re-grill prohibition is preserved as a mode rule inside G
  rather than an entry rule — PRD authority is not weakened, only re-sequenced.
- ADR 0004 §3's entry list and ADR 0007's door wording are superseded; their
  artifact and gate decisions stand.
- Historical ADR language remains intact; this ADR records the changed
  decision.
