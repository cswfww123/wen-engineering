# Spec Template

Load this template only while drafting a spec. Adapt sections to the work, but
keep the identity, non-runnable marker, stable requirement IDs, decisions, and
traceability.

```markdown
Kind: spec
ID: <stable tracker reference or local ID>
Runnable: no
Status: draft | accepted | delivered
Origin: <bug-report reference | none>

# Spec: <outcome>

## Problem

<The user's problem, affected users, and evidence that it exists.>

## Outcome

<The observable result and how success will be judged.>

## Scope

<Included behavior, surfaces, actors, and constraints.>

## Requirements

### REQ-001 — <short behavior name>

- **Actor / trigger:** <who or what starts it>
- **Behavior:** <observable contract>
- **Acceptance boundary:** <what proves this requirement is satisfied>

### REQ-002 — <short behavior name>

- **Actor / trigger:** ...
- **Behavior:** ...
- **Acceptance boundary:** ...

## Main Flows

<Ordered flows and material failure or recovery paths.>

## Implementation Decisions

### DEC-001 — <short decision name, only when tickets need a stable reference>

- **Decision:** <modules, interfaces, contracts, schema, permissions, or seam>
- **Evidence:** <supporting repo evidence or ADR>

Avoid volatile file paths and full prototype code. Link evidence; inline only a
small prototype-derived shape when it expresses an accepted decision better
than prose.

## Testing Decisions

- **Seam:** <highest stable public seam>
- **Behavior covered:** REQ-...
- **Prior art / evidence:** <existing tests or harness>

## Dependencies And Rollout

<Migration, compatibility, config, observability, rollback, or manual gates.>

## Out Of Scope

<Explicit boundary and why it is outside this spec.>

## Assumptions And Open Questions

- **Accepted non-blocking assumption:** ...
- **Follow-up:** ...

## Evidence

- <Source discussion, issue, ADR, research, prototype, or code pointer>
```

Once accepted, keep requirement and decision IDs stable. Add new IDs for new
requirements or decisions; record retirement instead of reusing an old ID for
different behavior or a different decision.
