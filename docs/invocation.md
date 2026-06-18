# Skill Invocation

Skills split on one operational axis: who is allowed to reach them.

## User-Invoked Skills

User-invoked skills are orchestration surfaces. They should run only when the
human names them, because they usually choose a workflow, write durable
artifacts, change issue state, or coordinate multiple skills.

Use `disable-model-invocation: true` in frontmatter.

For user-invoked skills, the `description:` is human-facing:

- summarize the command in one short sentence
- do not spend words on trigger lists
- prefer route language: "Ask which WEN skill or flow fits the situation"

## Model-Invoked Skills

Model-invoked skills are reusable disciplines. The model may reach for them
autonomously when the task matches, and user-invoked skills may load them as
shared practice.

Omit `disable-model-invocation` in frontmatter.

For model-invoked skills, the `description:` is model-facing:

- state what the skill does
- include concrete trigger words the model can match
- keep it short enough to avoid permanent context load

## Dependency Pointers

Point to another skill by prose invocation, such as "load `/tdd`". Do not link
deeply into another skill's private reference files. Shared reference either
lives in the skill that owns the discipline or in a plain docs file outside the
skill tree.

## Setup Dependencies

Some skills depend on repo harness configuration seeded by
`/setup-project-harness`.

- **Hard dependency**: the skill cannot work correctly without configured issue
  tracker, triage labels, or domain layout. Say so explicitly.
- **Soft dependency**: the skill becomes sharper with glossary or ADR context
  but still works without it. Mention project context naturally instead of
  adding a setup gate.

This keeps setup pointers load-bearing instead of decorative.
