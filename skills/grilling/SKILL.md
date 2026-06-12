---
name: grilling
description: Core interview protocol. Use when grill-with-docs invokes grilling or the user asks for bare grilling.
---

# Grilling

Interview the user relentlessly about every aspect of a plan or design until you reach shared understanding.

Walk down each branch of the design tree, resolving dependencies between decisions one by one. For each question, provide your recommended answer.

Ask one question at a time. Wait for feedback before continuing.

## Question Types

Walk through these layers in order. Earlier layers resolve dependencies for later ones:

1. **Constraints** — what must be true? Budget, timeline, technology, team, regulation, existing commitments
2. **Scope boundaries** — what is explicitly out of scope? What adjacent problems are we not solving?
3. **Core behavior** — what must the system do? What are the main user-visible flows?
4. **Edge cases and error paths** — what happens when things go wrong? Invalid input, partial failure, concurrency, missing data
5. **Dependencies and integration** — what does this touch? Upstream/downstream systems, shared state, migration
6. **Trade-offs** — where are we choosing between competing goals? Performance vs simplicity, flexibility vs speed, consistency vs availability

Not every layer applies to every topic. Skip a layer only when the topic clearly has no relevant questions in it.

## Recommendation Format

For each question, give your recommended answer — not just the question. Structure it as:

```
Q: <one focused question>

Recommended: <your best answer based on available evidence>

Alternatives considered: <briefly, if any>
```

If you cannot recommend confidently, say what evidence would resolve it and whether that evidence can be found in the codebase.

## Evidence First

If a question can be answered by exploring the codebase, explore the codebase instead of asking. Report what you found and whether it resolves the question or only narrows it.

If the answer depends on real execution behavior rather than file names or surface structure, load `/deep-code-trace` for the relevant entrypoint before recommending an answer.

Do not ask questions that repo evidence already answers.

## Handling Contradictions

When the user's answer contradicts earlier decisions or codebase evidence:

1. State the contradiction explicitly
2. Cite the earlier decision or code evidence
3. Ask which direction to resolve — do not silently adopt one side

## Stopping Criteria

Stop grilling a topic when:

- every constraint is stated or explicitly deferred
- core behavior is specified with no obvious gaps
- edge cases are covered or explicitly out of scope
- remaining unknowns are genuinely user-owned decisions that cannot be resolved now
- the user says to stop

Do not stop just because you ran out of obvious questions. Stop when the topic is resolvable by an implementer without guessing.

## Done Means

- constraints are stated or explicitly deferred
- scope boundaries are drawn
- core behavior is specified
- edge cases are covered or explicitly out of scope
- remaining unknowns are clearly marked as user-owned
- an implementer can start work without guessing at material decisions
