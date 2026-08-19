---
name: alignment-review
description: Optional audit of unreviewed specs/tickets; mandatory prd-walk at PRD-sourced package close. Not on the default L2 publish path.
disable-model-invocation: true
---

# Alignment Review

**Escape hatch, not a lifecycle step.** Default multi-slice path is
`/to-spec` → `/to-tickets` (with mandatory pre-publish gate) → `/implement`.
Do **not** insert this skill after every PRD or ticket publish.

Manual audit of planning artifacts when the next agent might drift from user
intent, requirement coverage, repo evidence, or executable scope — typically
because a human did **not** already approve the graph in-session.

## When to use

- Handoff: PRD/tickets from another session/agent, not re-approved here
- Unreviewed publish: agent-authored graph without human quiz/approval
- High-risk re-slice after a large scope or architecture change
- You explicitly want a second-pass audit before `/implement`
- **prd-walk (mandatory):** delivery source is an in-repo / named product doc
  **and** (the last implementation ticket is closing, **or** the user asked
  已按 PRD 实现 / 对照 PRD 验收 / 是不是做完了, **or** the parent spec is being
  called `delivered`). Protocol: `docs/prd-authority.md` §5.

## When not to use

- Same-session HITL already ran: grill (if needed) → approved PRD → approved
  tickets with `/to-tickets` §5 gate — that **is** alignment for *publish*
  (prd-walk is still required at **package close** when a product doc is the
  delivery source)
- Ordinary slice risk that the to-tickets gate already catches (`Covers`,
  vertical vs horizontal, blockers, frontiers) — except the prd-walk trigger
  above

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
- when an active product requirements/PRD is in the handoff, it is the product
  behavior baseline — grill/chat may add residual eng pins or labeled `相对 PRD`
  deltas only; unlabeled session MVP must not replace product-doc requirements
- **prd-walk mode:** compare the **original product doc** (not the eng spec
  recap). Emit `SRC | Surface | 过|缺|有意 delta <id> | Evidence` for every
  Inventory row, or every numbered 验收 + material 场景 if Inventory is
  missing. `缺` → verdict cannot be `Pass`; do not say 已按 PRD 实现.
  `有意 delta` must already exist on the Accepted deltas table.
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
