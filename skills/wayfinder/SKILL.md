---
name: wayfinder
description: Clear multi-session technical coding fog into a discovery map until an honest engineering spec is writable.
disable-model-invocation: true
---

# Wayfinder

**Advanced, rare path.** Find a route to a named **engineering** destination
when product intent is already settled (or the work is pure engineering), the
technical route is too foggy for an honest `/to-spec`, and the work is too large
for one session. The map indexes technical decisions; discovery tickets own the
detail. Wayfinding **finds the way** — it does not invent product value or ship
production code.

Default multi-session path remains `/to-spec` → `/to-tickets`. Prefer
`/grill-with-docs` for same-session technical sharpening. Read
`docs/boundaries.md` and `docs/agents/issue-tracker.md` first.

Requires Wayfinder operations from `/setup-project-harness`: map and ticket
storage, parent, blocking, discovery frontier, claim, resolution, and closure.

Choose one mode:

- no map supplied: **Chart**
- map path, URL, or identifier supplied: **Resolve**

Resolve at most one discovery ticket per session. Charting never also resolves.

## Admission Gate

Before charting or resolving, confirm **all** of:

1. **Not product fog.** Uncertainty is not primarily about worth-doing, target
   user, market, pricing, stakeholder inner need, or unvalidated product bets.
   If it is, stop and recommend `/pm-intake` (PM workspace). Do not create a map.
2. **Product settled or pure engineering.** Build/Bet-level intent, an explicit
   engineering mandate, or behavior-preserving technical work (migration,
   reliability, performance, platform) with a named acceptance boundary.
3. **Technical multi-session fog.** Cannot write an honest engineering
   `/to-spec` in one session; `/grill-with-docs` is insufficient.

If admission fails, report the gap and the correct route; create no tracker state.

## Operating Rules

- **Plan, don't implement.** Tickets resolve technical decisions. The map is
  done when nothing material remains before `/to-spec`.
- **Destination fixes scope.** Typical destinations: honest engineering spec,
  locked architecture/data decision, migration readiness — not a merged feature
  and not a product PRD.
- **Fog or ticket?** Ticket only when the technical question is already precise.
  Keep imprecise in-scope work in `Not yet specified`. Do not pre-slice fog.
- **Map is an index.** Open tickets live in the tracker query. `Decisions so
  far` holds only named links plus one-line gists. Refer by **title/name**.
- **One answer, one place.** Resolution comment is the detail source.
- **HITL means human.** Grilling/prototype never answer for the user.
- **Never implement the destination.** No production, manifest, deployment, or
  behavior-changing repo mutation. Disposable `/prototype` only when authorized.
- **Engineering questions only.** Contracts, seams, ownership, failure modes,
  migrations, test seams — not customer interviews or market validation.

## Disciplines

| Discipline | Mode | Use when |
| --- | --- | --- |
| `research` | AFK | Primary sources outside the tree (docs, APIs, standards, upstream code) |
| `prototype` | HITL | Disposable artifact for technical shape/flow/seam reaction |
| `grilling` | HITL | User-owned **engineering** trade-off (default for tech decisions) |
| `task` | AFK or HITL | Prerequisite that unblocks a **decision**, not destination delivery |

Load [TEMPLATES.md](TEMPLATES.md) when charting or graduating tickets.

## Chart

1. Re-check admission. Name the **engineering** destination; if still fuzzy,
   short `/grilling` + `/domain-modeling` on technical scope only.
2. Explore breadth-first on the coding surface: seams, data/auth ownership,
   contracts, migration risk, testability, failure modes. Separate precise
   tickets, imprecise fog, and out-of-scope (including any product questions —
   send those to PM, do not ticket them here).
3. If no multi-session technical fog remains, **stop without tracker state**.
   Report `/to-spec` or `/implement`.
4. Publish one non-runnable map; create only sharp tickets with `Resolution
   Signal`; identities before blocking edges.
5. Query and report the discovery frontier, then stop.

## Resolve

1. Load the map, **claim the map**, re-read ownership (serializes the index).
2. Query discovery frontier. Empty: terminal closeout or release + report fog.
   Else claim the named or first frontier ticket; re-read ownership.
3. Resolve exactly that ticket via `/research`, `/prototype` + user reaction,
   technical grilling (repo first), or ticket-authorized task only.
4. Gate on `Resolution Signal`. Insufficient: partial evidence, keep open,
   release claims, stop. Sufficient: resolution comment, close, named pointer
   on `Decisions so far`.
5. Graduate technical fog; close mis-scoped/product tickets out of scope with
   reason (never as route decisions). If product fog appears mid-map, leave a
   pointer and recommend PM — do not "resolve" it as engineering.
6. When frontier and `Not yet specified` are empty: `Status: resolved`, close
   map, read back mutations, release claim, stop.

`/research` and `/prototype` return evidence only. Wayfinder owns tracker state.

## Completion

Recommend explicit `/to-spec` (or `/implement` if one-context). Destination
implementation is always outside the map.
