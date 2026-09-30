# Skill Invocation

Skills split on one operational axis: who is allowed to reach them.

## User-Invoked Skills

User-invoked skills are orchestration surfaces. They should run only when the
human names them — or when the agent enters one via documented **entry
classification** (below) — because they choose a shared workflow, publish
canonical artifacts, change tracker state, or coordinate multiple skills.

Use `disable-model-invocation: true` in frontmatter.

## Agent entry classification

Entry routing is **agent-owned** ([LIFECYCLE.md](../skills/ask-process/LIFECYCLE.md) hygiene 7): when
work arrives without a named command, the agent classifies it (bug →
`/diagnosing-bugs`; fuzzy product → HEAVY gate; clear AC / one slice →
`/implement`; otherwise → `/grill-code`) and enters the matching flow by
loading its `SKILL.md` and following it. This is documented router behavior,
not hidden cross-invocation. User-typed slash commands are manual overrides,
not the only door. Mid-flow hops still wait for the user's order — an
agent-entered flow has the same close gates and side-effect limits as a
user-typed one. In a target repo the always-loaded carrier of this rule is the
`### Work routing` line `/setup-project` writes into the `## Agent skills` block.

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

Model-invoked disciplines may act only inside an explicit request or an active
user-invoked orchestration that already authorized the scope. Their changes
must be bounded, reversible, and covered by the discipline's own verification
or disposition contract. They cannot start a new shared workflow or mutate
tracker state, relationships, canonical planning artifacts, manifests,
deployments, or external systems merely because their trigger matches.

Evidence-only disciplines such as `/research` and `/prototype` must also leave
existing production behavior unchanged and report the artifact path plus a
`keep`, `delete`, or `promote` recommendation. The caller owns publication and
closure. Code disciplines such as `/tdd`, `/simplify`, and `/code-review` may
edit only the already-authorized code-change scope and must obey their test,
behavior-preservation, and rollback contracts.

A request to diagnose, debug, or explain a failure authorizes inspection and
disposable evidence, not tracked production edits. `/diagnosing-bugs` may enter
its fix branch only for an explicit fix request or an already-authorized code
scope; a named non-runnable bug report still requires user-invoked conversion
before production work.

## Dependency Pointers

Point to another skill by prose invocation, such as "load `/tdd`". Do not link
deeply into another skill's private reference files. Shared reference either
lives in the skill that owns the discipline or in a plain docs file outside the
skill tree.

A user-invoked orchestration may load a model-invoked discipline as a quality
or evidence step. It must not silently start another user-invoked orchestration.
It may write its own minimal temporary continuation artifact when required for
safety, but naming that artifact a `/handoff` does not invoke the user-only
skill.

## Setup Dependencies

Some skills depend on repo harness configuration seeded by
`/setup-project`.

- **Hard dependency**: the skill cannot work correctly without configured issue
  tracker, triage labels, or domain layout. Say so explicitly.
- **Soft dependency**: the skill becomes sharper with glossary or ADR context
  but still works without it. Mention project context naturally instead of
  adding a setup gate.

Logging **foundation** is a separate setup surface: `/setup-logging`. Harness
classifies the observability bar; foundation construction is not harness work.
Integration-heavy implement work soft-depends on foundation (report
`foundation-missing` rather than shipping quiet paths).

This keeps setup pointers load-bearing instead of decorative.
