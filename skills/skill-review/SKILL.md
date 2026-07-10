---
name: skill-review
description: Reviews SKILL.md files for discovery, trigger clarity, progressive disclosure, and agent judgment.
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
- **Invocation**: user-invoked orchestration carries `disable-model-invocation: true`; model-invoked disciplines have a concrete autonomous trigger and do not open a new shared workflow on their own.
- **Shape**: treat `SKILL.md` length as a signal, not a verdict. Keep core workflow in `SKILL.md`; move templates, examples, schemas, and rarely needed detail to one-level sibling references.
- **Progressive disclosure**: skills load in three layers — metadata (name + description, always in context) → SKILL.md body (loaded on trigger) → references/scripts/assets (loaded only when needed). For each layer ask: does the body carry the minimum useful context for one run, with detail blocks (templates, schemas, large examples) extracted rather than inline? Does every reference link say *when* to read it, not just what it is? For multi-domain skills, is each domain its own reference file so only the relevant one loads? Are scripts reserved for deterministic repeatable work that prose alone does less reliably? For reference files over ~300 lines, is there a table of contents?
- **Judgment**: rules guide the agent without replacing reasoning, taste, or user-owned decisions.
- **User bridge**: the skill helps the agent ask, recommend, and clarify instead of silently assuming.
- **Evidence**: instructions tell the agent to read repo/files before making claims or edits.
- **Outputs**: the skill says what artifact, decision, review, or action should result.
- **Side effects**: every mutation stays inside explicit or already-authorized scope. Model-invoked research/prototype skills are evidence-only and leave trackers, canonical plans, manifests, deployments, external systems, and production behavior unchanged. Code-editing disciplines carry their own verification plus rollback or behavior-preservation boundary. Destructive or high-impact work requires explicit user authority.
- **Structure**: frontmatter is valid, references are one level deep, scripts are only for deterministic repeated work.
- **Language**: concise English, active verbs, no generic best-practice dumps.

### 3. Report

Return findings first, ordered by severity. Use this format for each finding:

```markdown
### <severity>: <one-line summary>

- **Check area**: <which check from step 2 triggered this>
- **Location**: `path/to/file:line`
- **Problem**: <what is wrong>
- **Why it matters**: <how it affects skill behavior>
- **Fix**: <smallest suggested change>
```

Then add:
- what already works well
- whether the skill is acceptable as-is
- optional tightening edits if the user asked for implementation

If there are no material issues, say so clearly and mention any residual risk.

### 4. Fix

Only edit when the user asked you to fix or improve the skill. Keep edits small. Preserve the author's intent unless it conflicts with discovery, trigger clarity, progressive disclosure, or judgment-preserving guidance.
