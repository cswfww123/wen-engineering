# Product Fog Docket

Fill during `/product-fog`. Cite sources (path, quote, person, date) inline.
Leave blanks as `UNKNOWN` or `Unresolved` — never invent.

```markdown
## Classification

- Track: pure-eng | existing-change | new-idea
- Rationale: <one sentence>
- Sources inspected: <list>
- Inaccessible: <list or none>

## Mini Docket

### existing-change (if applicable)

- User / scenario / outcome:
- **Current** (repo/runtime):
- **Expected** (decision | quote | Unresolved):
- **Delta**:
- Keep / Change / Remove:
- Regression risks:

### new-idea (if applicable)

- Proposed user / situation:
- Current alternative / cost:
- Desired outcome:
- Load-bearing assumption (one):
- Smallest falsification idea:

## Four-Risk Snapshot

| Risk | Status | Notes |
| --- | --- | --- |
| Value | green \| yellow \| red \| UNKNOWN | |
| Usability | green \| yellow \| red \| UNKNOWN | |
| Feasibility | green \| yellow \| red \| UNKNOWN | |
| Viability | green \| yellow \| red \| UNKNOWN | |

## Disposition

- Disposition: pure-eng | Align | Build-ready | Discovery | Pause | Kill | Escalate-PM
- Why (evidence only):

## One Next Action

- Action: <single skill or stop instruction>
- Owner: <user | agent | named role>
- Completion signal: <checkable>
```

## Weak forms to reject

- Expected filled without a decision, quote, or explicit Unresolved
- Discovery complete without any real user or behavioral source
- Build-ready with only enthusiasm and no acceptance boundary
- Menu of three next skills instead of one disposition
