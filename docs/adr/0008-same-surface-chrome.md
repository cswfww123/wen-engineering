# Same-surface chrome: extend the owner — never ship a lookalike

Status: accepted

User-visible chrome of one interaction family on one screen or flow must go
through the existing **owner**. A second widget CSS-matched until it looks
close is a **blocking** failure of `/implement` and `/code-review`. The
classifier lives in `skills/code-review/SAME-SURFACE.md`. Skills point at it;
they do not restate the full table.

## Context

A mass-plan "choose session" bar already owned country and tag filters via
`CommonQuickFilters` (idle "请选择", click opens searchable `WabaSelect`).
The same bar needed three extra filters (social account, reception member,
interact status). The agent shipped a new antd `Select` for those extras.

When the user said the right-hand filters still did not match the left, and
that the dropdown must support input search, the agent **restyled** the new
`Select`: hide caret, change placeholder to 「请选择」, 10px vs 30px padding
for the clear icon. Reviewer then checked padding against session AC. Light
UI Fidelity never ran. The lookalike still had no search dropdown.

The user had to ask explicitly: 为什么这个组件不能复用，一定要新写一个.

Root cause was not missing "reuse components" language. Executor already says
"use existing project patterns." AGENTS.md already says prefer existing wire
values and identity patterns. The pack had a reminder and no refuse-to-pass:

- Implement treated "extra filters" as new fields → new `Select` in the same
  file (the local pattern).
- User "样式不一样" was parsed as a restyle ticket, not as **same-surface**.
- Light Slice checked AC words (hide arrow, 请选择) and padding. Spec can
  pass when the ticket never named the owner.
- "Visibility of existing chrome stays light" let a **new** widget beside the
  owner skip UI Fidelity; CSS matching then looked like fidelity.
- Thin Executor briefs named query fields (`boundAccountId`) but not the
  chrome owner (`CommonQuickFilters` items).

The pack had also absorbed [ponytail](https://github.com/DietrichGebert/ponytail)
as an **optional full-weight review axis**, not as ponytail's write-time ladder.
Original rung 2 is "already in this codebase → reuse it." WEN's axis kept
`delete` / `stdlib` / `native` / `yagni` / `shrink` and dropped that rung.
Light `/implement` slices never spawn Ponytail. The lookalike is **short**, so
`shrink` does not fire; antd `Select` looks like `native`. Original ponytail
would have stopped at rung 2 after reading the bar. The absorbed axis could
not refuse.

Like ADR 0005, a reminder without a refuse-to-pass mechanism ships something
that *looks* done.

## Decision

1. **Classifier + force live in the pack gate skills**, not a consumer
   `.agents/rules/` file. A lookalike is visible in the diff (new `Select`
   beside the owner, hide-arrow CSS). `/implement` Done, light Slice, Intent,
   and Verifier can refuse without a per-repo rule copy.
2. **Single source of truth:** `skills/code-review/SAME-SURFACE.md` —
   trigger families, reuse-signal phrases, role duties, allowed vs forbidden.
3. **Positive target: extend the owner.** Name the owner before the first
   chrome edit. Plug extras in as items / props / slots. If the owner cannot
   take the extra, `blocked` on the capability gap — do not CSS-match a
   sibling widget.
4. **Reuse signal is not restyle.** User 样式不一样 / 不能复用 / 为什么新写
   plus sibling screenshots is a same-surface hit. Stop CSS; extend the owner.
5. **Light Slice blocks.** Do not wait for full UI Fidelity. A restyled
   lookalike is not fidelity even when tokens match. `ui-fidelity: n/a` does
   not waive same-surface.
6. **Tickets name the owner.** UI AC that lists extra filters without
   **Chrome owner** (existing control, or `new — no sibling`) is incomplete.

This is **not** an incomplete-surface row (ADR 0005). The lookalike can be
complete and test-green; it is the **wrong owner**. Dual-source is a sibling
*domain fact*; same-surface is a sibling *chrome family*.

## Considered Options

- **Keep restyling until it looks like the left.** Rejected: this *is* the
  failure. Search, idle state, and clear-icon behavior live in the owner, not
  in padding.
- **Always-on AGENTS.md essay "reuse components."** Rejected: the reminder
  already existed and was skipped; local `Select` imports read as "the
  pattern."
- **Add a row to `INCOMPLETE-SURFACE.md`.** Rejected: wrong class. The
  lookalike is not deferred domain logic.
- **Escalate every extra control to full UI Fidelity.** Rejected: noise, and
  hide-arrow CSS can still vibe-pass a pin-less checklist. Slice must refuse
  on light.
- **Rely on the absorbed Ponytail axis (or always-on AGENTS "be lazy").**
  Rejected: the axis is optional, light skips it, and the lookalike is not
  over-build. Restore rung 2 as same-surface at write time and on light Slice;
  when Ponytail does run, classify lookalikes as `reuse`, not `native`/`shrink`.
- **Consumer-only rule under `.agents/rules/`.** Rejected as sole fix: every
  harness that runs pack `/implement` + `/code-review` should refuse this
  class (same as ADR 0005).

## Consequences

- `implement`, `to-tickets`, `code-review` (Slice, Intent, UI Fidelity,
  Verifier), and pack `Executor` / `Reviewer` / `Verifier` gain thin binding
  pointers to the classifier.
- Executor briefs for UI slices must name the same-surface owner (or
  `new — no sibling` / `n/a`).
- Done reports gain `same-surface`: `owner-extended` | `new-no-sibling` |
  `n/a` | findings.
- Honest `new — no sibling` and explicit owner-replacement migrations remain
  allowed when there is no sibling, or the user asked to replace the owner.
