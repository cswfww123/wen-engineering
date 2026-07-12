# AGENTS.md Template

Use this as the stable shape for generated `AGENTS.md` files. Keep only facts
and boundaries the model cannot safely infer. Put detail in `.agents/rules/`
and `docs/agents/`.

```markdown
# AGENTS.md

[One sentence: what this repo is, main stack, and workspace shape.]

## Route

**LIGHT (default):** clear bug/AC → `/implement`; settled multi-slice → `/to-spec` → `/to-tickets` → `/implement`; same-session pin → `/grill-with-docs`; mild coding-adjacent intent gap → `/product-fog`; multi-session eng fog → `/wayfinder` (try grill first).

**HEAVY:** fuzzy product need (worth-doing, user, market, vague idea) → full PM (`wen-pm` `/pm-intake` or team process) before coding skills.

- Never invent Expected, user value, or market bets.
- Tracked work: only open, `AFK`, unblocked, unclaimed implementation-frontier tickets via `docs/agents/issue-tracker.md`.
- Scope FE/BE fidelity gates to the ticket layer.

## Rules

- Smallest sufficient change; reuse platform, stdlib, and existing code first.
- No new abstractions, dependencies, files, or workflows without repo evidence or user direction.
- Keep this file short; detail in `.agents/rules/**`. Read the relevant rule before matching edits.
- Record only exact commands proven by repo evidence or supplied by the user.
- Put deterministic lifecycle requirements in CI, hooks, or platform settings — not only agent memory.
- Do not skip input validation, security, data-loss prevention, accessibility, or explicit user requirements.
- Treat permanent instructions as depreciating: add guardrails from real failures; prune what current models already do.

## Commands

[List only exact commands proven by repo evidence. If none exist, write: "No package/build/test commands are configured."]

## References

- `docs/agents/issue-tracker.md`
- `docs/agents/triage-labels.md`
- `docs/agents/domain.md`
- `.agents/rules/**`
- `CONTEXT.md` or `CONTEXT-MAP.md`
- `docs/adr/`
```
