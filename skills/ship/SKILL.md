---
name: ship
description: Judges release readiness and drafts version, release notes, and rollback plan. Use before a release or to gate a merge.
disable-model-invocation: true
---

# Ship

Judge whether a release is ready, then draft the version bump, release notes, and
rollback plan. This is the release gate: it consumes evidence from review and QA
and returns a go / no-go decision. It does not build, deploy, or sign artifacts —
that is CI and the deploy pipeline's job.

Every recommendation is report-only. Shipping decisions, rollback boundaries, and
version policy belong to the user; this skill assembles evidence and a
recommendation, it does not push the button.

Use `/deep-code-trace` only when release readiness depends on exact behavior (for
example, whether a data migration is expand-contract compatible).

## What Is Out Of Scope

- **Building, deploying, and signing artifacts.** CI and the deploy pipeline do
  this; read their status, do not run them.
- **Changing version policy.** Follow the project's existing versioning
  convention. Propose the next version; do not impose a new scheme.

## 1. Establish The Release Target

Default the target to all changes since the last release tag. Accept a named
milestone, branch, tag, or PRD when the user provides one.

List the changeset: commits, merged PRs, and closed issues since the last tag.

## 2. Release Readiness Gate (judgment)

Read gate rules from `/setup-project-harness` output when present, then collect
evidence for each gate:

- `/code-review`: no unresolved high or critical findings
- `/qa-run`: verdict is `Ship` or `Ship With Known Risk`
- `/security-review`: no unresolved critical findings
- build and tests: green

Mark any gate missing, unknown, or unconfigured explicitly. Do not treat silence
as passing. Record accepted known risks separately from blockers.

Return a verdict:

- `Go` — all gates pass or only accepted known risks remain
- `No-Go` — list each blocking gate and its evidence

## 3. Release Artifact (draft)

1. **Next version:** propose the bump from the changeset under the project's
   existing version convention (semantic, calendar, or other). State the rule you
   applied.
2. **Release notes:** separate user-facing changes from internal changes. Surface
   breaking changes, required migrations, and behavior changes prominently.
3. **Rollback plan:** state which changes are reversible, the rollback boundary,
   and whether data migrations are expand-contract compatible. Flag anything that
   cannot be rolled back.

## 4. Report

Lead with the verdict. Then:

```markdown
### Release: <next version>

- **Readiness**: <gate-by-gate evidence>
- **Release notes**: <user-facing / internal / breaking>
- **Rollback**: <reversible scope, boundary, migration compatibility>
- **Open decisions**: <user-owned: actual publish, deploy, sign>
```

## Related Skills

- `/code-review` — provides a gate signal
- `/qa-run` — provides a ship verdict signal
- `/security-review` — provides a critical-findings signal
- `/setup-project-harness` — configures the gate rules and release tooling

Use any, in any order; this skill prescribes no sequence.
