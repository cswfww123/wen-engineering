---
name: to-spec
description: Turn the current conversation into a spec and publish it to the project issue tracker — no interview, just synthesis of what you've already discussed.
disable-model-invocation: true
---

This skill takes the current conversation context and codebase understanding and produces a spec (you may know this document as a PRD). Do NOT interview the user — just synthesize what you already know. Usually entered **after** a `/grill-code` pass (poles settled, PRD deltas labeled in thread); direct entry is equally valid — the PRD Inventory below is the fail-closed backstop either way.

The issue tracker and triage label vocabulary should have been provided to you — run `/setup-project` if not.

## Process

1. Explore the repo to understand the current state of the codebase, if you haven't already (direct PRD entry: fold the collision sweep into this exploration — live write paths, schema, contract/seal tests, management surfaces). Use the project's domain glossary vocabulary throughout the spec, and respect any ADRs in the area you're touching.

2. **If the delivery source is an existing product doc** (`docs/requirements/*`,
   `docs/prd/*`, or a user-named PRD): load
   [PRD-AUTHORITY.md](PRD-AUTHORITY.md) and draft the
   **PRD Inventory** per its §2 *before* writing REQs — row shape, pin rows,
   dual-surface splits, and the fail-closed gate (HITL → one residual
   `/grill-code` round → re-check) are all defined there. **Do not interview**
   settled PRD behavior.

3. Sketch out the seams at which you're going to test the feature. Existing seams should be preferred to new ones. Use the highest seam possible. If new seams are needed, propose them at the highest point you can. The fewer seams across the codebase, the better - the ideal number is one.

Check with the user that these seams match their expectations.

3.5. **Judge Requirements detail level (automatic)** — Load `to-spec/REQ-DETAIL-JUDGMENT.md` and evaluate requirement complexity by analyzing:
   - Module count (≥3 → high complexity)
   - Presence of pricing/billing logic (→ high complexity)
   - State machine complexity (≥5 states → high complexity)
   - PRD word count (>15k → high complexity)
   
   Select detail mode automatically:
   - 🔴 High complexity → Detailed rules (algorithm examples, full copy, boundary cases)
   - 🟡 Medium complexity → Balanced mode (key examples, core copy)
   - 🟢 Low complexity → Concise mode (formula definitions, PRD references)
   
   Tell the user your judgment before generating Requirements. User can override with explicit instruction.

4. Write the spec using the template below (include Inventory + Accepted PRD
   deltas when a product doc is in play), then publish it to the project issue
   tracker. Apply the `ready-for-agent` triage label - no need for additional
   triage. **Fail closed:** a PRD-sourced spec without a complete Inventory
   cannot be `Status: accepted`.

<spec-template>

## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## User Stories

A LONG, numbered list of user stories. Each user story should be in the format of:

1. As an <actor>, I want a <feature>, so that <benefit>

<user-story-example>
1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending
</user-story-example>

This list of user stories should be extremely extensive and cover all aspects of the feature.

## Implementation Decisions

A list of implementation decisions that were made. This can include:

- The modules that will be built/modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it within the relevant decision and note briefly that it came from a prototype. Trim to the decision-rich parts — not a working demo, just the important bits.

## Testing Decisions

A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (i.e. similar types of tests in the codebase)

## Implementation Protocol (required when design source present)

When the delivery source includes a design pin (原型图 / 设计稿 / HTML 原型 / Figma frame @version / pinned prototype winner):

**Before implementing each ticket**, the agent MUST:

1. Open the design source file(s) listed in Source Material or ticket `Design pin`
2. Extract a **style specification table** for the regions this ticket covers:
   - **Layout**: proportions (%), spacing (px), alignment, scroll behavior, z-index stacking
   - **Typography**: font-family, size, weight, line-height, color (hex), letter-spacing, text-transform
   - **Colors**: backgrounds, borders, text, icons — for each interactive state (default / hover / active / disabled / loading / error / empty) — values in hex + opacity
   - **Controls**: border-radius, box-shadow, transitions (duration + easing function), cursor
   - **Copy**: exact wording, punctuation, line breaks, ellipsis treatment
3. Paste this table into the implementation brief or working notes as literal expected values

**During verification**, compare runtime screenshots with the design source **per pin row**:
- Layout deviations > 10% of stated value → reject
- Color deviations > ΔE 5 (perceptually noticeable difference) → reject
- Missing interactive states shown in design → reject
- Copy mismatches (including punctuation, capitalization, line breaks) → reject
- Border-radius / shadow / transition absent when design shows them → reject

**Accept only when** every pin row passes pixel-level comparison against the design source, or the user explicitly waives specific rows (list the waived rows in the Done report).

Non-UI slices or slices without a design source skip this section.

## Out of Scope

A description of the things that are out of scope for this spec.

## Further Notes

Any further notes about the feature.

</spec-template>

## WEN additions

- Spec artifacts are **non-runnable**. Publish via the harness tracker adapter
  (`docs/agents/issue-tracker.md`). Optional field shapes:
  [TEMPLATE.md](TEMPLATE.md), publish steps [PUBLISH.md](PUBLISH.md).
- Prefer stable requirement IDs when the harness uses them; do not rename legacy
  `PRD.md` / history in place.
- Routing / anti-invention: `../ask-process/LIFECYCLE.md`. Never invent Expected, market
  bets, or user value. PRD-sourced work: [PRD-AUTHORITY.md](PRD-AUTHORITY.md)
  (Inventory required; grill must not re-author the product doc).
- **Filled `/to-questionnaire` is settled input.** If the user pastes answers or
  a path (`问卷已填`), synthesize from those choices — do **not** interview or
  re-confirm answered Q-ids. Only flag blanks / bare `Z` / contradictions before
  publishing. Prefer citing Q-ids in Implementation / Out of Scope where useful.
- Optional bug-report path: [BUG-REPORT-CONVERSION.md](BUG-REPORT-CONVERSION.md).
