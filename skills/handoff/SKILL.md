---
name: handoff
description: Writes a compact handoff for a fresh agent. Use when handing off, compacting context, or preparing a new session.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

# Handoff

Write a handoff document summarizing the current conversation so a fresh agent can continue the work.

Save it to the OS temp directory, not the current workspace.

Resolve temp dir from `$TMPDIR`, then `/tmp`, or `%TEMP%` on Windows. Write to:

```text
<tmpdir>/handoff-<timestamp>.md
```

Open it for the user and provide the absolute path.

## Content

Do not duplicate content already captured in PRDs, plans, ADRs, issues, commits, or diffs. Reference those artifacts by path or URL instead.

Redact sensitive information such as API keys, passwords, tokens, and personally identifiable information.

If the user passed arguments, treat them as the next session focus and tailor the document accordingly.

## Output Template

```markdown
# Handoff

## Objective

<One sentence: what was being built, fixed, or discussed.>

## Repo Context

- **Branch**: <name>
- **Recent commits**: <2-3 most relevant, with short hash and message>
- **Changed files**: <list only files modified in this session>

## Decisions Made

- <Decisions locked in this session, with rationale. Skip if none.>
- Reference existing PRDs/ADRs/issues by path, do not repeat their content.

## Open Questions And Blockers

- <Unresolved questions that the next agent needs to know about. Skip if none.>

## Verification Already Run

- <Exact commands and results. "None" if nothing was run.>

## Recommended Next Step

<One concrete action the next agent should take.>

## Suggested Skills

- `<skill-name>` — <why>
```

## Size Guidance

Target under 1500 words. If the handoff exceeds that, the session probably covered too much — narrow the scope and suggest the user invoke `/handoff` once per work area.
