# ADR Format

ADRs live in `docs/adr/` and use sequential numbering: `0001-slug.md`, `0002-slug.md`, and so on.

Create `docs/adr/` lazily, only when the first ADR is needed.

## Template

```md
# {Short title of the decision}

{1-3 sentences: what is the context, what did we decide, and why.}
```

That is enough for most ADRs. The value is recording that a decision was made and why.

## Optional Sections

Only include these when they add genuine value:

- `Status` frontmatter: `proposed`, `accepted`, `deprecated`, or `superseded by ADR-NNNN`
- Considered Options
- Consequences

## Numbering

Scan `docs/adr/` for the highest existing number and increment by one.

## When To Offer An ADR

All three conditions must be true:

1. Hard to reverse: the cost of changing your mind later is meaningful.
2. Surprising without context: a future reader would wonder why this path was chosen.
3. Real trade-off: there were genuine alternatives and one was chosen for specific reasons.

If a decision is easy to reverse, skip it. If it is not surprising, skip it. If there was no real alternative, skip it.

## What Qualifies

- Architectural shape
- Integration patterns between contexts
- Technology choices that carry meaningful lock-in
- Boundary and scope decisions
- Deliberate deviations from the obvious path
- Constraints not visible in the code
- Rejected alternatives when the rejection is non-obvious
