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

<One narrow end-to-end behavior, from trigger to observable result.>

## Acceptance Criteria

- [ ] <Observable criterion linked to the covered requirements>
- [ ] <Failure, permission, compatibility, or recovery criterion when relevant>

## Verification

- <The public seam and evidence that will prove completion>

## Out Of Scope

<Nearby work this ticket intentionally leaves for another ticket or the spec.>
```

For local Markdown, a claim is advisory unless the repo supplies atomic
locking. The adapter must say so; serial execution is the safe fallback.
