# AGENTS.md

WEN Engineering Skills pack. Optional: `wen-pm` / `wen-test`.

## Code is the environment

> **The code is the environment your agent runs in.**

Every skill, grill, ticket, and review in this pack must uphold that:

- **Authoritative now:** production code, tests, open tracker items, short invariants — not closed process notes or month-old decision docs.
- **Act inside the environment:** prefer existing wire values, APIs, enums, and identity patterns; treat dangerous legacy as **do-not-copy**, never as a template to spread.
- **Environment change is explicit:** renaming protocols, relaxing isolation, silent identity fallbacks → only when the user asks for a migration, not as “cleaner” drive-by design.
- **Process docs are scaffolding:** same-session work defaults to chat; durable archives only for real handoff. After consume/close, do not reload them as law; never invent paperwork for thoroughness.
- **Conflicts:** code wins over stale docs — resolve from the repo, do not interview the user to pick “which document.”

Routing and hygiene detail: `docs/lifecycle.md` (Environment and artifact hygiene).

## Wiring

- Tracker / labels / domain: `docs/agents/`
- Subagents: `agents/` Executor · Reviewer · Verifier — try then fall back (`agents/README.md`)

## Source of truth → install (do not edit live agent dirs)

- **Canonical source is this repo** (`skills/`, `agents/`, `docs/`, root `AGENTS.md`, etc.). Prefer editing here so changes are reviewable and versioned.
- **After edits, install/sync to the machine** so Codex / Claude / ZCode / Kimi pick them up, e.g.:
  - full install: `./scripts/sync-skills.sh --agents all`
  - live-edit checkout: `./scripts/sync-skills.sh --agents all --mode link`
- **Do not edit `~/.agents/**` or `~/.zcode/**` (or other agent skill roots) as the primary change.** Those are install targets (copy or symlink). Patching them directly skips git, drifts from this pack, and is easy to lose on the next sync.
- Exception: purely local, non-pack user skills that this repo does not own — still never “fix pack bugs” only under `~`.

## Checklist

- [ ] After skill edits: frontmatter, description length, one-level refs, README/index
- [ ] After skill/agent pack edits: sync/install to the machine (`scripts/sync-skills.sh`), not hand-edit `~/.agents` / `~/.zcode`
