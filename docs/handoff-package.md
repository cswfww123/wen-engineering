# Delivery Package And Layer Scope

Companion to [boundaries.md](boundaries.md). Defines what engineering admits
before `/to-spec` or `/implement`, without requiring the companion `wen-pm`
pack.

## Standalone or linked

`wen-engineering` is a **coding lifecycle**. It works **alone** or **linked**
with optional `wen-pm` / `wen-test`. It does not assume `/pm-intake`, `to-prd`,
`/qa-run`, or any other pack is installed.

See also [boundaries.md](boundaries.md) composition contract.

Settled product intent may come from any durable source the project actually
uses, for example:

| Source | Examples |
| --- | --- |
| Companion PM (optional) | `wen-pm` Product Delivery Contract, `SCN-*`, UI contract |
| Other PM / design process | Confluence/Notion PRD, Linear epics, RFC, design review notes |
| In-repo product docs | `docs/prd/*`, `SPEC` precursors, accepted tickets with AC |
| Direct user authority | Named task + explicit acceptance boundary for one-context work |
| Pure engineering | Bug fix, migration, platform work with unchanged product behavior |

When product/market/need is **fundamentally fuzzy** (HEAVY), stop inventing and
use full product discovery (`wen-pm` `/pm-intake` or team PM) before this pack.
When intent is only mildly unclear in a coding context (LIGHT), use
`/product-fog` then grill/wayfinder as routed. Do not hard-depend on PM.

## Default coding spine

```text
settled delivery inputs (any source above)
  -> /to-spec -> /to-tickets -> /implement
  -> (optional) wen-test: /to-test-plan -> /qa-run
```

One-context work with a clear acceptance boundary may skip to `/implement`.

System test design and acceptance QA are **not** owned by `wen-engineering`
when the team uses `wen-test`. Developer fidelity checks during `/implement`
remain (layer-scoped UI/API match to the delivery package).

Human planning boards are never the agent execution frontier. Runnable work is
`Kind: implementation-ticket` under an accepted eng spec, or one-context
`/implement`.

## Delivery inputs by layer

Classify the **work surface** of the current ticket/spec (not the whole monorepo):

| Layer scope | Typical work | Behavior contract | UI contract + pin | API/contract notes |
| --- | --- | --- | --- | --- |
| **frontend** | pages, components, client state, browser UX | required | **required** when user-visible UI changes | consumer contract / mocks if BE is out of scope |
| **backend** | API, jobs, DB, authz, integrations | required | **not required** | request/response, errors, idempotency, migrations |
| **full-stack** | vertical slice across FE+BE | required | required for the UI part | end-to-end contracts |
| **non-UI** | CLI, library, infra, pure service | required | not required | public surface under change |

A developer who **only owns frontend** or **only owns backend** scopes
admission and completion gates to **their layer**, plus explicit integration
seams they consume or publish.

### Always (any layer)

- product intent settled enough to implement without inventing value, **or**
  pure engineering with unchanged product behavior / explicit user authority
- observable acceptance for in-scope behavior (`REQ`/`AC`, ticket AC, or
  equivalent written criteria)

### Frontend / user-visible UI (when this ticket touches UI)

Admit only if **all** hold (source may be PM or any design owner):

1. UI contract present: screens/fields/rules (IDs optional if team uses tables
   without `SCR`/`FLD` prefixes — structure matters more than prefix)
2. every interactive field and conditional show/require is specified
3. delivery design source is **pinned** (Figma/frame/export/path + version), or
   an explicit written reason for checklist-only fidelity
4. material UI acceptance criteria exist

If any fail: **stop**, list missing pieces, ask the **product/design owner**
(or optional `wen-pm` `to-prd` if that is the team's process). Do not invent
fields or copy.

### Backend-only (no user-visible UI in this ticket)

Do **not** demand UI contracts or prototype pins. Require instead:

- API or job contract: inputs, outputs, authz, error shapes, side effects
- data/migration impact when persistence changes
- compatibility with current consumers (or explicit expand/contract plan)
- acceptance that can be verified without a browser when no FE surface exists

### Cross-layer handoff (split FE/BE teams)

When one side is out of scope for this agent/ticket:

- record the **owned boundary** (e.g. "FE only; API assumed from OpenAPI@v")
- name the **integration seam** and who owns the other side
- do not implement the other layer "while we're here" without authority
- for FE-only: pin mock/fixture or published API version; fidelity is vs UI pin
- for BE-only: contract tests or API scenarios; no UI fidelity gate

## Completion gates

### Coding layer (`/implement`) — developer proof

| Gate | When | Evidence |
| --- | --- | --- |
| **Behavior** | every ticket | TDD/verification match acceptance for **this layer** |
| **UI fidelity** | ticket changes user-visible UI | checklist/compare vs UI contract + pin |
| **Contract fidelity** | ticket changes published API/events | contract checks |

Not a substitute for independent system QA (`wen-test` `/qa-run` or human QA).

### Test layer (optional `wen-test`)

System test plan + execution + Complete/Incomplete judgment + defects. See
that pack's `docs/boundaries.md`.

Failures during coding:

- **implementation drift** → fix in eng
- **contract/product wrong** → product/design owner (optional PM)

## ID spine (when IDs exist)

```text
product evidence/decisions → REQ/AC → scenarios → eng ticket → test/QA
                              ↘ UI field/rule rows (frontend)
                              ↘ API contract items (backend)
```

Preserve stable IDs from the delivery source when present. Do not renumber
without an explicit migration note. If the source has no IDs, create eng-local
stable IDs in the spec/ticket and keep them stable thereafter.

## Optional companion: wen-pm

If the team uses `wen-pm`, prefer its Delivery Contract + `test-scenarios` +
UI-CONTRACT shapes — they map cleanly onto this package. If not, any equivalent
structure is valid. Engineering skills must never fail solely because `wen-pm`
is absent.
