---
name: implement
description: Implements one bounded task or implementation-frontier ticket through evidence, review, and verification.
disable-model-invocation: true
---

# Implement

One bounded task or one runnable implementation ticket: one claim, one fresh
context, one reviewable delta, one completion decision.

Routing / anti-invention: `docs/lifecycle.md`.

## Find The Work

Read `CONTEXT.md` or context map when present, plus source (spec, ticket, legacy
PRD/issue, bug report, or brief). Tracked work: also
`docs/agents/issue-tracker.md` and `docs/agents/triage-labels.md`. Explicit user
reference wins; canonical vs legacy conflict → show both.

Clear bounded request → implement directly (no invented spec/ticket). Intent not
ready → stop and route per lifecycle.

Read **Layer** (`frontend` | `backend` | `full-stack` | `non-UI`). UI missing
field/rule/design pin, or BE missing contract expectations → stop
(`docs/handoff-package.md`). No UI pins on backend-only; no BE work on FE-only.

Tracked work (frontier, bug-report conversion, HITL, claim/isolate): load
[TRACKED-WORK.md](TRACKED-WORK.md) before edits.

## Execute

1. Mark in progress when tracked.
2. Trace entrypoints when behavior crosses callers, persistence, permissions,
   async, conversions, or side effects. Load covered `REQ`/`AC`/`SCN` and any
   `SCR`/`FLD`/`RULE` subset.
3. Evidence loop: observable behavior → `/tdd` (RED → smallest GREEN);
   authorized behavior-preserving docs/config/mechanical → GREEN baseline +
   verify → one increment → rerun (expand-contract: caller inventory +
   compatibility checks).
4. `/simplify` for non-trivial changes; tiny mechanical diffs stay direct.
5. Project verification (**behavior gate** for this layer).
6. **Fidelity** (do not close on behavior-green alone when applicable):
   - **UI** (FE/full-stack UI delta): fields, requiredness, show/hide/enable,
     empty/error/loading vs contract/design; checklist and/or screenshot. n/a
     backend-only.
   - **API** (BE/full-stack contract delta): request/response/error/authz/compat
     vs stated contract. n/a pure UI on pinned external API.
7. `/code-review` against fixed point (AC + fidelity). Resolve blockers; re-verify.
8. Re-check every AC. Wrong product/design contract → hand to product/design with
   IDs (never invent Expected). Implementation drift → fix or leave open. Complete
   only when behavior, fidelity, verification, and review pass.

Unverified criteria stay open. Commit only when authorized.

## Stop Or Continue

Default: one ticket, then stop. Multi-ticket only if user asked — fresh worker
and isolated delta each; never two dependent tickets in one context.

Mid-flight HITL / claim release / temp handoffs: [TRACKED-WORK.md](TRACKED-WORK.md).

## Done

Report: task/ticket, source, fixed point, files, behavior-gate, fidelity (or n/a),
code-review verdict, tracker update, commit status, next frontiers or blocker.
