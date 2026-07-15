# Shared mutable invariants: a classifier-triggered rule, not a skill gate

Status: accepted

Concurrency correctness for shared mutable state (balance, quota, counter, inventory,
state machine) is enforced by a single rule under `.agents/rules/invariants/`, not by a
gate inside any skill. The rule fires on a concrete trigger — work that touches a shared
mutable invariant — and requires three artifacts: the invariant, a concurrency contract,
and a concurrency test seam. Skills only point at the rule; they do not enforce it.

## Context

A billing feature under-charged when messages were sent quickly but charged correctly one
at a time — a classic read-then-write race. It passed every stage of the workflow:
`grill-me` mentions "concurrency" in its edge-case layer; `code-review`'s correctness axis
checks "changed invariants." Neither caught it.

Root cause was not missing coverage of the word "concurrency." It was that the workflow had
a reminder but no recognize-and-force mechanism:

- `grill-me` lists concurrency as one bullet among edge cases, with no signal that it
  matters more for some work than others, so it is routinely skipped.
- `code-review` is diff-local by design; each changed line reads correct in isolation, and
  a race is only visible across requests and time.
- `setup-project-harness` configures formatters, linters, typecheckers, SCA, and secret
  scanning — none of which detect business-level concurrency races.

The reminder lived nowhere that could refuse to let the work proceed.

## Decision

1. **Force lives in a failure-driven rule file, not a skill gate.** A
   `.agents/rules/invariants/invariants.md` is the single forcing surface for this
   postmortem. Skills (`grill-me`, `code-review`) point at it when edges or diffs match;
   `AGENTS.md` stays wiring + Checklist only and does not restate the contract. This
   respects ADR 0001's principle that skills are freely composable and no skill
   prescribes a sequence.
2. **The trigger is a concrete classifier, not a broad gate.** The rule fires only when the
   work's correctness depends on a shared mutable invariant and more than one actor can
   touch the same instance. The rule enumerates the family — quantity held, counter/tally,
   sequence/version, state machine, once-only/uniqueness, capacity bound, time-window,
   derived consistency — so it scans exhaustively without becoming "check every PR for
   concurrency," which the repo's `[FORBID]` on broad generic rules rules out.
3. **Three must-carry artifacts on match.** Whatever layer the role works in, matching work
   carries: the invariant (what must hold), the concurrency contract (the named mechanism
   and why alternatives were rejected), and a concurrency test seam (real concurrency, not a
   serial unit test). Reconciliation is a backstop, never the sole guard.
4. **Skills discover, they do not gate.** `grill-me`'s edge-case layer and `code-review`'s
   correctness axis each gain one pointer sentence to the rule. An agent that does not run
   those skills and whose work does not match the invariant trigger is unaffected.

## Considered Options

- **An always-on concurrency checklist gate inside `to-prd` or `code-review`.** Rejected on
  two grounds. It violates ADR 0001 by baking a forcing gate into a specific skill, which
  is invisible to any role that does not run that skill (a tester never runs `to-prd`). And
  a gate that fires on every PR is exactly the broad generic rule this repo forbids; it
  becomes noise and gets skipped, reproducing the original failure.
- **Make `grill-me` ask harder about concurrency.** Rejected: this is still a reminder, and
  reminders get skipped — the original bug already proved that a present-but-unweighted
  mention does not catch the race.
- **A language- or layer-specific rule (e.g. `backend/` or `database/`).** Rejected: the
  invariant family is language- and layer-neutral. A balance is a SQL row lock, a quota is a
  Redis `INCR`, a state machine is an application lock. Pinning the rule to one layer would
  miss the same bug in a different stack.

## Consequences

- `.agents/rules/invariants/` is the reference pin; harness setup (§E) only copies it when
  the consumer has a matching failure risk — not as a default rules constitution.
- `grill-me` and `code-review` gain one discover sentence each; they do not gain a gate.
- The two shapes that caused the original bug — serial-only tests as sole verification, and
  async reconciliation as sole guard — are now `[FORBID]` for matching work.
- Any future skill that wants to reference this boundary points at the rule rather than
  re-stating the contract, keeping the single source of truth in the rule file.
