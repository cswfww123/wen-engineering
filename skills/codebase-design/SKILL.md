---
name: codebase-design
description: Deep-module vocabulary for interfaces, seams, testability, and architecture refactors.
---

# Codebase Design

Design **deep modules**: much behavior behind a small interface, at a clean seam, testable through that interface. Use this language when designing or restructuring code. Trace representative entrypoints before judging depth, leverage, seams, or testability on existing code.

Going deeper: [DEEPENING.md](DEEPENING.md), [DESIGN-IT-TWICE.md](DESIGN-IT-TWICE.md).

## Glossary

Preserve local code/domain names when naming real artifacts.

| Term | Meaning |
| --- | --- |
| **Module** | Anything with interface + implementation (function, class, package, slice). Avoid unit/component/service as substitutes unless those are the repo's names. |
| **Interface** | Everything a caller must know: types, invariants, ordering, errors, config, performance. Not only a language `interface` keyword. |
| **Implementation** | Inside the module. Say **adapter** when the seam role matters. |
| **Depth** | Leverage at the interface: deep = much behavior / small interface; shallow ≈ interface as complex as impl. Not “lines of impl / methods.” |
| **Seam** | Where behavior can change without editing that place — where the interface lives. Prefer “seam” over vague “boundary” unless boundary is the domain term. |
| **Adapter** | Concrete thing that satisfies an interface at a seam. |
| **Leverage** | What callers get from depth. |
| **Locality** | What maintainers get: change, bugs, knowledge, verification concentrate. |

## Principles

- Depth is an interface property, not implementation size.
- Deletion test: delete the module — if complexity vanishes it was a pass-through; if it reappears across callers it earned keep.
- Interface is the test surface; tests that must pierce the interface usually mean wrong shape.
- One adapter = hypothetical seam; two adapters = real seam.
- Internal seams must not leak into the external interface.

## Testability

Accept dependencies (don't construct them inside); return results (avoid hidden side effects); small surface; test through the same interface callers use.

## Rejected

- Depth ≠ impl-lines ÷ interface-lines (rewards padding).
- Interface ≠ only public methods / TS `interface`.
- Don't say boundary when you mean seam.
