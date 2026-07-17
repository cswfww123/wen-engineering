# AGENTS.md

WEN Engineering Skills pack. Optional: `wen-pm` / `wen-test`.

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
