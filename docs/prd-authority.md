# Product-doc authority gates

Hard gates when an **active product requirements / PRD / `docs/requirements/*` /
`docs/prd/*`** covers the surface being specified or built. Companion to
[lifecycle.md](lifecycle.md). Skills point here; they do not restate the tables.

This is **not** a new slash command and **not** HEAVY PM. It binds LIGHT L2 / G /
L3 so grill AC cannot silently replace a detailed product doc.

## Authority

| Rank | Source | Role |
| --- | --- | --- |
| 1 | Active product requirements / PRD | Product-behavior baseline |
| 2 | Eng spec / tickets derived from it | Slice AC |
| 3 | Explicit accepted `相对 PRD` deltas | Authorized deviations only |
| 4 | Grill / chat residual | Eng seams the product doc does not specify |
| 5 | Code / tests | Facts about what ships today — not a license to drop product intent |

Matching grill AC while missing unlabeled PRD behavior is **wrong AC**.

## When these gates apply

Apply when **any** of these is true:

- The user names an in-repo product doc (`docs/requirements/*`, `docs/prd/*`, or
  an equivalent path they treat as the PRD)
- A published spec lists that doc as **Delivery source**
- The work is multi-slice and that doc already settles the behavior surface

Skip for a one-context bug, a pure-eng slice with unchanged product behavior, or
when no product doc covers the surface.

## 1. Route lock (do not re-author the PRD)

Named multi-slice product doc → **L2** (`/to-spec`). Do **not** open a full
product `/grill-me` that rewrites settled behavior.

`/grill-me` may run only as a **residual** table:

- Original contradictions (two PRD rows that cannot both be true)
- Terms that do not map to a live column / enum / API
- Eng seams the product doc does not own (txn, wire, test seam)

Every recommended row that narrows, defers, or changes product-doc behavior
**must** be labeled `相对 PRD: <was> → <now> (<reason>)` and classified:

| Class | Meaning | Reversible by |
| --- | --- | --- |
| **doc-change** | Product owner is changing the written requirement | Edit the product doc, then inventory |
| **eng-read** | Engineering interpretation of a contradiction or missing mapping | User saying **按原文** (revokes that delta id only) |

Unlabeled deltas are invalid even if the user says `按推荐`.

## 2. PRD Inventory (required before spec `accepted`)

When the delivery source is an existing product doc, `/to-spec` must publish a
**PRD Inventory** on the spec (section or sibling table). Fail → do not set
`Status: accepted`.

Inventory **rows** are the smallest observable product clauses:

- Numbered acceptance points (e.g. 验收 1–16)
- Each material scenario / 场景 row in the change-detail tables
- Each explicit list/detail/edit/copy/submit rule that can fail independently

| Inventory field | Rule |
| --- | --- |
| `SRC` | Stable source ref (`ACC-07`, `§2.10 会话选择`, `§2.15 编辑`) |
| `Surface` | Where a user can observe it (弹窗 / 页外 / 提交 / GET 详情 / 列表…) |
| `REQ` | `REQ-xxx` that owns this row, or `HITL` / `OUT` |
| `Notes` | Contradiction, missing mapping, or deferral pointer |

**Pass when:** every material source clause has a `REQ`, `HITL`, or explicit
`OUT`. Contradiction rows stay `HITL` until the user accepts a **labeled**
delta — do **not** write them into Accepted deltas silently.

A clause that appears on **two surfaces** is **two inventory rows** (弹窗回显 ≠
页外回显; 提交剔除 ≠ 编辑 GET 重验; 选模板 ≠ 每组变量编辑器).

## 3. Delta lock

Accepted `相对 PRD` rows live in a **separate** spec table (`Accepted PRD
deltas`), each with a stable id (`S3`, `D-014`, …), class (`doc-change` |
`eng-read`), and source `SRC`.

- Implement AC = product doc **minus only** that table
- Recap and Done reports must list the table (or `none`)
- User **按原文** / “按 PRD 原文” / “收回 delta” → **L3** `/product-fog`
  with those delta ids only. Re-open **only** those inventory `SRC`s. Do **not**
  full-regrill the package. Do **not** treat the revoke as “skills failed.”

## 4. Ticket coverage (tighter than “REQ appears somewhere”)

`/to-tickets` pre-publish **and** ticket completion:

| Check | Pass when |
| --- | --- |
| Inventory coverage | Every inventory `SRC` with a `REQ` appears in some ticket **`Covers`** (or stays `HITL` / `OUT` on the spec) |
| `Supports` | **Does not** count as coverage |
| Dual surface | Two surfaces → two AC bullets or two tickets |
| Acceptance points | Numbered 验收 / ACC ids each appear in some ticket `Covers` |
| Honest complete | Ticket body still saying 残差 / 下张票收口 / partial → **cannot** `Status: complete` |

A ticket may `Supports` a nearby REQ for context. That is not “this REQ is done.”

## 5. Product-doc walk (`prd-walk`)

Not a new user-invoked skill. It is a **required mode** of `/alignment-review`
when the delivery source is an external / in-repo product doc.

**When (mandatory):**

- Closing the **last** open implementation ticket of a PRD-sourced spec
- Answering “已按 PRD 实现 / 对照 PRD 验收 / 是不是做完了”
- Promoting the parent spec toward `delivered`

**Against:** the **original product doc**, not the eng spec recap.

**Output** (one table, then stop or list follow-up tickets):

```text
SRC | Surface | Verdict | Evidence
ACC-07 | 页外回显 | 过 | … / 缺 | … / 有意 delta S4
```

Verdicts: `过` | `缺` | `有意 delta <id>`.

**Fail closed:**

- Any `缺` → parent spec **must not** be called delivered; tickets that claimed
  those `SRC`s **must not** stay `complete` without a follow-up ticket or an
  accepted delta
- Do **not** answer “已按 PRD 实现” while any `缺` remains
- `有意 delta` rows must already exist on the Accepted deltas table; inventing
  them at walk time is a fail

Slice `/code-review` still reviews the ticket AC. `prd-walk` is the
**package-level** check against the product doc. It does not replace
optional `wen-test` system QA.

## Dual-surface cheat sheet (typical miss)

Split these even when the PRD writes them in one paragraph:

| Clause family | Surfaces that each need an AC |
| --- | --- |
| 有效/无效数量 | 弹窗内 **and** 关闭后页外 |
| 确认保存 | 触发控件（弹窗确定）**and** 取消不写回 |
| 剔无效 | create/update 提交 **and** 编辑/复制 GET 回填 |
| 分组模板 | 选择模板 **and** 每组参数/页头编辑器 **and** 详情每组预览 |
| 灰显 | 禁勾 **and** 整行视觉（若原文写了灰显） |
