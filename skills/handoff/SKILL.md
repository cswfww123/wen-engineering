---
name: handoff
description: Write a compact handoff for a fresh agent.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

# Handoff

Write a compact handoff so a fresh agent can continue. Save under OS temp
(`$TMPDIR` / `/tmp` / `%TEMP%`): `<tmpdir>/handoff-<timestamp>.md`. Open it and
return the absolute path.

User arguments = next-session focus. **Reference** specs, tickets, maps, ADRs,
commits, diffs by path/URL — do not restate them. Redact secrets and PII.
Target **under 1500 words**.

## Fields

```markdown
# Handoff
## Objective          # one sentence
## Repo Context       # branch, 2–3 commits, session-changed files
## Decisions Made     # session-only; else skip
## Open Questions     # blockers for next agent; else skip
## Verification Run   # exact commands + results, or None
## Recommended Next Step
## Suggested Skills   # skill — why
```
