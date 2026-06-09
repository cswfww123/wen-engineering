---
name: do-grill
description: Runs one focused grill topic and persists conclusions. Use when resuming grill-prep docs or next priority grill.
---

# Do Grill

Work through one topic from a `/grill-prep` set.

This is like `/do-issues` for planning: select the highest-priority unblocked topic, grill only that topic, write conclusions, then stop. Do not loop into the next topic.

Assume the user will `/clear` after this session. The only durable state is `docs/grilling/<slug>/`, plus `CONTEXT.md` and ADRs created by `/domain-modeling`.

## Quick Start

1. Find `docs/grilling/<slug>/INDEX.md`, or use the path/topic the user gave.
2. Run the state self-check.
3. Select one runnable topic.
4. Load only `INDEX.md`, that topic file, `CONTEXT.md`/ADRs, and directly relevant repo evidence.
5. Run `/grilling` with `/domain-modeling` inside the topic scope.
6. Persist material answers, decisions, and blockers into the topic file as they crystallize.
7. Update the topic file and `INDEX.md` with conclusions.
8. Run the state self-check again and name the next action.

## Find The Grill Set

If the user passed a grill folder, index path, or topic file, start there. Otherwise, use the most recently active unfinished `docs/grilling/*/INDEX.md`. If multiple sets look equally current, ask one concise question with the candidate paths. If no grill-prep set exists, run `/grill-prep` only when the user wants persistent multi-session topic docs; otherwise use `/grill-with-docs`.

## State Self-Check

Before selecting a topic and after writing one back, read `INDEX.md` and classify topics as `done`, `runnable`, `blocked`, or `optional`.

- `done`: required topic is `Complete` or `Out of scope`
- `runnable`: required topic is not done and has no unresolved blockers
- `blocked`: required topic is not done and has unresolved blockers
- `optional`: `Required` is `No`

If every required topic is done, stop and tell the user to run `/finish-grill`. If none are runnable but some are blocked, stop and report blockers. If required topics are runnable, pick exactly one. Optional topics never block `/finish-grill`.

## Native Grill Contract

Do not invent a separate interview style. `/do-grill` only selects scope and persists state. The questioning protocol is `/grilling` with `/domain-modeling`, unless the selected topic itself needs further prep. Preserve the native rules:

- ask one question at a time and wait
- provide your recommended answer for each question
- explore the codebase instead of asking when code can answer
- challenge fuzzy or conflicting domain terms
- update `CONTEXT.md` only for glossary terms, never planning notes
- create ADRs only for hard-to-reverse, surprising trade-offs

If the selected topic is still too broad for one focused session, split it into smaller topic files, update `INDEX.md`, and stop.

## Select One Topic

A topic is runnable when `Status` is missing, `not started`, `ready`, or `in-progress`; `Blocked by` is empty, `none`, or complete; `Required` is not `No` unless user-named; and the scope fits without unrelated topic files.

Prefer topics in this order:

1. The topic the user named
2. Highest `Priority` (`highest`, `high`, `medium`, `low`)
3. Topics blocking other topics
4. First unfinished topic in `INDEX.md`

Never start two topics in one session.

## Run The Topic

Keep the session narrow:

- Move off-topic answers into the matching topic backlog instead of expanding scope.
- After each material answer, write durable notes to the topic file.

Stop the topic when its `Done When` criteria are met, the user pauses, or a blocker appears.

## Write Back

Update the topic file with decisions made, evidence found, important context, remaining risks, docs changed, and PRD-ready summary. Update `INDEX.md` with status, conclusion summary, blockers, and the next recommended topic.

After write-back, rerun the state self-check. If all required topics are complete or explicitly out of scope, tell the user the next command is `/finish-grill`. `/to-prd` should read the resulting `PRD-SOURCE.md`, not topic chats.

## Done

Report the topic completed, the decisions captured, verification or evidence used, open blockers, and exactly one next action: another `/do-grill`, `/finish-grill`, or blocker resolution. Do not continue automatically.
