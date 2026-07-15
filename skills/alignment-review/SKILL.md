---
name: alignment-review
description: Reviews specs and tickets for intent, coverage, repo evidence, and execution fit.
disable-model-invocation: true
---

# Alignment Review

Review planning artifacts before the next coding step so the next agent does not
drift from user intent, requirement coverage, repo evidence, or executable scope.

Use after `/to-spec` or `/to-tickets` when intent, coverage, slicing, or repo fit
is risky. May precede `/to-tickets` or `/implement` according to the artifact.

System test plans live in optional `wen-test` — out of scope here.

See [CHECKLIST.md](CHECKLIST.md) for sharper prompts by artifact type.

## Workflow

### 1. Gather The Handoff Packet

Read only what the review needs:

- original user request, source issue, legacy PRD, or grill/Wayfinder output
- generated spec or implementation tickets
- relevant repo evidence, glossary, ADRs, and harness rules
- related tests, contracts, or seams when fit depends on code

If fit depends on code behavior, trace the entrypoint before judging ownership,
seams, data flow, permissions, or async side effects. If source is missing, say
what cannot be verified and review only claims with evidence.

### 2. Zoom Out

Map the domain objects, modules, callers, data flow, permissions, async
boundaries, and integration seams that matter. Use project domain language. Keep
the map short enough to support judgment.

### 3. Check Alignment

Compare the artifact against source and repo map:

- preserves the user's problem, constraints, and explicit out-of-scope boundaries
- every material requirement has a stable ID (or legacy source ref) and appears
  in ticket `Covers` or explicit AC/deferral
- every material risk appears in AC, verification notes, or explicit out-of-scope/blocker
- no invented certainty where the source only supported an assumption
- technical direction fits current ownership and integration seams
- verification points concrete enough for the next agent to prove completion

### 4. Check Execution Shape

**Specs:** behavior surface covered; implementation/testing decisions repo-backed;
rollout/migration/monitoring named when release safety depends on them;
out-of-scope prevents drift.

**Tickets:** one-context vertical tracer bullets, not horizontal layer tasks.
Mechanical tickets only under the named expand-contract branch (`Covers: none`,
stable `Supports` + `Decision`, behavior-preservation evidence). Confirm `Kind`,
`Mode`, parent, trace fields, blockers, verification seam, frontiers, and an
acyclic graph.

Non-functional coverage only when source or repo risk calls for it. If a material
requirement has no ticket coverage, explicit blocker, or out-of-scope decision,
verdict cannot be `Pass`.

### 5. Report A Verdict

Lead with one verdict:

- `Pass` — ready for the next declared lifecycle step; name that step
- `Small Fix` — mostly aligned; list required edits
- `Rework` — missing or misleading enough to regenerate or re-slice
- `Ask User` — blocked by a real product decision

For each finding:

```markdown
### <verdict area>: <one-line summary>

- **Artifact section**: <which part of the spec/ticket>
- **Source evidence**: <user request, spec line, or repo evidence that contradicts>
- **Gap**: <what is missing, misleading, or invented>
- **Smallest correction**: <how to fix it>
```

Do not rewrite the whole artifact unless asked. Report findings with evidence and
corrections, then stop.
