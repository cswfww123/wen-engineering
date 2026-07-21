---
name: wayfinder
description: Plan multi-session engineering fog as a decision-ticket map — short pastes, thin HITL, hand off to /to-spec when the route is clear.
disable-model-invocation: true
---

A loose idea has arrived — too big for one agent session, and wrapped in fog: the way from here to the **destination** isn't visible yet. Wayfinding is about finding that way, not charging at the destination. This skill charts the way as a **shared map** on the repo's issue tracker, then works its **decision tickets** — questions whose resolution is a decision, not slices of a build to execute — one at a time until the route is clear.

The destination varies per effort, and naming it is the first act of charting — it shapes every ticket. It might be a spec to hand off and iterate on, a decision to lock before planning starts, or a change made in place like a data-structure migration. The map is domain-agnostic — engineering work, course content, whatever fits the shape.

## Plan, don't do

Wayfinder is **planning** by default: each ticket resolves a decision, and the map is done when the way is clear — nothing left to decide before someone goes and does the thing. The pull to just do the work is usually the signal you've reached the edge of the map and it's time to hand off. An effort can override this in its **Notes** — carrying execution into the map itself — but absent that, produce decisions, not deliverables.

## Prefer not to open a map

Before Charting, ask whether **one same-session `/grill-me`** (or straight `/to-spec` on settled docs) would clear the fog. Open Wayfinder only when decisions truly need **multiple sessions** or a shared frontier. A thick PRD + a few open trade-offs is usually **G then L2**, not L4.

## Refer by name

Every map and ticket is an issue, so it has a **name** — its title. In everything the human reads — narration, the map's Decisions-so-far — refer to it by that name, never by a bare id, number, or slug. A wall of `#42, #43, #44` is illegible; names read at a glance. The id and URL don't vanish — a name wraps its link — but they ride *inside* the name, never stand in for it.

## The Map

The map is a single issue on this repo's issue tracker, labelled `wayfinder:map` — the canonical artifact. Its tickets are child issues of the map.

The map is an **index**, not a store. It lists the decisions made and points at the tickets that hold their detail; a decision lives in exactly one place — its ticket — so the map never restates it, only gists it and links.

**Where the map, its child tickets, blocking, and frontier queries physically live is tracker-specific.** The issue tracker should have been provided to you — run `/setup-project-harness` if not. Consult the tracker doc's "Wayfinding operations" section for how _this_ repo expresses them. If no tracker has been provided, default to the local-markdown tracker (`.scratch/<slug>/`).

### The map body

The whole map at low resolution, loaded once per session. Open tickets are **not** listed — they are open child issues, found by query.

```markdown
## Destination

<what reaching the end of this map looks like — the spec, decision, or change this effort is finding its way to. One or two lines; every session orients to it before choosing a ticket.>

## Notes

<domain; tracker root; skills; standing preferences — keep short>

## Session handoff

<!-- machine + human: next paste is one line; agent reads this first on Resolve -->

## Decisions so far

- [<closed ticket title>](link) — <one-line gist of the answer>

## Not yet specified

<!-- fog: in-scope, not sharp enough to ticket -->

## Out of scope

<!-- past this destination; never graduates -->
```

Full field shapes: [TEMPLATES.md](TEMPLATES.md). Short human pastes: [CONTINUE.md](CONTINUE.md).

### Tickets

Each ticket is a **child issue** of the map; the tracker's issue id is its identity. Its body is the question, sized to one 100K token agent session:

```markdown
## Question

<the decision or investigation this ticket resolves>
```

