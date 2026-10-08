# Expand–Contract Ticketing

Load this branch only for a wide mechanical refactor whose blast radius prevents
an independently green vertical slice.

## Sequence

1. **Expand** — add the new form beside the old behind a compatibility seam.
   Existing callers and behavior remain valid.
2. **Migrate** — group callers into the smallest independently verifiable
   batches. Each migration ticket is blocked by Expand and covers an explicit
   blast-radius segment.
3. **Contract** — remove the old form only after every migration ticket is
   complete and repo evidence shows no remaining caller. Contract is blocked by
   every migration ticket.

Keep CI green after each ticket. If a migration batch cannot be green alone,
make the exception explicit: use an authorized integration branch and block a
final integrate-and-verify ticket on every batch. Do not claim per-ticket green
status when only the integration point can prove it.

The same ticket fields and one-fresh-context sizing still apply. Tickets that
change observable behavior use normal `Covers: REQ-###` traceability. A purely
mechanical expand, migrate, or contract ticket uses:

```text
Covers: none
Supports: REQ-###, ...
Decision: DEC-### | <stable ADR reference>
```

`Supports` never satisfies behavior coverage. Its acceptance criteria and
verification must prove the stated compatibility boundary and unchanged
behavior at that migration step.

For a legacy source, substitute its stable source reference for `REQ-###`.
