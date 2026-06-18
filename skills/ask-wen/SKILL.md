---
name: ask-wen
description: Ask which WEN skill or flow fits the situation.
disable-model-invocation: true
---

# Ask WEN

Route the user to the smallest useful WEN skill flow.

Do not execute the routed skill unless the user asks you to continue. This skill
is a map, not the trip.

## Main Flow: Idea To Verified Work

Use this when the user wants to build or change something.

1. `/grill-with-docs` - sharpen the idea against repo evidence, domain language,
   and ADR-worthy decisions.
2. Branch on whether the idea needs a runnable answer before specification:
   - If state, business rules, or UI shape must be felt instead of described,
     use `/prototype` and capture the answer before continuing.
   - If conversation and repo evidence settle the source, continue.
3. Branch on persistence:
   - Multi-session or multi-slice work: `/to-prd` then `/to-issues`.
   - One bounded slice: implement directly with `/tdd` where useful.
4. For generated issue sets, run `/do-issues` one runnable AFK issue at a time.
5. Validate with the relevant review loop: `/code-review`, `/qa-run`,
   `/security-review`, or `/ship`.

## Common On-Ramps

- Bug report or broken behavior: `/diagnosing-bugs`, then `/tdd` for the fix.
- Unclear code ownership or call paths: `/zoom-out` or `/deep-code-trace`.
- Architecture concern: `/codebase-design`; for broad health work, use
  `/improve-codebase-architecture`.
- PRD, issue, or test-plan quality concern: `/alignment-review`.
- Need a fresh session: `/handoff` for conversation state, or
  `/context-resume` when durable project artifacts already exist.
- New or changed skill: `/write-a-skill`, then `/skill-review`.
- New project harness: `/setup-project-harness`.

## Context Hygiene

Keep discovery, grilling, PRD synthesis, and issue slicing in one coherent
context window when practical. Once issues exist, prefer a fresh context per
issue so implementation stays focused on one vertical slice.

Use `/handoff` when crossing sessions and the next agent needs conversation
state. Use durable artifacts such as PRDs, issues, ADRs, and test plans when the
work should survive more than one session.

## Output

Return:

- recommended first skill
- why it fits
- optional next skills, only as conditional branches
- any missing setup or user-owned decision that blocks the route
