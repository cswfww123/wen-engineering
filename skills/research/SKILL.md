---
name: research
description: Primary-source research for an explicit question or active Wayfinder ticket; save cited evidence.
---

# Research

One explicit research question, high-trust evidence. Only for a matching request or an active authorized Wayfinder ticket.

## Bound

State question, decision it informs, assumptions, freshness need, completion signal. Wayfinder ticket = scope; caller keeps claim/tracker state.

## Investigate

Prefer a background agent when available; same rules if running inline:

1. Prefer claim owners: official docs, specs, source, first-party APIs, standards, original research
2. Follow important claims to primary sources; label secondary evidence and inference
3. Record version/date/retrieval when facts drift
4. Capture contradictions, gaps, applicability limits
5. Return one cited Markdown artifact — not chat-only prose

## Save

Repo research/notes convention, else `.scratch/<effort-slug>/research/<question-slug>.md`:

- question + completion signal
- concise answer + decision implications
- claim-by-claim findings with inline source links
- uncertainties, contradictions, follow-ups
- source list with access dates when relevant

Only this bounded evidence artifact. No tracker/relationship/manifest/production mutation. Caller owns publication/closure.

## Return

- `Artifact`: path
- `Answer`: shortest decision-useful synthesis
- `Disposition`: `keep` | `delete` | `promote` (+ reason)
- `Gaps`: unresolved evidence that could change the decision

`Promote` is a recommendation, not permission to edit spec/ADR/tracker/production.
