---
name: finish-grill
description: Synthesizes all grill topics into a PRD source. Use after do-grill topics are complete or before to-prd.
---

# Finish Grill

Close a large grill set by reading every required topic file and producing one PRD-ready source artifact. Small one-session grills do not need this skill.

Do not rely on chat history. The source of truth is `docs/grilling/<slug>/INDEX.md`, every topic file listed there, `CONTEXT.md`, and ADRs.

## Quick Start

1. Find the grill folder from the user path or the most recent unfinished `docs/grilling/*/INDEX.md`.
2. Read `INDEX.md` and parse the Topic Map.
3. Read every topic file listed in the Topic Map. Do not skip low-priority or completed-looking files.
4. Verify every `Required: Yes` topic is complete or explicitly out of scope.
5. Write `docs/grilling/<slug>/PRD-SOURCE.md`.
6. Update `INDEX.md` with the source path and remaining gaps.

## Completeness Gate

Stop and report gaps instead of writing a final source when:

- a topic file listed in `INDEX.md` is missing
- a required topic is not `Complete` or `Out of scope`
- a topic has no `Conclusion`
- a required topic has no `PRD-ready summary`
- a topic has open blockers that affect PRD scope
- decisions contradict each other
- an important question is neither answered nor explicitly out of scope

If gaps are narrow, recommend the next `/do-grill` topic. If only optional topics remain, mark them out of scope or include them as non-blocking notes.

## PRD-SOURCE.md

Create one synthesis file with:

- seed and outcome
- included topic files checklist
- decisions by topic
- evidence by topic
- user stories implied by the conclusions
- implementation decisions
- testing decisions
- domain terms and ADRs referenced
- assumptions
- out of scope
- open questions that should not block the PRD
- traceability table mapping each PRD claim to topic files

Every material PRD claim should trace to at least one topic file, `CONTEXT.md`, ADR, code evidence, or explicit assumption.

## Update INDEX.md

Add or update:

- `PRD source: PRD-SOURCE.md`
- synthesis status: `Ready for PRD` or `Blocked`
- gaps found
- next recommended action

## Done

Done means `PRD-SOURCE.md` exists, every topic file was considered, gaps are explicit, and `/to-prd` can synthesize from the source without reading chat transcripts.
