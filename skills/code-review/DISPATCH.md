# Code-Review Dispatch (self-contained)

Loads with this skill. Prefer pack roles `Reviewer` / `Verifier` / `Executor`
when the host has them; otherwise host general-purpose / parent with the text
below. Axis detail: [AGENT-BRIEFS.md](AGENT-BRIEFS.md), [REVIEW-AXES.md](REVIEW-AXES.md).

## Hard try (required)

Parent picks **`review-weight`** first (`light` | `full`) using [SKILL.md](SKILL.md)
**Pick weight**, after the **Diff gate**. Spawn only the workers that weight
names.

1. Prefer pack `Reviewer` per worker; else host general-purpose with the brief
   from [AGENT-BRIEFS.md](AGENT-BRIEFS.md) or the Matt prompts in SKILL.md.
   **Light:** one Slice Reviewer. **Full:** parallel Standards + Spec, plus
   Correctness on production-reachable code (skip only docs/comment/config-rename).
   Full also hard-tries **UI Fidelity** when SKILL.md marks it in scope.
   Optional extra axes (Performance, Security, Ponytail) when warranted.
   Correctness / Slice packets include [INCOMPLETE-SURFACE.md](INCOMPLETE-SURFACE.md)
   and [FORENSIC-OBSERVABILITY.md](FORENSIC-OBSERVABILITY.md) when the diff can
   hit those classes. UI Fidelity packet includes design pin or checklist-only
   waiver + fidelity evidence paths.
2. **Every Reviewer/Verifier spawn uses a full self-contained brief** (see
   templates below). Subagent context is cold/disposable and often a weaker
   model — paste the review packet, axis body, and evidence; do not spawn with
   only “review the diff on axis X”.
3. **Verifier:** **full** always must-try after candidates. **Light** only when
   the Slice Reviewer filed a candidate. Confidence bar `>=80`. Incomplete
   surface (including quiet path / log-unsafe) that survives verification
   blocks `Pass`. In-scope UI Fidelity fail or missing evidence blocks `Pass`.
   The Verifier brief is candidates (or `none`) + the same fixed point — not a
   parent verdict, and not a pre-waived evidence bar.
4. **Never** abort because pack roles are missing. Skipping spawn when a
   runtime exists, without an attempt, is a process bug — report
   **confidence: degraded** if parent-fallback ran a required worker; do not
   present that as a full multi-agent Pass.
5. Report **`review-weight`**, **`agents used`**, **incomplete-surface**:
   `clean` | findings | `n/a`, **observability** when applicable, and
   **ui-fidelity** when that axis ran (else `n/a`).

## Review packet (shared by every axis worker)

Build once; attach the same packet to each Reviewer spawn:

```text
## Review packet
- Fixed point: <base..head | commit SHAs | attached diff>
- Diff commands (copy-pasteable): <e.g. git diff base...head -- path>
- Diff text: <paste when small/medium; if huge, paste changed hunks for risky files + file list>
- Changed files:
- Commits (subject lines):
- Intent evidence (authority order):
  - Product baseline: <path + critical quotes>
  - Eng spec/tickets: <paths/IDs + critical quotes>
  - Accepted PRD deltas: <none | list>
  - Grill/session residual (eng seams only):
- UI fidelity (when that axis is in scope; else n/a):
  - Design pin: <Figma/path/URL@version + frames | none>
  - Checklist-only waiver: <none | written reason>
  - UI contract subset: <screens/fields/rules or path>
  - DESIGN.md: <path or none>
  - Evidence: <screenshot path(s) and/or checklist path | missing>
- Standards sources: <paths + any non-obvious rules to apply>
- Project shape / lenses (if Performance/Security): <from PROJECT-LENSES or none>
- Out of scope / intentional non-goals for this change:
```

## Reviewer brief (recommended — default per axis)

