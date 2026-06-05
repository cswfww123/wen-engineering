---
name: skill-review
description: Review SKILL.md files for short descriptions, trigger clarity, brevity, and agent judgment.
---

# Skill Review

Review a skill like an engineering artifact.

The goal is not to make every skill follow one rigid template. The goal is to keep skills short, useful, triggerable, and aligned with this repo's belief that skills are bridges between user intent, repo evidence, and LLM judgment.

## Process

### 1. Read

Read only what matters:

- the target `SKILL.md`
- sibling reference files, examples, or scripts if the skill links to them
- this repo's `README.md`
- related existing skills when they set local precedent

Do not review from memory when the files are available.

### 2. Check

Look for issues in this order:

- **Description**: short enough for discovery, usually under 120 characters and never padded past 180. It says what the skill does and when to use it.
- **Trigger**: the description contains concrete trigger words an agent can match, not a long list of loosely related cases.
- **Brevity**: `SKILL.md` should usually stay under 100 lines. Move rarely needed detail to one-level reference files.
- **Progressive disclosure**: the skill loads the minimum useful context first, then points to detail only when needed.
- **Judgment**: rules guide the agent without replacing reasoning, taste, or user-owned decisions.
- **User bridge**: the skill helps the agent ask, recommend, and clarify instead of silently assuming.
- **Evidence**: instructions tell the agent to read repo/files before making claims or edits.
- **Outputs**: the skill says what artifact, decision, review, or action should result.
- **Side effects**: destructive or high-impact workflows require explicit user trigger or confirmation.
- **Structure**: frontmatter is valid, references are one level deep, scripts are only for deterministic repeated work.
- **Language**: concise English, active verbs, no generic best-practice dumps.

### 3. Report

Return findings first, ordered by severity. Use file and line references when possible.

For each finding, include:

- the problem
- why it matters for this skill's behavior
- the smallest suggested fix

Then add:

- what already works well
- whether the skill is acceptable as-is
- optional tightening edits if the user asked for implementation

If there are no material issues, say so clearly and mention any residual risk.

### 4. Fix

Only edit when the user asked you to fix or improve the skill. Keep edits small. Preserve the author's intent unless it conflicts with trigger clarity, brevity, or judgment-preserving guidance.
