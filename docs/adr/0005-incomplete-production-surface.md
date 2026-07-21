# Incomplete production surface: finish the domain step or stop — never ship deferred logic as done

Status: accepted

Production-reachable code that returns success while the real domain step is
deferred, stubbed, dual-sourced, or marked "later" is a **blocking** failure of
`/implement` and `/code-review`. The classifier lives in
`skills/code-review/INCOMPLETE-SURFACE.md`. Skills point at it; they do not
restate the full table.

## Context

A cost-center recharge path charged different CNY amounts for the same USD
amount depending on pay channel. Alipay used `ExchangeRateService` (latest rate
table row). WeChat used a Nacos fixed `exchange-rate` with a production comment:

```text
// TODO: 汇率来源待后续接入…；当前使用 Nacos 配置的固定汇率兜底。
```

The path returned HTTP 200, a pay URL, and a plausible rate string. Thin tests
and Standards-oriented review could pass. The bug only surfaced when both
channels were compared in a real environment.

Root cause was not missing mention of "exchange rate." It was that the pack
allowed **premature completion** of a production surface:

- Executor/`/implement` had no hard ban on deferred markers or config stand-ins.
- `/code-review` required only Standards + Spec; Correctness was optional.
- Spec rarely says "both channels share one rate source," so Spec-only review
  does not invent that consistency.
- Verifier treated "intentional TODO" as a possible false positive.

Like the concurrency postmortem (ADR 0002), a reminder without a refuse-to-pass
mechanism does not stop the model from shipping something that *looks* done.

## Decision

1. **Classifier + force live in the pack gate skills**, not only in a consumer
   `.agents/rules/` file. Incomplete surface is visible in the diff (unlike many
   races), so `/implement` Done, `/tdd` green, Correctness, and Verifier can all
   refuse without a project-specific rule copy.
2. **Single source of truth:** `skills/code-review/INCOMPLETE-SURFACE.md` —
   trigger table, allowed vs forbidden, role duties.
3. **Correctness is required** for production-reachable diffs (not pure
   docs/comment/config-rename). Incomplete surface is a **blocking** Correctness
   class; Verifier cannot return `Pass` while it remains.
4. **Executor may not quiet-fallback.** Finish the real domain step for claimed
   AC, or return `blocked`. Deferred work is a separate ticket, not a shipped
   comment.
5. **Green must lock the shared source of truth** at the seam — not a config
   constant that sidesteps a sibling path's real service.

## Considered Options

- **Lint-only ban on `TODO` in CI.** Rejected as sole fix: many legitimate
  cleanup TODOs exist; the hazard is deferred *production domain* logic and
  dual-source money/data paths, not every comment string.
- **Spec axis only.** Rejected: tickets often omit "sibling channels must share
  one source"; the consistency failure is a correctness property of the domain
  step, not always a written requirement.
- **Consumer-only rule under `.agents/rules/`.** Rejected as sole fix: every
  harness that runs pack `/implement` + `/code-review` should refuse this class
  without per-repo sediment.

## Consequences

- `implement`, `code-review`, `tdd`, and pack agents `Executor` / `Reviewer` /
  `Verifier` gain thin binding pointers to the classifier.
- Honest spikes and `/prototype` stubs remain allowed when not mixed into
  production AC.
- Future similar postmortems extend the classifier table in
  `INCOMPLETE-SURFACE.md` rather than scattering new checklists.
- Extended by ADR 0006: quiet critical path and log-unsafe (forensic
  observability + fail-open logging) are additional classifier rows.
