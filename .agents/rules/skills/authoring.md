# Skill Authoring

Applies to: `skills/**/SKILL.md` and sibling reference files
Source: `README.md`, `docs/invocation.md`, `/writing-great-skills`, `skills/setup-project-harness/SKILL.md`, `skills/skill-review/SKILL.md`

## Rules

- [MUST] Keep each skill focused on one capability or workflow.
- [MUST] Choose the invocation boundary before writing: user-invoked orchestration or model-invoked discipline.
- [MUST] Write a short `description:`; target 120 characters or less.
- [MUST] For model-invoked skills, include concrete trigger words in the description instead of long lists of loosely related cases.
- [SHOULD] For user-invoked skills, keep the description human-facing and omit trigger lists unless they help command browsing.
- [MUST] Mark shared orchestration, canonical publication, tracker-state changes, or broad working-tree loops with `disable-model-invocation: true`.
- [MUST] Limit model-invoked side effects to bounded, reversible changes inside an explicit request or active authorized orchestration. They must not start a shared workflow or mutate trackers, relationships, canonical plans, manifests, deployments, or external systems outside that authority.
- [MUST] Keep model-invoked research/prototype disciplines evidence-only. Code disciplines may edit only the already-authorized code scope and must carry their own verification, behavior-preservation, and rollback contracts.
- [SHOULD] Keep ordinary `SKILL.md` files around 100 lines. Treat longer files as a prompt to move rarely needed detail into one-level references, not as a failure by itself.
- [MUST] Preserve complete mandatory flow in strict setup/init skills such as `setup-project-harness`; do not shrink them just to satisfy line count.
- [SHOULD] Use progressive disclosure: put templates, examples, and rarely needed details in one-level sibling references.
- [SHOULD] Preserve agent judgment; skills should guide, ask, recommend, and verify rather than replace reasoning with rigid forms.
- [SHOULD] Use concise English, active verbs, and operational instruction density.
- [SHOULD] Use hard setup pointers only when the skill cannot work correctly without `/setup-project-harness` output.
- [SHOULD] Make evidence support disciplines return the artifact path and keep/delete/promote disposition; the user-invoked caller owns publication or closure.
- [FORBID] Generic best-practice dumps, repeated philosophy, or rules that restate normal LLM competence.

## Verify

- `wc -l skills/*/SKILL.md` as an advisory check; longer files should trigger a progressive-disclosure review, not automatic failure.
- Check each `description:` is short, specific, and triggerable.
- Confirm user-invoked and model-invoked skills follow `docs/invocation.md`.
- Confirm linked references exist and are one level deep.

## Exceptions

- Ordinary skills may exceed the line-count target when the core workflow itself must be loaded every time.
- Strict setup/init skills may be longer when they must encode mandatory decisions, draft gates, write steps, and verification.
- Deterministic repeated operations may use `scripts/`, but only when instructions alone would be less reliable.
