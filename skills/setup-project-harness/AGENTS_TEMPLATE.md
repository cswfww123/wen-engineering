# AGENTS.md Template

Stable shape for generated `AGENTS.md`. **Path wiring + optional checklist only** —
not a coding constitution, not a skill router, not a rules dump.

Prefer empty-rewrite over accretion. Failure pins go in Checklist; if a pin stays
green for a while on current models, remove it. Detail lives in docs/skills when
needed — not in the always-loaded entrypoint.

Do **not** paste generic best practices, skill pipelines, default shell commands,
or "read all rules" pointers. Add a line only when the repo proved a non-inferable
fact or a real failure needs a short checkable item.

```markdown
# AGENTS.md

[One sentence: what this repo is, main stack, and workspace shape.]

## Wiring

- Tracker / labels / domain: `docs/agents/`

## Checklist

- [ ] [omit this section when empty — add only from real failures; prune when stable]
```

## Section notes

| Section | Purpose | Default |
| --- | --- | --- |
| Identity | One-line project fact | Always |
| Wiring | Non-inferable path pointers only | Always if paths exist; no process essays |
| Checklist | Failure pins that change behavior | Omit when empty; prune when models stop tripping |

Omit `## Route`, `## Commands`, `## Mistakes`, `## Rules`, and long `## References`.
Commands belong in README / scripts / CI. Optional long boundaries (e.g. shared
mutable invariants) live under `.agents/rules/invariants/` only when failure-driven
and are discovered by matching skills — not listed as always-load constitution.
When `triage` is not installed, omit triage labels from Wiring.
