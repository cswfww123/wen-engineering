---
name: research
description: Research primary sources for an explicit question or active Wayfinder ticket and save cited evidence.
---

# Research

Answer one explicit research question with high-trust evidence. Run only for a
matching user request or an active, already-authorized Wayfinder ticket.

## Bound The Question

State the question, decision it informs, current assumptions, source freshness
needed, and completion signal. If the request is a Wayfinder ticket, treat that
ticket as scope; the caller retains its claim and tracker state.

## Investigate

Delegate the reading to a background agent when available so the caller can
continue independent work. Give it the bounded question and these rules:

1. Prefer the source that owns each claim: official docs, specifications,
   source code, first-party APIs, standards, or original research.
2. Follow important claims back to primary sources. Label any unavoidable
   secondary evidence and any inference.
3. Record version, date, or retrieval context when the fact can drift.
4. Capture contradictions, unresolved gaps, and applicability limits.
5. Return one cited Markdown artifact, not a prose-only chat summary.

If delegation is unavailable, run the same investigation directly.

## Save One Artifact

Use the repo's existing research or notes convention. When none exists, write
`.scratch/<effort-slug>/research/<question-slug>.md`. Include:

- question and completion signal
- concise answer and decision implications
- claim-by-claim findings with inline source links
- uncertainties, contradictions, and follow-ups
- source list with access dates when relevant

Write only this bounded, reversible evidence artifact. Leave tracker state,
relationships, manifests, production persistence, and existing production
behavior unchanged. The user-invoked caller owns publication and closure.

## Return

Report exactly:

- `Artifact`: path to the Markdown file
- `Answer`: the shortest decision-useful synthesis
- `Disposition`: `keep`, `delete`, or `promote`, with a reason
- `Gaps`: unresolved evidence that could change the decision

`Promote` is a recommendation to the caller, not permission to edit a spec,
ADR, tracker, or production artifact.
