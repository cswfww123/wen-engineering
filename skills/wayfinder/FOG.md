# Fog, Scope, and Names

Mental model for charting and graduating discovery. Load when fog vs ticket is
unclear, scope feels slippery, or narration is becoming a wall of ids.

Runtime (claim, Resolution Signal, Chart/Resolve steps) stays in
[SKILL.md](SKILL.md). Field shapes stay in [TEMPLATES.md](TEMPLATES.md).

Adapted from Matt Pocock's Wayfinder fog model (MIT); WEN keeps production
rails (no destination delivery, map claim, resolution signal) in the runtime.

## Plan the way, don't charge the destination

Wayfinding finds a **route**. Tickets resolve **decisions**. The map is done
when nothing material remains before `/to-spec` (or one-context `/implement`).

The urge to "just build it" is usually the signal that you have reached the edge
of the map — hand off, do not expand the map into delivery. `task` is the only
discipline that *does* something, and only to **unblock a later decision**, never
to ship the destination.

## Refer by name

Every map and ticket has a **title/name**. In narration and in `Decisions so
far`, refer by that name. Wrap a link around the name when useful; never lead
with a bare `#42`, issue number, or slug wall.

Names read at a glance. Ids ride *inside* the name; they do not replace it.

## Map is an index

The map is low-resolution orientation for every session:

| Section | Holds |
| --- | --- |
| Destination | What "done finding the way" looks like (1–2 lines) |
| Notes | Domain, skills to consult, standing preferences |
| Decisions so far | Closed tickets only: named link + one-line gist |
| Not yet specified | In-scope fog not sharp enough to ticket |
| Out of scope | Beyond this destination; closed mis-scoped tickets |

Open tickets live in the **tracker query**, not the map body. A decision lives
in **exactly one place** — the ticket's resolution comment. The map never
restates the full answer.

## Fog of war

The map is deliberately incomplete. Do not chart what you cannot yet see.

Beyond live tickets sits **fog** — decisions you can tell are coming but cannot
pin down yet, because they hang on still-open questions. Resolving a ticket
clears fog ahead of it and may **graduate** newly sharp work into tickets.

**Not yet specified** is the written dim view toward the destination: in scope,
not sharp enough to ticket. Write as loosely or fully as the view allows; it is
also a signpost for collaborators.

### Fog or ticket?

The test is whether you can **state the question precisely now** — not whether
you can **answer** it now.

| Bucket | When |
| --- | --- |
| **Ticket** | Question is already sharp — even if blocked and you cannot act yet |
| **Not yet specified** | You cannot phrase it that sharply. Do **not** pre-slice fog into fake tickets. One fog line may later become several tickets, one, or none |
| **Out of scope** | Work sits past the destination. Scope, not sharpness |

**Not yet specified** excludes: already decided (`Decisions so far`), already a
live ticket, and out of scope.

## Out of scope

Fog only gathers **toward** the destination. The destination fixes scope, so
work beyond it is not fog and does not belong in **Not yet specified**.

Out-of-scope work **never graduates** into the route. It returns only if the
destination is redrawn — as a fresh effort, not a resumption.

Ruling something out of scope is a **scoping act**, not a step on the route.
When a live ticket turns out past the destination:

1. **Close** it (so it leaves the frontier unambiguously)
2. One line in **Out of scope**: gist + why, linking the closed ticket
3. Do **not** put it in `Decisions so far` — a boundary cut is not a route step

## HITL means human

For `grilling` and `prototype`, the agent never stands in for the human. A
grilling agent that answers its own questions has broken the contract. AFK
`research` / `task` may run alone inside the ticket bound.

Never invent market bets, user value, or Expected after rejection — only record
user decisions and repo evidence.

## Graduation checklist

When a resolution clears fog:

1. Can this patch be stated as one precise question with a Resolution Signal?
   → create ticket (identity first, then blocking edges)
2. Still dim? → leave or refine a **Not yet specified** line
3. Past destination? → **Out of scope**, close any mis-scoped ticket
4. Clear the graduated line from **Not yet specified** so it lives only as its
   ticket(s)

Weak tickets to reject: "look into X", "research options", "discuss with team"
without a stated sufficiency bar (see Resolution Signal patterns in
[TEMPLATES.md](TEMPLATES.md)).
