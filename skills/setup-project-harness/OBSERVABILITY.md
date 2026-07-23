# Observability pointer (harness setup)

Harness-side **classification only** for `/setup-project-harness`.

Building a logging foundation is **not** harness work. Use:

**`/setup-logging`** → `skills/setup-logging/SKILL.md`

Pack forensic contract (decision-boundary logs, review checklist, fail-open,
done vocabulary):

`skills/code-review/FORENSIC-OBSERVABILITY.md`

## What setup still does

1. **Classify the bar** from code shape (full / thin / partial) — see explore
   notes in [HARNESS_FLOW.md](HARNESS_FLOW.md).
2. **Record status** in the exploration summary and done report:
   `present` | `partial` | `missing` | `thin-n/a`.
3. **Point** full-bar + missing/partial projects at `/setup-logging` before
   treating the repo as agent-ready for integration-heavy AFK work.
4. Optionally add a **Wiring** one-liner in `AGENTS.md` only when the project
   already has a non-inferable how-to-read path after logging setup.

## What setup does *not* do

- Does not implement logger modules, MDC filters, sinks, or stack recipes.
- Does not paste logging essays into `AGENTS.md`.
- Does not instrument feature decision boundaries (that is `/implement` +
  forensic review).
