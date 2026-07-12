# AGENTS.md Template

Stable shape for generated `AGENTS.md`. **Wiring + mistakes only** — not a coding
constitution. Prefer empty-rewrite over accretion. Put detail in `docs/agents/`
and (only when failure-driven) `.agents/rules/`.

Do **not** paste generic best practices (small diffs, security, a11y, reuse
stdlib). Models already do those. Add permanent lines only when:

1. the repo proved a fact the model cannot infer (tracker, route, exact command), or
2. the model already failed here and the fix is a short, checkable checklist item.

```markdown
# AGENTS.md

[One sentence: what this repo is, main stack, and workspace shape.]

## Route

- **LIGHT (default):** clear bug/AC → `/implement`; multi-slice → `/to-spec` → `/to-tickets` → `/implement`; same-session pin → `/grilling`; mild coding intent gap → `/product-fog`; multi-session eng fog → `/wayfinder` (prefer grill first).
- **HEAVY:** fuzzy product need → full PM (`wen-pm` `/pm-intake` or team process) first. Never invent Expected, user value, or market bets.
- Durable work lives in specs, tickets, or Wayfinder maps — not session todos.

## Wiring

- Tracker / labels / domain: `docs/agents/issue-tracker.md`, `triage-labels.md`, `domain.md`
- Domain habit: when terms matter, read `CONTEXT.md` / `docs/adr/` (see `docs/agents/domain.md`). On conflict, ask. When a term or hard-to-reverse decision crystallizes, update glossary/ADR inline — no invented language, no batch-at-end dumps.
- Project constraints: `.agents/rules/**` (read only when the edit matches)
- Keep this file short. Permanent instructions depreciate — prune what the current model already does.

## Mistakes

Failure-driven only. Add a line when the model already failed here and will likely fail again; delete when a newer model no longer trips. Prefer a checkable command or a hard forbid.

- [ ] [empty at setup — fill from real failures only]

## Commands

[List only exact commands proven by repo evidence or supplied by the user.
If none: "No package/build/test commands are configured."]
```

## Section notes

| Section | Purpose | Default |
| --- | --- | --- |
| Identity | One-line project fact | Always |
| Route | Wen pack product boundary (not general coding advice) | Always when this pack is installed |
| Wiring | Pointers skills hard-depend on | Always; no prose essays |
| Mistakes | Error notebook / checklist | Empty at setup; grow from failures only |
| Commands | Exact prove-work commands | Proven only; omit inventing |

Omit a long `## References` list — link paths inside Wiring/Route when needed.
When `triage` is not installed, omit `triage-labels.md` from Wiring.
