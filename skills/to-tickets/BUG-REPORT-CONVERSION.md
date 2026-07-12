# Bug-Report Conversion

Shared protocol for `/to-spec` and `/to-tickets` when the **explicit source** is a
`bug-report`. Keep this file identical to `skills/to-spec/BUG-REPORT-CONVERSION.md`.
Adapter: `docs/agents/issue-tracker.md`. Never select a bug-report from an
implementation frontier — only when the user names it.

## Before Drafting

1. Read the report (repro, QA evidence, original parent).
2. Inspect `Converted to` and search exact `Origin` fields for an existing
   replacement. **Reuse one canonical replacement; never publish a duplicate.**
3. Decide **scope disposition** with evidence:
   - **Parent already covers** the defect, no new requirement → `/to-tickets`
     against that accepted parent (this file's tickets branch).
   - **Genuinely new**, outside original scope, or needs a new accepted
     requirement set → `/to-spec` (this file's spec branch).
   - Disposition not evidence-backed → leave the report open so the original
     parent stays blocked; do not invent scope.

## Claim

Immediately before publishing any replacement: claim the report for conversion,
re-read ownership, and **repeat** the exact `Origin` search. If another worker
already converted it, reuse that graph and stop. When claims are not atomic or
workers share one identity, convert **serially**.

## Spec Branch (`/to-spec`)

Use only when the report needs a new non-runnable parent.

1. Preserve links to historical artifacts; never rename them. Keep repro and
   original parent visible in the draft.
2. Publish approved draft as `Kind: spec`, `Runnable: no`, `Status: accepted`,
   `Origin: <bug-report>`. Leave `ready-for-agent` for implementation tickets.
3. Read the canonical spec back. Only then write its reference and the
   evidence-backed scope disposition onto the report (and original source if
   required by the adapter). Set `Converted to`, resolve the report as
   **superseded**, read both back, release the conversion claim.
4. On publish/read-back failure: leave the report open; release the claim when
   stopping; retain the claim only while a recoverable conversion is actively
   continuing.

## Tickets Branch (`/to-tickets`)

Use only when an **accepted parent already covers** the defect and no new
requirement or scope decision is needed. Otherwise stop and recommend `/to-spec`.

1. Create only missing tickets in dependency order. Every replacement uses
   `Origin: <bug-report>`. Attach each to the existing accepted spec parent.
2. Prefer native parent/blocking relationships; body fields only when the
   adapter lacks them. Apply `ready-for-agent` only to open `AFK` tickets;
   configured `ready-for-human` for `HITL`. Leave the parent open and
   non-runnable.
3. After the **full graph** reads back: write every canonical replacement to
   `Converted to`, record scope disposition `covered-by-existing-parent`,
   resolve the report, read it back, release the conversion claim. Open
   replacement tickets keep the original parent blocked.
4. On failure: keep the report open; release the claim when conversion is no
   longer actively continuing.
