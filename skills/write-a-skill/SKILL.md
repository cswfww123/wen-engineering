---
name: write-a-skill
description: Create or improve agent skills with structure and progressive disclosure.
disable-model-invocation: true
---

# Writing Skills

Create a new agent skill with proper structure, progressive disclosure, and bundled resources.

## Process

### 1. Gather Requirements

Ask only when the answer is not already clear:

- What task or domain does the skill cover?
- What use cases should it handle?
- Does it need executable scripts or just instructions?
- Are there reference materials to include?

### 2. Draft The Skill

Create:

- `SKILL.md` with concise instructions
- one-level reference files when detail would bloat `SKILL.md`
- utility scripts only for deterministic repeated operations

Before drafting, choose the invocation boundary using `docs/invocation.md`:

- user-invoked for orchestration, durable artifacts, issue-state changes, or
  high-impact side effects
- model-invoked for reusable disciplines the agent should reach for
  autonomously

## Skill Structure

```text
skill-name/
  SKILL.md
  REFERENCE.md
  EXAMPLES.md
  scripts/
    helper.js
```

## SKILL.md Template

```md
---
name: skill-name
description: Brief capability or human-facing command summary.
---

# Skill Name

## Quick Start

Minimal working example.

## Workflow

Step-by-step process.

## References

See sibling reference files when needed.
```

## Description Requirements

Descriptions have different jobs by invocation type:

- **Model-invoked**: the description is the only thing an agent sees when
  deciding whether to load the skill.
- **User-invoked**: the description is a human-facing command summary because
  the model should not auto-select it.

For model-invoked skills, the goal is:

- state the capability
- include concrete triggers
- stay short, ideally under 120 characters and never padded past 180

- Format: third person
- first sentence says what it does
- second sentence starts with "Use when..."

For user-invoked skills, keep the description shorter:

- state what the command does
- omit trigger lists unless they help a human choose the command
- set `disable-model-invocation: true`

Good description values:

```markdown
Reviews diffs for standards, correctness, performance, security, and shape. Use for WIP or PR reviews.
Runs QA cases and judges completion. Use after code-review, bug fixes, smoke, regression, or QA.
Writes a compact handoff for a fresh agent. Use when handing off, compacting context, or preparing a new session.
Ask which WEN skill or flow fits the situation.
```

Bad description values:

```markdown
Helps with code review (too vague, no triggers)
A comprehensive tool for reviewing your code changes, pull requests, and diffs with multiple analysis axes and reporting capabilities (too long, padded, no triggers)
Use for review (says when but not what)
```

## When To Add Scripts

Add scripts when:

- the operation is deterministic
- the same code would be generated repeatedly
- errors need explicit handling

## When To Split Files

Split files when:

- `SKILL.md` mixes always-needed workflow with rarely needed detail
- content has distinct domains
- advanced details are rarely needed

## Review Checklist

- description includes triggers
- `SKILL.md` is concise enough to load, with reference detail split out when useful
- no time-sensitive claims
- terminology is consistent
- references are one level deep
- invocation boundary is correct for side effects
- quality issues from [QUALITY.md](QUALITY.md) have been checked
