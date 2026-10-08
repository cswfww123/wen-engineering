# UI slices (load before the first production edit)

Load when the layer is `frontend` / `full-stack` **or** a design source is in
play. Non-UI slices skip this file.

## Pin rows first (hard gate)

**Design source present (原型图 / 设计稿 / Figma / 截图 / HTML 原型 / pinned
winner) → it is product AC.** Extract its observable details as **pin rows**
for this slice before the first production edit: chat table for same-session
runs, ticket body for tracked work ([PRD-AUTHORITY.md](../to-spec/PRD-AUTHORITY.md)
§2). A detail visible in two states is two rows. No pin rows → fidelity cannot
be evidenced; extract, then walk again, or take an explicit user waiver that
lists its rows.

Package-root `DESIGN.md` exists → it is the visual environment (tokens,
Do's/Don'ts). Missing identity with multi-screen drift → optional
`/to-design-md`; not a blocker.

## Chrome owner (parent resolves, brief states)

Adding or restyling filter / picker / search / empty-state / chip / toolbar
chrome → load [SAME-SURFACE.md](../code-review/SAME-SURFACE.md) and **name the
owner already on that screen** before planning. The Plan then says exactly
where the extra goes: `add item <x> to <Owner>.items in <file>`. Owner cannot
take it → the slice is `blocked (owner gap)`; the parent does not plan a
second widget. User 样式不一样 / 不能复用 / 为什么新写 of sibling controls is a
same-surface hit, not a restyle.

## Fidelity (Executor captures, parent judges)

- Brief walkthrough carries **one row per pin row state**: exact navigation +
  state to reach, evidence path. Executor only captures screenshots.
- Parent (or the UI Fidelity reviewer at `full`) compares each screenshot with
  the design source and records 原型 vs 实现 per pin row. A weak worker's own
  "matches the design" is not evidence.
- Owed under **every** review weight. Newly shown existing chrome with no pin:
  one path screenshot.
- Restyling a lookalike to match sibling chrome is same-surface, not fidelity.

## Model tier

UI / design-pin slices: spawn Executor on the parent-tier model (Claude Code:
pass the Agent tool `model` override). The plan still carries every judgment —
a stronger worker is a margin, not a substitute for a fixed brief.
