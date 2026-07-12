# Ticket Publish

Load only when publishing an approved ticket graph through the tracker adapter
(`docs/agents/issue-tracker.md`, `docs/agents/triage-labels.md`).

## Normal Source

1. Create only missing tickets in dependency order so blockers have stable IDs.
2. Attach each ticket to the accepted spec parent. Prefer native parent/blocking
   relationships; body fields only when the adapter lacks them. One source of
   truth per relationship.
3. Apply `ready-for-agent` only to open `AFK` implementation tickets; configured
   `ready-for-human` for `HITL`. Leave the parent open and non-runnable.
4. Query the tracker; report canonical set, requirement coverage, and actual
   implementation/human frontiers.

## Bug-Report Source

Follow [BUG-REPORT-CONVERSION.md](BUG-REPORT-CONVERSION.md)
(tickets branch): claim → re-search Origin → create with `Origin` → full graph
read-back → Converted to / `covered-by-existing-parent` → resolve → release.
