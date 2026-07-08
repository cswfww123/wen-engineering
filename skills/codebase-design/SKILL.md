---
name: codebase-design
description: Provides deep-module design vocabulary. Use for module interfaces, seams, testability, or architecture refactors.
---

# Codebase Design

Design deep modules: lots of behavior behind a small interface, placed at a clean seam, testable through that interface.

Use this language wherever code is being designed or restructured. The aim is leverage for callers, locality for maintainers, and testability for everyone.

When applying this vocabulary to existing code, trace representative entrypoints before judging depth, caller leverage, hidden implementation behavior, seam placement, or testability.

## Glossary

Use these meanings for design discussion. Preserve local code and domain names when naming real artifacts.

**Module**: anything with an interface and implementation. It can be a function, class, package, or tier-spanning slice. Avoid using unit, component, or service as substitutes for this concept unless those are the repo's real artifact names.

**Interface**: everything a caller must know to use the module correctly: type surface, invariants, ordering constraints, error modes, configuration, and performance characteristics. Avoid using API or signature as substitutes for this concept unless those are the repo's real artifact names.

**Implementation**: what is inside a module. Use **adapter** when the seam role is the topic; use implementation otherwise.

**Depth**: leverage at the interface. A module is **deep** when much behavior sits behind a small interface, and **shallow** when the interface is nearly as complex as the implementation.

**Seam**: a place where behavior can change without editing that place. It is where a module's interface lives. Avoid using boundary as a substitute for this concept unless that is the repo's real domain term.

**Adapter**: a concrete thing that satisfies an interface at a seam.

**Leverage**: what callers get from depth: more capability per unit of interface they learn.

**Locality**: what maintainers get from depth: change, bugs, knowledge, and verification concentrate in one place.

## Deep Vs Shallow

Deep module:

```text
small interface
----------------
deep implementation
```

Shallow module:

```text
large interface
----------------
thin implementation
```

When designing an interface, ask:

- Can I reduce the number of methods?
- Can I simplify the parameters?
- Can I hide more complexity inside?

## Principles

- Depth is a property of the interface, not implementation size.
- The deletion test: if deleting the module makes complexity vanish, it was a pass-through. If complexity reappears across callers, it was earning its keep.
- The interface is the test surface. If tests need to go past the interface, the module is probably the wrong shape.
- One adapter means a hypothetical seam. Two adapters means a real seam.
- A deep module can have internal seams, but they should not leak into the external interface.

## Designing For Testability

Good interfaces make testing natural:

- Accept dependencies; do not create them internally.
- Return results; avoid hidden side effects.
- Keep surface area small.
- Test behavior through the same interface callers use.

## Relationships

- Discuss a module as having one interface for design purposes; real artifacts may expose multiple entrypoints that together form that interface.
- Depth is measured against the interface.
- A seam is where the interface lives.
- An adapter sits at a seam and satisfies the interface.
- Depth produces leverage and locality.

## Rejected Framings

- Do not define depth as implementation-lines divided by interface-lines; that rewards padded implementation.
- Do not treat interface as only the TypeScript `interface` keyword or public methods.
- Do not say boundary when you mean seam.

## Going Deeper

- [DEEPENING.md](DEEPENING.md): dependency categories, seam discipline, and replace-don't-layer testing.
- [DESIGN-IT-TWICE.md](DESIGN-IT-TWICE.md): explore radically different interface alternatives, then compare on depth, locality, and seam placement.
