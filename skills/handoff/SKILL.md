---
name: handoff
description: Writes a compact handoff for a fresh agent. Use when handing off, compacting context, or preparing a new session.
argument-hint: "What will the next session be used for?"
disable-model-invocation: true
---

# Handoff

Write a handoff document summarizing the current conversation so a fresh agent can continue the work.

Save it to the OS temp directory, not the current workspace.

Include:

- current objective
- repo and branch context
- changed files or artifacts
- decisions already captured elsewhere
- open questions and blockers
- exact verification already run
- recommended next step
- suggested skills for the next agent

Do not duplicate content already captured in PRDs, plans, ADRs, issues, commits, or diffs. Reference those artifacts by path or URL instead.

Redact sensitive information such as API keys, passwords, tokens, and personally identifiable information.

If the user passed arguments, treat them as the next session focus and tailor the document accordingly.
