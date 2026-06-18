# Skill Quality

Use this reference when writing or reviewing a skill.

## Predictability

A good skill makes the agent follow the same process across runs while still
leaving room for different outputs. Optimize for repeatable behavior, not rigid
wording.

## Invocation Load

Every model-invoked skill spends context through its description. Every
user-invoked skill spends human memory because the user must know it exists.

Choose model invocation only when autonomous discovery or cross-skill reuse is
worth the permanent context load. Choose user invocation when human intent or
side effects should control the run.

See `docs/invocation.md` for the repository-wide boundary.

## Completion Criteria

Each workflow step should end with a checkable done condition. Weak criteria
invite premature completion; strong criteria force the right legwork.

Prefer:

- "every modified public behavior has a passing test"
- "the issue contains exact verification commands and results"
- "the glossary term is updated inline once confirmed"

Avoid:

- "be thorough"
- "make it good"
- "consider edge cases"

## No-Op Test

Delete instructions that do not change model behavior. A line is a no-op if the
agent would almost certainly do it anyway or if it repeats another line's
meaning with weaker words.

## Progressive Disclosure

Keep the run-critical path in `SKILL.md`. Move templates, examples, schemas, and
branch-specific detail into sibling files with clear pointers that say when to
read them.
