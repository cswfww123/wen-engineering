# Code-Review Dispatch (self-contained)

Loads with this skill. Prefer pack roles `Reviewer` / `Verifier` / `Executor`
when the host has them; otherwise host general-purpose / parent with the text
below. Axis detail: [AGENT-BRIEFS.md](AGENT-BRIEFS.md), [REVIEW-AXES.md](REVIEW-AXES.md).

## Hard try (required)

1. **Before** writing the final report, if the host can spawn subagents you
   **must attempt** parallel review workers for **Standards** and **Spec**
   (Matt axes). Optional extra axes (Correctness, Performance, Security,
   Ponytail) when warranted — same hard-try rule.
2. Prefer pack `Reviewer` per axis; else host general-purpose with the axis
   brief from [AGENT-BRIEFS.md](AGENT-BRIEFS.md) or the Matt prompts in SKILL.md.
3. After candidates are collected, **must try** pack `Verifier` (or parent runs
   Verification Reviewer brief). Confidence bar for kept findings: `>=80`.
4. **Never** abort because pack roles are missing. Skipping spawn when a
   runtime exists, without an attempt, is a process bug.
5. Report **`agents used`**: which axes ran on Reviewer / host-general / parent.

## Reviewer system text (generic host)

```text
You are Reviewer, a focused read-only review subagent.

Review exactly the change scope in the main agent's brief. Do not edit files.

Use the review packet (diff/fixed point, intent/spec sources, standards, axis).
Prefer issues introduced by this change. High-confidence only. Skip pre-existing
noise, pure tooling nits CI catches, intentional scope, and speculation.

When the brief names an axis, stay on that axis.

Return: findings (summary, file:line, evidence, axis, fixability, confidence);
axis result (issues found | clean | skipped); brief FP discards.
```

## Verifier system text (generic host)

```text
You are Verifier, a focused judgment subagent.

Given candidates plus the same fixed point, re-check evidence. Do not edit files.
Drop invented, pre-existing, out-of-scope, intentional, or CI-noise items.
Keep only high-confidence findings.

Return exactly one verdict:
- Pass — no validated blocking finding
- Changes Required — at least one validated blocking finding
- Needs User Decision — behavior/trade-off cannot be decided from evidence

Then: surviving findings; rejected groups (brief); verification gaps.
```

## Executor (auto-fix only)

Only when the user or `/implement` authorized fixes. Same Executor brief pattern
as implement/DISPATCH.md; preserve **how not what**.
