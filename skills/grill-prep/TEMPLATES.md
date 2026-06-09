# Grill Prep Templates

Use these shapes when `/grill-prep` writes docs or emits thread prompts.

## Folder

```text
docs/grilling/<slug>/
  INDEX.md
  PRD-SOURCE.md
  market-validation.md
  product-scope.md
  architecture.md
```

Create only the topic files the idea needs.

## INDEX.md

```md
# <Project Or Idea> Grill Prep

## Seed

<One paragraph version of the idea.>

## Known Decisions

- <Decision already stated or proven by repo evidence.>

## Persistent State

- Last updated:
- Current topic:
- Next recommended topic:
- Required topics: <done>/<total>
- Runnable required topics:
- Blocked required topics:
- PRD source: <PRD-SOURCE.md after /finish-grill, or "Not ready">
- Source of truth: this folder, `CONTEXT.md`, and ADRs. Do not rely on prior chat after `/clear`.

## Global Blockers

- <Blocker that prevents useful topic work, or "None".>

## Topic Map

| Topic | File | Required | Priority | Blocked by | Purpose | Status |
| --- | --- | --- | --- | --- | --- | --- |
| Market validation | market-validation.md | Yes | High | None | Test demand, competition, and buyer urgency. | Not started |

## Integration Rules

- Main thread routes work and tracks conclusions.
- Topic threads read only this index, their topic file, and directly relevant evidence.
- Topic threads return compact conclusions, not transcripts.
- Use `/do-grill` to complete one topic per session.
- `/do-grill` runs `/grilling` with `/domain-modeling` inside one topic scope.
- `/do-grill` self-checks this index before and after each topic.
- Use `/finish-grill` after required topics are `Complete` or `Out of scope`.
- Use `/to-prd` only after `PRD-SOURCE.md` exists.

## Conclusions

### <Topic>

- Decisions:
- Evidence:
- Open questions:
- Next:

## Synthesis Gaps

- <Added by /finish-grill when required information is missing.>
```

## Topic Brief

```md
# <Topic>

Priority: <Highest | High | Medium | Low>
Required: <Yes | No>
Status: <Not started | In progress | Complete | Blocked | Out of scope>
Blocked by: <None or topic/file>

## Scope

What this thread may discuss:

- <In scope>

What this thread should not discuss:

- <Out of scope>

## Starting Context

- Seed: <One sentence reminder of the idea>
- Known facts:
- Existing evidence:
- Glossary/ADR context:
- Scope fit: <Fits one focused session, or needs a smaller topic split>

## Durable Notes

- <Append material answers, decisions, blockers, and evidence here during the session.>

## Light Grill Questions

1. <Question>
   - Why it matters:
   - Smallest evidence needed:
   - Recommended starting hypothesis:

## Done When

- <Decision, artifact, or evidence that closes this topic>

## Conclusion

- Decisions made:
- Evidence found:
- Important context:
- Remaining risks:
- Docs changed:
- PRD-ready summary:
- Return summary for INDEX.md:
```

## Thread Launch Prompt

```text
Use /do-grill for this topic only.

Project seed:
<seed>

Read:
- docs/grilling/<slug>/INDEX.md
- docs/grilling/<slug>/<topic>.md
- CONTEXT.md or CONTEXT-MAP.md plus relevant ADRs, if present
- only directly relevant repo evidence

Do not solve other grill-prep topics. Run /grilling with /domain-modeling inside this topic scope. If the topic is still too broad for one focused session, split it further and stop. Persist material answers into the topic file, update INDEX.md, then return only a compact conclusion.
```
