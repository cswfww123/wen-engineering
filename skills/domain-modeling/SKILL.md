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

Example:

```
You said "campaign" but CONTEXT.md defines campaign as "a paid promotion with a budget and schedule."
You seem to mean "any outgoing message including organic posts."
Which meaning should we use here, or do we need a new term?
```

### Sharpen Fuzzy Language

When the user uses vague or overloaded terms, propose a precise canonical term.

Example:

```
BAD:  "Handle the payment stuff"
GOOD: "Process the Stripe charge for the order total, then record the transaction in the payments table"

BAD:  "The system manages users"
GOOD: "The system creates, authenticates, and authorizes customer accounts"
```

Propose the sharpened term, explain why the original was ambiguous, and ask for confirmation. Update `CONTEXT.md` once confirmed.

### Discuss Concrete Scenarios

When domain relationships are being discussed, invent specific scenarios that probe edge cases and force precise boundaries.

### Cross-Reference With Code

When the user states how something works, check whether the code agrees. Surface contradictions directly.

### Update CONTEXT.md Inline

When a term is resolved, update `CONTEXT.md` right away. Do not batch glossary updates.

`CONTEXT.md` must stay free of implementation details. It is a glossary, not a spec, scratch pad, or implementation decision log.

Good glossary entry:

```markdown
- **Order**: a customer's intent to purchase one or more items, identified by `order_id`. Includes line items, total, and payment status. Not the same as a Cart (pre-checkout) or a Transaction (payment record).
```

Bad glossary entry:

```markdown
- **Order**: manages orders (too vague, no boundaries, no distinctions from neighbors)
```

### Offer ADRs Sparingly

Only offer an ADR when all three are true:

1. The decision is hard to reverse.
2. The decision is surprising without context.
3. The decision came from a real trade-off.

If any condition is missing, skip the ADR.
