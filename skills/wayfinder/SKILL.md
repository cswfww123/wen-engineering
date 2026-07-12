---
name: wayfinder
description: Clear foggy multi-session coding work into a discovery map; resolve one ticket until an honest spec is writable.
disable-model-invocation: true
---

# Wayfinder

Find a route to a named coding destination when the route is too foggy for an
honest `/to-spec` and too large for one session. The map indexes decisions;
discovery tickets own the detail. Wayfinding **finds the way** — it does not
charge at the destination or ship production code.

**LIGHT L4:** product intent already good enough; technical multi-session fog
remains. Prefer `/grill-with-docs` for same-session sharpening; settled work →
`/to-spec`. Mild coding-adjacent intent gap → `/product-fog`. **HEAVY** fuzzy
product need → full PM first, not this map.

Requires Wayfinder operations from `/setup-project-harness`: map and ticket
storage, parent, blocking, discovery frontier, claim, resolution, and closure.
Read `docs/agents/issue-tracker.md` and `docs/boundaries.md` first.

Choose one mode:

- no map supplied: **Chart**
- map path, URL, or identifier supplied: **Resolve**

Resolve at most one discovery ticket per session. Charting never also resolves.

When fog vs ticket, scope cuts, or naming is unclear, load [FOG.md](FOG.md).
Load [TEMPLATES.md](TEMPLATES.md) when charting or graduating tickets.

## Operating Rules

- **Plan, don't implement.** Tickets resolve decisions. Map done when nothing
  material remains before `/to-spec`. Urge to "just build" → hand off, not expand.
- **Destination fixes scope.** Name it first: honest spec, locked architecture/
  data decision, or migration readiness — not a merged feature.
- **Fog or ticket?** Precise question → ticket (even if blocked). Dim → `Not yet
  specified`. Do not pre-slice fog. Detail: [FOG.md](FOG.md).
- **Map is an index.** Open tickets via tracker query. `Decisions so far` =
  named links + one-line gists. Refer by **title/name**, never bare `#42`.
- **One answer, one place.** Resolution comment holds detail; map never restates it.
- **HITL means human.** Grilling/prototype never answer for the user. AFK
  research/task may run alone inside the ticket bound.
- **Never invent.** No fabricated market bets, user value, or Expected after
  rejection — only user decisions and repo evidence.
- **Never implement the destination.** No production, manifest, deployment, or
  behavior-changing repo mutation. Disposable `/prototype` only when authorized.

## Disciplines

| Discipline | Mode | Use when |
| --- | --- | --- |
| `research` | AFK | Primary sources outside the tree |
| `prototype` | HITL | Disposable artifact for shape/flow/seam reaction |
| `grilling` | HITL | User-owned product, scope, or trade-off (default) |
| `task` | AFK or HITL | Prerequisite that unblocks a **decision**, not destination delivery |

## Chart

1. **Name the destination** with the user. If it is still fuzzy, run a short
   `/grilling` and `/domain-modeling` pass until destination and out-of-scope
   boundary are stable. Destination shapes every later ticket.
2. If fog vs ticket or scope cuts are unclear, load [FOG.md](FOG.md). **Explore
   breadth-first** across the coding surface: problem boundary, existing seams,
   data/auth ownership, integration contracts, migration risk, testability, and
   failure modes. Separate:
   - precise questions → candidate discovery tickets
   - in-scope but imprecise → `Not yet specified`
   - beyond destination → `Out of scope`
3. If no multi-session fog remains, **stop without tracker state**. Report that
   the work can proceed to `/to-spec` or `/implement`.
4. Load [TEMPLATES.md](TEMPLATES.md). Publish one non-runnable map with
   destination, notes, unresolved fog, and out-of-scope boundary.
5. Create only sharp questions as child discovery tickets. Each ticket must have
   a `Resolution Signal`. Create identities first, then wire genuine blocking
   edges. Prefer the smallest set that unblocks an honest spec.
6. Query and report the discovery frontier, then stop.

## Resolve

1. Load the map's low-resolution body, **claim the map**, and re-read ownership.
   The map claim serializes `Decisions so far`. If the adapter cannot
   distinguish workers, resolve that map serially.
2. Query the map's discovery frontier. If empty: terminal closeout when no fog
   remains, else release the map claim, report remaining fog, and stop.
   Otherwise take the named ticket or the first frontier ticket, **claim it**,
   re-read ownership. Zoom into full bodies only when needed.
3. Resolve exactly that ticket:
   - `research` / AFK → load `/research`
   - `prototype` / HITL → load `/prototype` and capture the user's reaction
   - `grilling` / HITL → one evidence-backed question at a time (repo first)
   - `task` → only the ticket-authorized read-only inspection or disposable
     evidence setup; never destination delivery
4. Gate on `Resolution Signal`. If evidence or user reaction is insufficient:
   record partial evidence, keep the ticket open, release child and map claims,
   report the blocker, stop. If sufficient: one resolution comment, close the
   ticket, append one named context pointer to `Decisions so far`.
5. Graduate newly precise fog into tickets (identities before edges); remove
   each graduated item from `Not yet specified`. Close mis-scoped tickets and
   move them to `Out of scope` with reason — they never enter `Decisions so far`.
   Unclear graduation rules → [FOG.md](FOG.md).
6. Recompute the discovery frontier. If it and `Not yet specified` are empty:
   record terminal evidence, set `Status: resolved`, close the map. Read back
   every map/graph mutation, release the map claim, report state, stop.

`/research` and `/prototype` return evidence only. Wayfinder owns claims,
relationships, comments, closure, and map updates.

## Completion

Wayfinding ends when no unresolved decision blocks the destination and no
in-scope fog remains. Read back the resolved map. Recommend explicit `/to-spec`
(or `/implement` only if the cleared path is one-context). Destination
implementation is always outside the map.
