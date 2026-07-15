# Domain Docs

How agents should consume and maintain this repo's domain documentation.

## Before exploring, read these

- **`CONTEXT.md`** at the repo root.
- **`docs/adr/`** for ADRs that touch the area you're about to work in.

If these files do not exist, proceed silently. Do not flag their absence or
suggest creating them upfront. Create them **lazily** when a term or hard-to-
reverse decision actually crystallizes. Active sharpening (challenge terms,
write glossary/ADR) → `/domain-modeling`. Formats:
`skills/domain-modeling/CONTEXT-FORMAT.md`,
`skills/domain-modeling/ADR-FORMAT.md`.

## File structure

Single-context repo:

```text
/
|-- CONTEXT.md
|-- docs/adr/
|   |-- 0001-example-decision.md
|   `-- 0002-example-boundary.md
`-- skills/
```

## Use the glossary's vocabulary

When your output names a domain concept, use the term as defined in `CONTEXT.md`.
Do not drift to synonyms the glossary explicitly avoids.

If the concept you need is not in the glossary yet, reconsider whether you are
inventing language, or update the glossary when the term crystallizes.

## Maintain while working

- On glossary conflict (user language vs `CONTEXT.md`), surface both meanings and ask.
- Fuzzy language → propose a precise term, confirm, update inline (no batching).
- Glossary stays conceptual — no implementation dumps.
- ADR only when hard to reverse, surprising without context, and from a real trade-off.

## Flag ADR conflicts

If your output contradicts an existing ADR, surface it explicitly rather than
silently overriding it.