```text
Role: Reviewer (read-only; do not edit files)

## Axis
- Axis name: <Slice|Intent|Standards|Correctness|UI-Fidelity|Performance|Security|Ponytail|root-cause-fit|architecture>
- Axis brief (paste full body from AGENT-BRIEFS.md or DESIGN-REVIEW-BRIEF.md — do not assume worker can open the pack):
  <PASTE AXIS INSTRUCTIONS HERE>

## Review packet
<PASTE SHARED PACKET ABOVE>

## Packet type
- code-delta | design-plan

## Constraints
- High-confidence only; prefer issues introduced by this change
- Stay on this axis only
- Do not invent product requirements if intent evidence is missing — say so
- Correctness: apply incomplete-surface + forensic observability rules when those
  docs are pasted or available

## Return
- findings: summary, file:line, evidence, axis, fixability, confidence
- axis result: issues found | clean | skipped (reason)
- incomplete-surface (Correctness only): clean | findings | n/a
- observability (Correctness only): instrumented | foundation-missing | quiet-path | log-unsafe | n/a | findings
- likely false positives discarded (brief)
```

## Verifier brief (recommended — default)

```text
Role: Verifier (read-only judgment gate; do not edit files)

## Fixed point (must match Reviewers)
<same fixed point / design packet as review workers>

## Candidates
<paste each candidate with file:line, evidence, axis, claimed fixability — or the word none>
Do not include a parent verdict or a pre-waived evidence bar.

## Rules
- Confidence bar to keep: >=80
- Drop invented, pre-existing, out-of-scope, intentional, CI-noise
- Incomplete production surface / quiet path / log-unsafe are blocking — not "intentional later"
- Unauthorized product-doc partial blocks Pass when a PRD was in the packet
- In-scope UI Fidelity fail / blocked-no-pin / missing screenshot-or-checklist
  evidence blocks Pass — parent prose "fidelity OK" is not evidence
- Design-packet gates: Pass is not implement authority; recommend
  implement-minimal | spec-and-slice | blocked

## Return
- exactly one verdict: Pass | Changes Required | Needs User Decision
- surviving findings (file:line, evidence, why not FP, fixability, confidence)
- incomplete-surface: clean | findings | n/a
- observability: ...
- ui-fidelity: pass | fail | blocked-no-pin | n/a | skipped
- rejected groups (brief)
- verification gaps
- design-packet only: recommended next step
```

## Reviewer system text (generic host)

```text
You are Reviewer, a focused read-only review subagent.

Review exactly the change scope in the main agent's brief. Do not edit files.

Brief is your entire world — you do not inherit the parent chat. Expect one axis
(with instructions), a full review packet, and a return shape. If too thin to
review without guessing, return skipped with what is missing.

Use the review packet (diff/fixed point, intent/spec sources, standards, axis).
Prefer issues introduced by this change. High-confidence only. Skip pre-existing
noise, pure tooling nits CI catches, intentional scope, and speculation.

When the brief names an axis, stay on that axis.

Return: findings (summary, file:line, evidence, axis, fixability, confidence);
axis result (issues found | clean | skipped); brief FP discards.
```

## Verifier system text (generic host)

```text
You are Verifier, a focused judgment subagent.

Brief is your entire world — you do not inherit the parent chat. Expect
candidates with evidence plus the same fixed point Reviewers used.

Given candidates plus the same fixed point, re-check evidence. Do not edit files.
Drop invented, pre-existing, out-of-scope, intentional, or CI-noise items.
Keep only high-confidence findings.

Incomplete production surface (TODO/FIXME deferred real logic, stubs on live
paths, dual-source domain facts, config stand-ins vs sibling real sources,
quiet critical paths, log-unsafe logging) is blocking — not "intentional"
merely because a comment says "later" or "add logs later". Logging must be
fail-open: log failure must never fail business. Completion claims fail while
any remain.

When UI Fidelity is in scope: missing pin without checklist-only waiver, missing
screenshot/checklist evidence, or ui-fidelity fail blocks Pass. Parent prose
alone is not evidence.

Return exactly one verdict:
- Pass — no validated blocking finding
- Changes Required — at least one validated blocking finding
- Needs User Decision — behavior/trade-off cannot be decided from evidence

Then: surviving findings; incomplete-surface clean|findings|n/a; observability;
ui-fidelity pass|fail|blocked-no-pin|n/a|skipped; rejected groups (brief);
verification gaps.
```

## Executor (auto-fix only)

Only when the user or `/implement` authorized fixes. Same Executor brief pattern
as implement/DISPATCH.md; preserve **how not what**.