Each ticket carries a `wayfinder:<type>` label — one of `research`, `prototype`, `grilling`, `task` (see [Ticket Types](#ticket-types)).

A session **claims** a ticket by assigning it to the dev driving the map, **first**, before any work, so concurrent sessions skip it. That assignee _is_ the claim: an open, unassigned ticket is unclaimed.

Blocking uses the tracker's **native** dependency relationship — essential because it renders the frontier _visually_ in the tracker's own UI, so the human sees what's takeable without opening the map. Only a tracker that lacks native blocking falls back to a body convention. A ticket is **unblocked** when every ticket blocking it is closed; the **frontier** is the open, unblocked, unclaimed children — the edge of the known.

The answer isn't part of the body — it's recorded on resolution (see [Work through the map](#work-through-the-map)). Assets created while resolving a ticket are linked from the issue, not pasted in.

## Ticket Types

Every ticket is either **HITL** — human in the loop, worked *with* a human who speaks for themselves — or **AFK**, driven by the agent alone. A HITL ticket only resolves through that live exchange; the agent never stands in for the human's side of it (a grilling agent that answers its own questions has broken this).

- **Research** (AFK): Reading documentation, third-party APIs, or local resources like knowledge bases to surface a fact a decision waits on. Resolved by a `/research` **subagent**. Use when knowledge outside the current working directory is required — **or** when the codebase/docs already answer the question without a user trade-off.
- **Prototype** (HITL): Raise the fidelity of the discussion by making a cheap, rough, concrete artifact to react to — an outline, a rough take, a stub, or UI/logic code via the /prototype skill. Links the prototype as an asset. Use when "how should it look" or "how should it behave" is the key question.
- **Grilling** (HITL): Conversation via the /grilling and /domain-modeling skills. **Only for decisions a human must own.** Prefer **frontier-round batch/diff grill** for tables and mapping rows (recommended frontier set; human replies with diffs only). One *decision surface* per turn, not one micro-row per turn when a recommended table exists.
- **Task** (HITL or AFK): Manual work that must happen before a *decision* can be made — nothing to decide, prototype, or research, but the discussion is blocked until it's done (access, sample data, **production path verification**). Resolved when the work is done; the answer records resulting facts later tickets depend on.

**Discipline bias:** if the codebase, production config, or primary docs can satisfy the Resolution Signal, use `research` or `task` — **not** `grill-me`. HITL is expensive; default thin.

## Fog of war

The map is _deliberately_ incomplete: don't chart what you can't yet see. Beyond the live tickets lies the **fog of war** — the dim view of decisions and investigations you can tell are coming but can't yet pin down, because they hang on questions still open. Resolving a ticket clears the fog ahead of it, graduating whatever's now specifiable into fresh tickets — one at a time, until the way to the destination is clear and no tickets remain.

The map's **Not yet specified** section is where that dim view is written down: the suspected question, the area to revisit later. It's the undiscovered frontier _toward_ the destination — everything here is in scope, just not sharp enough to ticket. Write as loosely or as fully as the view allows; it doubles as a signpost for collaborators reading where the effort is headed.

**Fog or ticket?** The test is whether you can state the question precisely now — _not_ whether you can answer it now.

- **Ticket when** the question is already sharp — even if it's blocked and you can't act on it yet.
- **Not yet specified when** you can't yet phrase it that sharply. Don't pre-slice the fog into ticket-sized pieces: it's coarser than a ticket, and one patch may graduate into several tickets, or none, once the frontier reaches it.

**Not yet specified** excludes what's already decided (Decisions so far), what's already a live ticket, and what's out of scope (the next section).

## Out of scope

Fog only ever gathers _toward_ the destination. The destination fixes the scope, so work beyond it is **out of scope** — it isn't fog, and it doesn't belong in **Not yet specified**. It gets its own **Out of scope** section on the map: work you've consciously ruled out of _this_ effort. Scope, not sharpness, lands it here.

Out-of-scope work never graduates — the frontier stops at the destination — so it returns only if the destination is redrawn, and then as a fresh effort, not a resumption.

Ruling something out of scope is a scoping act, not a step on the route. When a ticket that already exists turns out to sit past the destination — mis-scoped in while charting, or exposed by a resolution — **close it** (a closed ticket is unambiguously off the frontier) and leave one line in the **Out of scope** section: the gist plus why it's out of scope, linking the closed ticket. It stays out of **Decisions so far**, which records the route actually walked — a scope boundary isn't a step on it.

**Second themes** (e.g. broad multi-vendor architecture cleanup while the destination is a product display-status spec) default to **Out of scope** or a **separate map**. Only promote a seam into this map when it **blocks** the destination's honesty.

## Invocation

Two modes. Default: **at most one HITL decision ticket per session**. **Exceptions:** (1) any number of `research` tickets in parallel or sequence in one session; (2) AFK `task` tickets may batch in the same session after or before one HITL ticket if the user asks or the frontier is all AFK; (3) user explicitly says "same session, next ticket".

Human pastes should stay **short** — see [CONTINUE.md](CONTINUE.md). The agent must **not** demand multi-paragraph prompts; recover context from the map's **Session handoff**.

### Chart the map

User invokes with a loose idea (or `/wayfinder` + brief goal).

1. **Name the destination.** Prefer a short confirmation of Destination from user materials; use `/grilling` only if Destination itself is ambiguous. Destination fixes scope — **one product/engineering outcome**, not a second architecture epic unless the user insists.
2. **Map the frontier** breadth-first. **If no multi-session fog** — stop; recommend `/grill-me` or `/to-spec` instead of a map.
3. **Create the map** with Destination, compact Notes (tracker root, domain, skills), empty Decisions, fog in **Not yet specified**, and an initial **Session handoff** block.
4. **Create only tickets you can specify now** — **Chart budget: ≤5 open tickets** on first publish. Wire blocking in a second pass. Everything else stays fog. Prefer `research`/`task` over `grill-me` when possible.
5. **Fire research subagents** immediately for every `research` ticket (parallel). Capture findings and close AFK research when the Resolution Signal is met **in this Chart session** when cheap — do not leave pure fact-gathering as HITL homework.
6. **End Chart with one-line pastes** for the human (next Resolve / optional AFK burn-down). Do **not** hand-resolve HITL tickets in the Chart session unless the user explicitly continues into Resolve.

### Work through the map (Resolve)

User invokes with a **short** line: map path, or "next", or a ticket name — see [CONTINUE.md](CONTINUE.md).

#### Cold-start (hard cap)

On Resolve, **only** load:

1. Map file → **Destination + Session handoff + Decisions so far + Notes** (not every historical comment).
2. The chosen **ticket** body.
3. At most **3** evidence paths named on that ticket or in handoff.

**Do not** default-read `FOG.md`, full `TEMPLATES.md`, full this SKILL, or the whole tracker adapter doc on every Resolve. Re-read those only when claim/fields/tracker ops fail or the handoff is missing/corrupt.

**Do not** Glob the whole repo for `WAYFINDER.md` when Notes/handoff already give the path.

Local markdown: map path is `.scratch/<slug>/WAYFINDER.md`; children live under `.scratch/<slug>/wayfinder/`.

#### Resolve steps

1. Read **Session handoff**; pick frontier ticket (user-named or first unblocked open).
2. **Claim** map + ticket before work.
3. Resolve by discipline (`research` subagent / `task` / `/grill-me` batch-diff / `prototype`). Zoom related closed tickets **only on demand**.
4. Record resolution; close ticket; append named gist to Decisions so far; update **Session handoff** (`next_paste`, frontier).
5. Graduate fog only when now sharp; rule mis-scoped tickets out of scope; fix invalidated tickets.

When the frontier is empty and fog is empty (or only out-of-scope remains): set map `Status: resolved`, clear claim, and **exit Wayfinder** — print the **post-map paste** (`/to-spec …`). Do **not** implement inside the map.

### After the map is clear (simplified exit)

```text
map Status: resolved
  → /to-spec   <map or feature slug>
  → /to-tickets
  → /implement   (AFK frontier; skip HITL gates until human says so)
```

No more `/wayfinder` unless new multi-session fog appears. Do not re-grill closed DECs during `/to-spec`; consume Resolutions as sources of truth.

## Resolution Signal

Every decision ticket needs a checkable **Resolution Signal**. Patterns: [TEMPLATES.md](TEMPLATES.md).

**Runtime / production facts** (ingress URL, deployed owner, feature flags, "can actually send"): Signal must require **production or ops evidence** (config path, live route, owner confirmation, or a real probe log) — **never** "a Controller exists in module X" alone.

## Session handoff (required)

Maintain on the map (see [TEMPLATES.md](TEMPLATES.md)). After Chart and every Resolve stop, the human-facing closeout is:

1. One sentence: what closed / what's next by **name**.
2. A **single copy-paste line** for the next session (from handoff `next_paste`).
3. If map resolved: the `/to-spec` one-liner instead.

Never ask the human to re-paste Destination, iron rules, or full ticket bodies.

## WEN additions

- Routing: LIGHT L4 in `docs/lifecycle.md`. Prefer same-session `/grill-me` when one interview would clear the fog. **Never invent** Expected / market / user value; **never implement the destination** (disposable `/prototype` only when the ticket authorizes it).
- Tracker ops: resolve the issue-tracker doc via the harness pointer from `/setup-project-harness` (not a hard-coded path). Default without harness: **local-markdown** under `.scratch/`. Field shapes: [TEMPLATES.md](TEMPLATES.md). Fog extract: [FOG.md](FOG.md) (must not contradict this file). Short pastes: [CONTINUE.md](CONTINUE.md).
- Prefer checkable **Resolution Signal** on each ticket. Full answer in the resolution comment; map only gets a named gist.
- Claim map/ticket before work when the adapter supports it; release claims on stop. `/research` and `/prototype` return evidence only — Wayfinder owns comments, closure, and map updates.
- **Chart budget:** ≤5 tickets on first publish; expand only by graduating fog after resolutions.
- **Architecture scans** (`/improve-codebase-architecture`, etc.) feed **fog or research tickets**, not automatic DECs; Strong findings still need production/runtime Signals when they claim ownership of live paths.
- Keep narration short; skip honorific filler. Working notes live on the ticket; rewrite CONTEXT/glossary **on ticket close**, not after every micro-answer.
