---
name: to-questionnaire
description: Turn product or domain gaps the user cannot answer alone into a questionnaire for a meeting or async fill-in. Use when grilling stalls because answers live with product/stakeholders, or for requirement-clarification meetings.
disable-model-invocation: true
---

Turn something the user cannot fully answer alone into a **questionnaire** — a Markdown document for **one recipient role** (product, business, ops, design, another eng lead) to fill in **async**, or to work through **live in a requirement-clarification meeting**.

The recipient holds knowledge the user lacks. Filled answers become **settled product input** so a later session does **not** re-ask the same questions.

**Grill the send, not the subject.** Interview the user only about the _send_ and the _gap_ they already feel — not every product decision themselves. Do **not** invent Expected, market, or user value as if decided; you **may** propose **options + a recommended choice** for the recipient to accept, change, or override with free text.

## When to use (WEN)

| Situation | Prefer |
| --- | --- |
| User *is* the decision owner and can answer live | `/grill-me` |
| Answers live with someone else / a meeting | **`/to-questionnaire`** |
| Product need itself is still fuzzy (market / worth-doing) | HEAVY PM (`wen-pm`), not this skill alone |
| Multi-session eng fog after product is settled | `/wayfinder` |

From a stuck `/grill-me`: if several frontier rows need a stakeholder the user is not, **stop grilling those rows**, park them, and run this skill (or suggest it).

## Modes

Pick one up front (one question if unclear):

1. **Meeting** — 需求澄清会 / walkthrough. Questions ordered for a 30–60 min agenda; include time-box hints; allow "table for offline" stubs.
2. **Async** — send the doc; one pass may be all you get. Most-important-first; never compound questions.

## Process

1. **Who is it going to?** One exchange: recipient role, expertise, relationship to the user, and meeting vs async. Done when tone and assumed knowledge are clear.
2. **What must you walk away able to do?** One exchange: the concrete decisions/facts the user needs back (scope in/out, AC edges, priorities, policy, data ownership, launch constraints…). If a prior grill already listed open rows, reuse that list — do not re-grill the whole product. Done when the return list is concrete.
3. **Optional context pack (facts only).** Briefly note repo/docs the questionnaire should cite (link paths, not walls of paste). Facts the agent can look up stay out of the form.
4. **Write the questionnaire** using the structure below. Every item from step 2 maps to at least one **optioned** question (see [Question shape](#question-shape)). Report the path when done.

### Output path

Prefer:

- `.scratch/<feature-or-slug>/questionnaire-<slug>.md` when the repo uses `.scratch/` for working notes, else
- `to-questionnaire-<slug>.md` in the current directory

Slug from the topic. If under gitignored `.scratch/`, say so and offer a trackable copy for the meeting invite / ticket.

## Question shape (default)

Default every product decision to this shape — **not** a blank `>` with no guidance:

1. **Options** — short lettered choices (`A` / `B` / `C`…), each one idea.
2. **Recommended** — mark one option as **推荐** with a one-line why (eng/repo bias is fine; label it as recommendation, not decided fact).
3. **Manual / other** — always include `Z. 其他（请手写）` or equivalent free-text line.
4. **Answer stub** — a single place to record the pick: `选择: _` and optional `备注: _`.

When a true open fact is needed (name of owner, numeric SLA, link) and options would be fake, use **free-text only** — still give an example answer shape, not an empty void.

Do **not** invent market truth. Options may be hypotheses the meeting can kill.

## Document structure

Frame as a **discovery questionnaire**: engineering lacks context; the recipient holds it. Group under `##` themes when there are more than a handful. Most-important-first (async = one pass).

```markdown
# <Questionnaire title>

**Purpose:** why this exists and the decision / delivery step it unblocks.
**Mode:** Meeting | Async
**From:** <user / eng> — **To:** <recipient role or name>
**How answers will be used:** settled product input — **do not re-grill answered rows**; ingest → fold into `/to-spec` (or short eng-only grill if needed). No parallel long-lived decision file required.
**Deadline / effort:** …

## Context

One short paragraph + links (spec / ticket / scratch). Enough to answer well — not a page.

## How to answer

- Prefer **选推荐 / 改选项字母 / 手写 Z** — one decision per question.
- Partial answers and "I don't know / need data" are useful — write them in 备注.
- Meeting mode: stick to the time box; park deep branches under "Offline follow-up".
- After the meeting: paste this file (or answers) back to the eng agent with
  `问卷已填` — agent must **not** re-ask settled questions.

## <Theme>

### Q1. <One atomic decision?>

_Why this matters: <one line when useful>_

| | 选项 |
|---|---|
| A | … |
| B | … **（推荐：…）** |
| C | … |
| Z | 其他（请手写）：_______________ |

**选择:** _（A/B/C/Z）_  
**备注:** _

### Q2. <Open fact — free text only when options would be fake>

_Example shape: e.g. "上线日 YYYY-MM-DD" / "负责人 @name"_

**回答:** _

## Anything else?

Anything we did not ask that we should know before engineering commits?

**回答:** _

## Offline follow-up (meeting mode only)

Questions deferred from the live session.

## Ingest checklist (for eng agent — do not delete)

When answers return, the agent:

1. Treat non-empty **选择** / **回答** as **settled** — do not re-confirm unless blank, `Z` without text, or internal conflict.
2. Fold Q-id → choice → gist into the **`/to-spec` body** (implementation decisions / stories). Do **not** also create a separate long-lived `decision-*.md` unless the user will hand off before to-spec in another session.
3. Route: **default `/to-spec`** if product scope is enough to synthesize; **short `/grill-me`** only for remaining *engineering* frontier (seams, txn, API shape) — never re-interview product rows already answered. After to-spec consumes answers, stop treating the questionnaire as authoritative (no user prompt to delete).
```

## Return path (paste answers back)

Default is **smooth ingest**, not a second discovery:

```text
filled questionnaire
  → agent reads answers (path or paste)
  → fold Q-id → choice into /to-spec (single durable artifact)
  → default: /to-spec
  → only if eng seams / high-risk tech still open: short /grill-me on *those* only
```

| Rule | |
| --- | --- |
| **No re-confirm** | Answered options and filled free text are accepted as given |
| **Re-ask only** | Blank must-haves, bare `Z` with no text, or two answers that contradict |
| **Default next** | `/to-spec` when product in/out + stories are enough to write a honest spec |
| **Short grill** | Eng-only residual (module seams, contracts, test seams) — cite questionnaire IDs as already closed |
| **Never** | Restart full `/grill-me` frontier over the same product questions |

On skill close (after writing the empty form), print a one-liner the user can paste after the meeting, e.g.:

```text
问卷已填：.scratch/<slug>/questionnaire-<slug>.md → 请 ingest，勿重问已答项，默认 /to-spec
```

## Quality bar

- **Atomic questions** — never compound ("and/or" stacks).
- **Options + 推荐 + 手写** by default; free-text only when options would be fake.
- **No fake certainty** — recommendation ≠ decided fact until the recipient marks 选择.
- **Engineering facts out** — if the answer is in code/schema/prod config, look it up; do not put it on the form.
- **Stable Q-ids** (`Q1`, `Q2`…) so ingest and `/to-spec` can cite them.

## Keep it short

- At most two short interview turns before drafting (who + what-back).
- Do not re-read this file every turn after first load.
- Do not run a full product discovery interview here — that is HEAVY PM or `/grill-me` with the right human in the room.
