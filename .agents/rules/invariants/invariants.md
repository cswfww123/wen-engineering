# Shared Mutable Invariants

Applies to: any work — spec, ticket, legacy PRD/issue, code, or test — that reads or writes a shared mutable invariant
Source: billing under-charge postmortem (concurrent message billing skipped charges under fast send); `.agents/rules/project/agent-workflow.md` `[FORBID]` on broad generic rules

## Recognize — The Trigger

This rule fires when the work's correctness depends on a condition that must always hold, AND more than one actor or request can touch the same instance of the state that upholds it. Scan exhaustively — this is a family of risks, not just money:

- **Quantity held** — balance, credit, quota, inventory, token bucket, seat count
- **Counter or tally** — counts, sums, streaks; any `parent == Σ children` aggregate
- **Sequence or version** — order number, version, etag, monotonic id, cursor
- **State machine** — order/payment/task lifecycle transitions
- **Once-only or uniqueness** — coupon claim, lottery draw, award grant, refund, register-once, dedupe
- **Capacity bound** — max-N slots, pool size, window size, hard upper limit
- **Time-window** — daily-once, first-N-minutes, cooldown, rate window
- **Derived consistency** — cache == source, read-model == write-model, redundant rollup, materialized summary

None of the above hit ⇒ this rule does not apply. The trigger is concrete on purpose: a gate that fires on everything fires on nothing and violates the repo's `[FORBID]` on broad generic rules.

## Must Carry — When The Trigger Hits

Regardless of which skill you are running, the matching work must carry three artifacts. They live in whatever layer the role is working in — the spec, ticket body, legacy PRD/issue, code comments, or test:

1. **Invariant** — state the condition that must always hold.
   - `balance ≥ 0`; `Σ charges == Σ credits`; `coupon claimed at most once per user`; `order.status never goes paid → pending`.
2. **Concurrency contract** — name the mechanism that upholds the invariant under concurrent access, and say why the alternatives were rejected:
   - atomic conditional write (`UPDATE ... SET x = x - d WHERE x >= d`, `INCR`, CAS)
   - optimistic lock (version/etag + retry)
   - pessimistic lock (row lock, `SELECT FOR UPDATE`, distributed lock)
   - idempotency key (dedupe by key)
   - single-writer serialization (queue, actor, leader)
   - isolation level (serializable, snapshot)
   - async reconciliation — backstop only, never the sole guard
3. **Concurrency test seam** — at least one seam that executes the invariant under real concurrency and asserts it. A serial unit test does not satisfy this.
   - concurrent test harness (N goroutines/threads firing the same operation)
   - parallel property test
   - load test + invariant assertion
   - reconciliation + assertion

## Rules

- [MUST] Read this rule before editing work that matches the trigger above.
- [MUST] Carry the three artifacts (Invariant, Concurrency contract, Concurrency test seam) with matching work, in whatever layer the role operates.
- [FORBID] Shipping a matching change whose only verification is serial unit tests. A concurrency test seam is required.
- [FORBID] Using async reconciliation as the sole concurrency guard. Reconciliation catches drift; it does not prevent the race.

## Verify

- Grep the diff, spec, ticket, or legacy PRD/issue for invariant keywords (balance, quota, counter, inventory, status, claim, once, limit, window). On a hit, confirm all three artifacts are present and a concurrency test seam exists.
- If a matching change has no concurrency test seam, block it: the original bug shape (serial tests only) is exactly what this rule exists to stop.

## Exceptions

- Read-only display pages, pure CRUD without a quantity/state invariant, and one-shot scripts that touch no shared state do not match the trigger and are out of scope.
- When the invariant is genuinely enforced by an external system the work does not own (e.g. a payment provider's atomic charge), record that as the concurrency contract with a citation; the local seam may then assert the call's idempotency instead of re-testing the provider's atomicity.
