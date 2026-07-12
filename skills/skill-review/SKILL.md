---
name: skill-review
description: Review a SKILL.md for discovery, triggers, progressive disclosure, and judgment.
disable-model-invocation: true
---

# Skill Review

Review a skill like an engineering artifact: short, useful, triggerable, and a bridge between user intent, repo evidence, and agent judgment.

## Process

### 1. Read

Read the target `SKILL.md`, linked sibling references/scripts, this repo's `README.md`, and related skills when they set local precedent.

### 2. Check

In order:

- **Description**: under 120 preferred, never past 180; states what and when.
- **Trigger / invocation**: model-invoked needs concrete trigger words and must not open a new shared workflow; user-invoked carries `disable-model-invocation: true` and a human-facing description.
- **Progressive disclosure**: metadata always → body on trigger → references only when needed. Body holds core workflow; templates/schemas/examples in one-level siblings with *when to read* pointers. Multi-domain → separate references. Scripts only for deterministic work prose cannot match.
- **Judgment / user bridge**: guide without replacing reasoning; ask/clarify instead of silent assumption.
- **Evidence / outputs**: read repo before claims/edits; name the resulting artifact, decision, review, or action.
- **Side effects**: mutations stay in authorized scope. Research/prototype are evidence-only (no tracker/canonical/deploy/production mutation). Code disciplines verify + rollback or behavior-preservation. Destructive work needs explicit authority.
- **Structure / language**: valid frontmatter; one-level references; concise English; no generic best-practice dumps or no-ops the current model already obeys.


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
