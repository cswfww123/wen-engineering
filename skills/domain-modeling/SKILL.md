---
name: domain-modeling
description: Sharpen domain language; write glossary or ADR decisions. Use for domain terms, glossary, or ADRs.
---

# Domain Modeling

Challenge fuzzy terms, probe edge scenarios, cross-check code, and write glossary/ADR decisions as they crystallize. Reading `CONTEXT.md` only for vocabulary is not this skill — use when the model is **changing**.

Formats: [CONTEXT-FORMAT.md](CONTEXT-FORMAT.md), [ADR-FORMAT.md](ADR-FORMAT.md).

## Files

Default: root `CONTEXT.md` + `docs/adr/`. If `CONTEXT-MAP.md` exists, use it to locate context-specific paths. Create lazily on first resolved term / first ADR.

## During The Session

- **Glossary conflict** — when user language conflicts with `CONTEXT.md`, surface both meanings immediately and ask which to use (or name a new term).
- **Fuzzy language** — propose a precise canonical term, why the original is ambiguous, confirm, then update.
- **Scenarios** — invent concrete edge cases that force relationship boundaries.
- **Code check** — when the user claims how something works, verify in code. Trace services/callers/DAO/converters/permissions/side effects when needed. Glossary stays conceptual — no impl dumps.
- **Update inline** — write resolved terms to `CONTEXT.md` immediately; no batching. No implementation detail in the glossary.

Good entry distinguishes neighbors (`Order` ≠ `Cart` ≠ `Transaction`). Bad entry: vague “manages X” with no boundary.

## ADRs (sparingly)

Offer only when all three hold: hard to reverse, surprising without context, from a real trade-off. Else skip.
