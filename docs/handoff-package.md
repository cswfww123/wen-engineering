# PM → Engineering Handoff Package

Companion to [boundaries.md](boundaries.md). Defines what engineering admits
before `/to-spec` or `/implement` on product-originated UI/work.

## Default spine

```text
PM: Build|Bet → to-prd (Product Delivery Contract)
  → test-scenarios (SCN-*)
  → [optional] to-issues (human board only)
  → eng: /to-spec → /to-tickets → /implement
  → /qa-run (behavior + UI fidelity when visual)
```

PM `to-issues` is never the agent execution frontier. Runnable work is only
`Kind: implementation-ticket` under an accepted eng spec (or a one-context
`/implement` with an explicit acceptance boundary).

## Package contents

| Layer | Required when | Artifacts |
| --- | --- | --- |
| Authorization | always | Build or complete Bet |
| Behavior contract | always | PRD with `REQ-*`, `AC-*`, scope/out-of-scope |
| Scenarios | always for multi-slice or UI; strongly preferred otherwise | `SCN-*` from `test-scenarios` |
| UI contract | any user-visible surface | `SCR-*`, `FLD-*`, `RULE-*`, UI states |
| Delivery prototype pin | UI contract present | versioned path/URL/export id + frames |
| Feasibility notes | when known | confirmed technical constraints |

## Engineering admission

### Always

- disposition and product intent are settled enough to implement without inventing value
- `REQ-*` / `AC-*` (or equivalent explicit acceptance) exist for in-scope behavior

### When UI is in scope

Admit only if **all** hold:

1. UI Contract present (not prose-only screenshots)
2. every interactive field has `FLD-*`; every conditional show/require has `RULE-*`
3. Delivery Prototype is **pinned** (version/id), or an explicit written reason
   why a pin is impossible and checklist-only fidelity applies
4. material UI `AC-*` exist; prefer `SCN-*` covering main + linkage paths

If any fail: **stop**, list missing IDs/sections, recommend PM `to-prd` /
grilling / pin update. Do not invent fields or copy in `/to-spec`.

## Two completion gates (implement / QA)

| Gate | Proves | Evidence |
| --- | --- | --- |
| **Behavior gate** | logic, permissions, data, API contracts | tests, SCN, verification commands |
| **Fidelity gate** (UI tickets) | fields, labels, visibility/required linkage, empty/error/loading states match contract + pin | FLD/RULE checklist, SCN linkage paths, screenshot or structured compare vs pin |

A ticket with UI scope must not close on behavior-green alone. Fidelity failures
that mean "contract wrong" return to PM; "implementation wrong" stay in eng.

## ID spine

```text
EV/X/A/D → REQ → AC → SCN → eng ticket → test/QA evidence
                ↘ SCR/FLD/RULE (UI)
```

Preserve PM IDs in eng specs/tickets (`Covers`, evidence links). Do not renumber
product IDs without an explicit migration note.
