# UI slices (load before the first production edit)

Load when the layer is `frontend` / `full-stack` **or** a design source is in
play. Non-UI slices skip this file.

## Pin rows first (hard gate)

**Design source present (原型图 / 设计稿 / Figma / 截图 / HTML 原型 / pinned
winner) → it is product AC.** Before the first production edit the parent
holds this slice's **pin rows** ([PRD-AUTHORITY.md](../to-spec/PRD-AUTHORITY.md)
§2 owns the row shape and state set): take the Inventory rows this ticket
`Covers`; with no Inventory, extract them now — chat table for same-session
runs, ticket body for tracked work. A detail visible in two states is two rows.

Then open the design source and expand each pin row into **literal style
values**, read from the source rather than eyeballed:

- HTML 原型 → DevTools computed styles
- Figma → Inspect panel
- 截图 / 设计稿 → pixel ruler + color picker; mark these values `measured`

| PIN | Element · state | Property | Value | Source |
| --- | --- | --- | --- | --- |
| PIN-03 | 主按钮 · default | border-radius / background | 999px / #4C6FFF | 确认页.html:102 `button.primary` |
| PIN-03 | 主按钮 · hover | opacity | 0.9 | 同上 `:hover` |
| PIN-05 | 左栏 · default | width | 60% | 确认页.html:45 `.left-panel` |

The values go into the brief's Acceptance and Walkthrough as literal
expectations — the Executor receives values, never "see the prototype".

No pin rows → fidelity cannot be evidenced; extract, then walk again, or take
an explicit user waiver that lists its rows.

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
  state to reach, evidence path. Executor captures a screenshot and, where the
  runtime exposes it, the computed values of that row's style properties.
- Parent (or the UI Fidelity reviewer at `full`) judges per pin row: values
  read from DevTools / Figma must match the table exactly; `measured` values
  and the screenshot are judged by visual fidelity (layout, hierarchy, state). Records 原型 vs 实现 per row. A weak worker's own "matches the design"
  is not evidence. Bar = **visual fidelity** ([REVIEW-AXES.md](../code-review/REVIEW-AXES.md)
  UI Fidelity); pixel identity only when the ticket says so.
- Owed under **every** review weight. Newly shown existing chrome with no pin:
  one path screenshot.
- Restyling a lookalike to match sibling chrome is same-surface, not fidelity.

## Model tier

UI / design-pin slices: spawn Executor on the parent-tier model (Claude Code:
pass the Agent tool `model` override). The plan still carries every judgment —
a stronger worker is a margin, not a substitute for a fixed brief.
