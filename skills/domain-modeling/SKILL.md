---
name: domain-modeling
description: Sharpens domain language and records glossary or ADR decisions. Use for domain terms, glossary, or ADRs.
---

# Domain Modeling

Actively build and sharpen the project's domain model as you design.

This is the active discipline: challenge fuzzy terms, test concepts with concrete edge-case scenarios, cross-check claims against code, and write glossary or ADR decisions down as they crystallize.

Merely reading `CONTEXT.md` for vocabulary is not this skill. Use this skill when the model is changing, not just being consumed.

## File Structure

Most repos have one root `CONTEXT.md` and `docs/adr/`.

If `CONTEXT-MAP.md` exists, the repo has multiple contexts. Read it to find the relevant `CONTEXT.md` and context-specific ADR folder.

Create files lazily. If no `CONTEXT.md` exists, create one when the first term is resolved. If no ADR folder exists, create it when the first ADR is needed.

Use [CONTEXT-FORMAT.md](CONTEXT-FORMAT.md) and [ADR-FORMAT.md](ADR-FORMAT.md).

## During The Session

### Challenge Against The Glossary

When the user uses a term that conflicts with `CONTEXT.md`, call it out immediately and ask which meaning is correct.

### Sharpen Fuzzy Language

When the user uses vague or overloaded terms, propose a precise canonical term.

### Discuss Concrete Scenarios

When domain relationships are being discussed, invent specific scenarios that probe edge cases and force precise boundaries.

### Cross-Reference With Code

When the user states how something works, check whether the code agrees. Surface contradictions directly.

### Update CONTEXT.md Inline

When a term is resolved, update `CONTEXT.md` right away. Do not batch glossary updates.

`CONTEXT.md` must stay free of implementation details. It is a glossary, not a spec, scratch pad, or implementation decision log.

### Offer ADRs Sparingly

Only offer an ADR when all three are true:

1. The decision is hard to reverse.
2. The decision is surprising without context.
3. The decision came from a real trade-off.

If any condition is missing, skip the ADR.
