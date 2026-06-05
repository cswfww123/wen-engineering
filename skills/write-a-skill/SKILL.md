---
name: write-a-skill
description: Creates agent skills with structure and progressive disclosure. Use when creating or improving SKILL.md files.
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
description line: Brief capability. Use when specific triggers appear.
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

The description is the only thing an agent sees when deciding whether to load the skill. Goal:

- state the capability
- include concrete triggers
- stay short, ideally under 120 characters and never padded past 180

- Format: third person
- first sentence says what it does
- second sentence starts with "Use when..."

## When To Add Scripts

Add scripts when:

- the operation is deterministic
- the same code would be generated repeatedly
- errors need explicit handling

## When To Split Files

Split files when:

- `SKILL.md` would exceed about 100 lines
- content has distinct domains
- advanced details are rarely needed

## Review Checklist

- description includes triggers
- `SKILL.md` is under 100 lines unless it is a strict setup skill
- no time-sensitive claims
- terminology is consistent
- references are one level deep
