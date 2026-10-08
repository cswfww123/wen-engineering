# Same-surface chrome

**Leading word: same-surface** — one interaction family on one screen or flow
already has an **owner**. Extra instances of that family **extend the owner**.
A second widget that is CSS-matched until it *looks* close is not the owner.

This file is the single source of truth. `/implement`, Executor, `/to-tickets`,
and `/code-review` only point here; they do not restate the classifier.

## Trigger (classifier)

Fire when the change set (or the AC it claims) **adds or restyles** user-visible
chrome, **and** a sibling on the same screen / modal / flow already owns that
interaction family.

| Family | Owner already looks like |
| --- | --- |
| **Filter / preset / quick-select** | shared filter bar, `CommonQuickFilters`, search-select presets |
| **Picker** | date / member / account / tag / country select already on that bar |
| **Search** | the bar's search field or searchable dropdown |
| **Empty / loading / error** | the screen's existing empty-state / spin / result chrome |
| **Status chip / action** | chips, tags, or toolbar actions already used for the same job |

**Reuse signal (chat, not only the diff).** These are **same-surface**, never a
restyle ticket:

- 样式不一样 / 看起来不一样 / 完全不一致
- 为什么不能复用 / 一定要新写 / 为什么这个组件不能复用
- 同一个筛选 / 同一套
- screenshots of sibling controls on one bar (left owner vs right lookalike)

Do **not** fire for: a genuinely new family with no sibling on that surface;
an explicit user ask to replace the owner; `/prototype` throwaway; a documented
do-not-copy owner (dangerous legacy — find the healthy owner, or `blocked`).

## Required behavior

| Role | Must |
| --- | --- |
| **`/to-tickets`** | UI tickets name **Chrome owner**: the existing control this slice extends, or `new — no sibling on this surface`. AC that lists extra filters without naming the owner is incomplete. |
| **Executor / `/implement`** | Before the first chrome edit, **name the owner** in the brief and extend it (items / props / slots). If the owner cannot take the extra, return `blocked` with the capability gap. Do not land a lookalike. User reuse-signal → stop CSS; extend the owner. |
| **`/code-review` Slice** (light **and** full) | Parallel widget for the same family is **blocking**. Hide-arrow / padding / placeholder CSS on a second `Select` is evidence of a lookalike, not a fix. `ui-fidelity: n/a` does **not** waive this. |
| **Intent / Spec** | The right extra fields in a new widget are **wrong place**. Quote the sibling owner. |
| **UI Fidelity** | A restyled lookalike is **not** fidelity. Do not Pass because tokens or padding now match the owner. |
| **Verifier** | Completion claims fail while a same-surface lookalike remains for claimed AC. |

Report vocabulary: `same-surface`: `owner-extended` | `new-no-sibling` | `n/a`
(non-UI) | findings (lookalike).

## Allowed vs forbidden

**Forbidden (lookalike — do not ship):**

```tsx
// Same bar already uses CommonQuickFilters for country / tags.
<Select options={socialOptions} />           // extra filter as a second widget
<Select className={styles.noArrow} />        // hide caret to "match"
```

```less
.extraSelect :global(.ant-select-arrow) { display: none; }  // CSS as reuse
.extraSelect { padding-right: 30px; }                       // fork-slot padding
```

**Allowed (extend the owner):**

```tsx
<CommonQuickFilters
  items={[...countryAndTags, social, member, interactStatus]}
/>
```

**Allowed (honest gap — not shipped as done):**

- Return `blocked`: owner has no item/slot API for this extra; need a real
  extension of the owner, not a sibling widget.
- Ticket AC names `new — no sibling` when the surface truly has no owner.
- User explicitly asked to replace the owner (migration), not to add extras.

## Why this is a hard gate

"Add three extra filters" plus "make them look like the left" is routinely
read as: new `Select` + hide arrow + `请选择`. Light Slice then checks the
placeholder and padding. The user still sees two products on one bar — the
owner has search-select; the lookalike does not.

A reminder to "use existing patterns" is not enough: the local file already
imports `Select`, so the lookalike *is* a local pattern. Ponytail `shrink` /
`native` also miss it: the second widget is short and uses the platform
control. The refuse question is: **does this extra instance go through the
owner already on this surface?**
