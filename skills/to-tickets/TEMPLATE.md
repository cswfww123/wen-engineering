# Ticket Template

These are logical fields. A tracker with native parent, dependency, assignment,
or status support stores them natively and omits duplicate body fields. A local
Markdown adapter renders every field below.

```markdown
Kind: implementation-ticket
Subtype: n/a
ID: <stable tracker reference or local ID>
Runnable: yes
Mode: AFK | HITL
Layer: frontend | backend | full-stack | non-UI
Parent: <spec path or tracker reference>
Covers: REQ-001, REQ-002 | LEGACY:<stable source reference>
Supports: none | REQ-001, REQ-002 | LEGACY:<stable source reference>
Decision: none | DEC-001 | <stable ADR reference>
Origin: <bug-report reference | none>
Blocked by: None | <ticket references>
Status: ready-for-agent | ready-for-human
Claimed by: none
Claimed at: none
Resolution: pending

# <Outcome-oriented title>

## What To Build

<One narrow behavior in this layer, from trigger to observable result.
State integration seams if FE-only or BE-only.>

## Acceptance Criteria

- [ ] <Observable criterion linked to the covered requirements>
- [ ] <Failure, permission, compatibility, or recovery criterion when relevant>

## Verification

- **Behavior gate:** <public seam / scenarios / tests that prove AC for this layer>
- **UI fidelity gate:** n/a | checklist vs design pin + linkage paths
- **Contract fidelity gate:** n/a | API/event contract checks

## UI Subset (omit if Layer is backend or non-UI)

Preserve source IDs. Do not invent fields.

- **Screens / fields / rules:** ...
- **Design pin:** <versioned frame refs for this slice>

## API Subset (omit if Layer is frontend-only using external pin only)

- **Contracts under change:** ...
- **Compat / expand-contract notes:** ...

## Out Of Scope

<Other layers or nearby work left for another ticket or team.>
```

For local Markdown, a claim is advisory unless the repo supplies atomic
locking. The adapter must say so; serial execution is the safe fallback.
