# AGENTS.md Template

Use this as the stable shape for generated `AGENTS.md` files. Keep only facts
and boundaries the model cannot safely infer. Put detail in `.agents/rules/`
and `docs/agents/`.

```markdown
# AGENTS.md

This repo uses agents for real engineering work. Keep changes small, boring,
reversible, and grounded in repo evidence.

## Project

[One sentence: what this repo is, main stack, and workspace shape.]

## Rules

- Make the smallest sufficient change: reuse platform behavior, standard library, and existing code before adding new code.
- Do not add abstractions, dependencies, files, workflows, or rule directories without repo evidence or user direction.
- Keep `AGENTS.md` short; put detailed standards in `.agents/rules/**`.
- Read the relevant `.agents/rules/**` file before editing matching work.
- Record only exact commands proven by repo evidence or supplied by the user.
- Send clear bounded work directly to `/implement`; it needs no invented spec or ticket.
- Route settled multi-slice work through `/to-spec` then `/to-tickets`.
- Use technical `/wayfinder` only when product intent is settled (or work is
  pure engineering) and multi-session technical fog remains; send product,
  market, or need discovery to the team's product process (optional `/pm-intake`
  if they use wen-pm), not Wayfinder. Scope FE/BE gates to the ticket layer.
- For tracked work, implement only an implementation-frontier ticket: open, `AFK`, unblocked, and unclaimed.
  Claim and resolve it through `docs/agents/issue-tracker.md`.
- Put deterministic lifecycle requirements in CI, hooks, or platform settings, not only in agent memory.
- Do not skip input validation, security, data-loss prevention, accessibility, or explicit user requirements.

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
