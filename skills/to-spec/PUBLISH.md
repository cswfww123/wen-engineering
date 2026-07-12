# Spec Publish

Load only when publishing an approved draft through the tracker adapter
(`docs/agents/issue-tracker.md`).

## Normal Source

1. Publish as `Kind: spec`, `Runnable: no`, `Status: accepted`,
   `Origin: <bug-report | none>`.
2. Do **not** apply executable triage roles (`ready-for-agent`, etc.) to the
   spec — those belong on implementation tickets.
3. Read the canonical path/URL back and report it.

## Bug-Report Source

Follow [BUG-REPORT-CONVERSION.md](BUG-REPORT-CONVERSION.md)
(spec branch): claim → re-search Origin → publish → Converted to → resolve →
release.
