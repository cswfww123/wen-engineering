# AGENTS.md Template

Use this as the stable shape for generated `AGENTS.md` files. Keep the final file under 150 lines. Put detailed rules in `.agents/rules/`, not here.

```markdown
# AGENTS.md

This repository uses AI coding agents for real engineering work, not vibe coding. Use skills, progressive disclosure, project domain language, and judgment.

## Project Overview (Required)

[One precise sentence: what this project is, the main stack, and the package/workspace shape.]

## Core Directives

- **Plan first**: for non-trivial work, start with a concise bullet plan and unresolved questions. Follow this project's autonomy rule for whether to proceed immediately or wait for confirmation.
- **Persistent breakdowns**: use the session todo list only for tactical, same-session steps. When a task spans multiple vertical slices or outlives a session, route it to `/to-prd` then `/to-issues` so it lands in the issue tracker instead of dying with the session.
- **Use skills**: prefer available slash skills such as `/grill-with-docs`, `/diagnosing-bugs`, `/domain-modeling`, `/codebase-design`, `/to-prd`, `/to-issues`, `/do-issues`, `/tdd`, or project skills when they fit the task.
- **Progressive disclosure**: do not pack every rule into this file. Read only the relevant `.agents/rules/**`, `docs/**`, `CONTEXT.md`, and `skills/**` files before editing.
- **Domain language**: use established project terms from `CONTEXT.md` or docs. Avoid vague substitute terms.
- **Feedback loop**: run the relevant typecheck, lint, tests, and build before claiming completion. For bugs, use `/diagnosing-bugs`.
- **Code quality**: prefer simple, deep, maintainable modules. Before broad refactors, zoom out and map callers, boundaries, and ownership.
- **Judgment**: rules are guardrails. When evidence conflicts with a rule, stop, explain the conflict, and choose the smallest reversible path or ask the user.

## Development Commands

- Install: `[exact command]`
- Dev: `[exact command]`
- Typecheck: `[exact command]`
- Test: `[exact command]`
- Single test: `[exact command]`
- Build: `[exact command]`
- Lint: `[exact command]`

## Rule Index

Agents must read the relevant files under `.agents/rules/` before editing matching code.

- `.agents/rules/project/` — project identity, autonomy, dependency policy, workflow rules
- `.agents/rules/skills/` — skill authoring rules, if this is a skills repo
- `.agents/rules/typescript/` — TypeScript conventions, if present
- `.agents/rules/java/` — Java conventions, if present
- `.agents/rules/frontend/` — UI, state, styling, accessibility, visual QA
- `.agents/rules/backend/` — services, validation, auth, repositories, errors
- `.agents/rules/api/` — endpoint style, request/response contracts, status codes
- `.agents/rules/database/` — schema, table/column/index names, migrations, transactions
- `.agents/rules/testing/` — test strategy, fixtures, integration/e2e boundaries

## Engineering Practices

- **TDD when useful**: for new behavior and bug fixes, prefer red-green-refactor or first lock behavior with regression tests.
- **Small vertical slices**: make the smallest verifiable change, then iterate.
- **Documentation**: record major architectural decisions in `docs/adr/`. Keep `CONTEXT.md` aligned with domain language.
- **Self-improvement**: when a repeated mistake reveals a missing boundary, propose or add the smallest relevant rule.
- **Handoff**: for long tasks, create a concise handoff summary before stopping.

## Reference Files

- `CONTEXT.md` — domain language and core concepts
- `docs/**` — architecture, ADRs, specifications
- `skills/**` — project or engineering skills
- `.agents/rules/**` — detailed rules by language/domain
- `.claude/**` — Claude-specific hooks or local extensions, if present

Always do real engineering: align on intent, change in small verified steps, and let human taste plus agent judgment both do their best work.
```
