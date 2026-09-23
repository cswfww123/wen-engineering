---
name: harvest-pins
description: Harvest and depreciate AGENTS.md Checklist pins from real agent sessions.
disable-model-invocation: true
---

# Harvest Pins

Close the pin loop: real sessions are the loss signal, Checklist pins are the
trainable slice, Wiring stays frozen. One run is one small step. Analysis
never writes; the user accepts a draft first.

Do **not** wrap backpass. Do **not** train this pack's product `AGENTS.md`
policy from sessions. Do **not** run at empty-project setup — that is
`/setup-project`.

## Output contract

- Distilled session corpus under `.scratch/harvest-pins/` (local; do not commit)
- A proposal of at most **five** edits: ADD / REMOVE / REWRITE a Checklist pin,
  or EXTRACT a narrow procedure into a project skill
- After accept: the smallest `AGENTS.md` (and optional skill) patch that the
  proposal named — never a rewrite of the file

## Start gate

1. `test -f AGENTS.md` — if missing, stop and point at `/setup-project`.
2. Run the sibling distill script against **this repo cwd**. Use the `SKILL.md`
   directory you loaded:

```bash
python3 <skill-dir>/scripts/distill.py --repo "$(pwd)" --since 90d --max-sessions 20 --budget 1200
```

3. Read the printed JSON, then `index.json`. **Do not** open raw `*.jsonl`
   transcripts. If `sessions` is 0, stop: no loss signal, invent no pins.

If `AGENTS.md` is this pack's own file (WEN Engineering Skills pack / canonical
source → install), warn once: freeze **all** policy prose; only a Checklist
that evidence actually supports may change.

## Freeze vs trainable

| Zone | Edit? |
| --- | --- |
| Identity one-liner, `## Wiring`, `docs/agents/` pointers, invariants / PRD / same-surface pointers | **No** REMOVE or REWRITE |
| `## Checklist` pins | Yes, evidence-gated |
| Missing `## Checklist` | May ADD the section (counts as one of the five) |
| Narrow repeatable procedure with a one-line trigger | EXTRACT → project skill, not a pin |
| Trigger cannot be named | deletion candidate — stay out of always-loaded |

A long classifier still belongs in `.agents/rules/` via harness, not here.

## Evidence gates (mechanical — fail the run if broken)

- Every proposed edit carries a **verbatim quote** copied from a distilled
  session file. Quoteless claims are discarded, not softened.
- **ADD** (new pin or new skill body) needs **two independent sessions**.
  One accident stays a note, not a pin.
- **REMOVE** only when the pin never mattered in this corpus **and** it is not
  a correctness / safety / `[MUST]` / invariants pin. Low frequency is not
  deletion.
- At most **five** edits. No whole-file rewrite. No silent APPLY.
- Always-loaded budget **1200** estimated tokens (`bytes/4`). If the file is
  at or over cap, every ADD names the REMOVE or EXTRACT that pays for it.
  Recheck with `python3 <skill-dir>/scripts/distill.py --measure AGENTS.md`
  on the draft.
- Rejected proposals are not re-offered without new session ids.

## Pin placement

| Signal | Destination |
| --- | --- |
| Broad (≥ ~20% of kept sessions) or safety-critical; trigger fits a checkbox | Checklist |
| Narrow; trigger fits one skill `description` line | EXTRACT skill |
| Neither | do not load it every turn |

Wording: load `/writing-for-agents` only when drafting pin text or a skill
description. Pins are checkable, positive, and not model-default competence.
Skill descriptions are the trigger (pointer), not a second constitution.

EXTRACT default path: `.agents/skills/<name>/SKILL.md` unless the repo already
owns another project-skill root. After accept, `/skill-review` the new skill.

## Workflow

1. **Distill** — start gate command. Missing harness stores are warnings, not
   errors. Prefer `--strict` only when git-remote fallback would mix repos.
2. **Read corpus** — `index.json` first. Then distilled `sessions/*.md`, newest
   first, **at most 15 files**. Skim for: user corrections, repeated wrong
   commands, ignored Wiring, the same detour in two sessions.
3. **Score current Checklist** (omit if empty) — per pin: helped / violated /
   never relevant in this corpus. Quote or drop the claim.
4. **Propose** — show this table, then the exact Checklist (and any EXTRACT
   skill) draft. Do not write yet.

```markdown
## Harvest Pins — Proposal

- Budget: <n> / 1200 tok (<over|ok>)
- Sessions: <kept> (grok / claude / codex) · skipped: <n>
- Out: <distill dir>

| # | op | target | quote | session ids | token delta |
| --- | --- | --- | --- | --- | --- |
```

5. **Confirm** — user edits, drops, or rejects rows. No DEFER pile; dropped
   rows need new evidence later.
6. **Write** only accepted rows. Keep `CLAUDE.md` as the existing pointer /
   symlink; do not fork instructions.
7. **Verify** — `--measure AGENTS.md`; heading freeze still intact; at most
   five diffs; no raw transcript paths committed.

## Related

- Shape of `AGENTS.md`: `/writing-for-agents` (user-authored; `/setup-project` only inserts the `## Agent skills` pointer)
- Pin / pointer wording: `/writing-for-agents`
- EXTRACT review: `/skill-review`

## Done

Complete when distill ran, a proposal with quotes was shown, unaccepted rows
were not written, accepted pins (if any) landed only in Checklist or an
EXTRACT skill, budget was re-measured, and Wiring is unchanged.
