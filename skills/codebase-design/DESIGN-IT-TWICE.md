# Design It Twice

Use this when the user wants to explore alternative interfaces for a chosen deepening candidate.

The first idea is unlikely to be the best. Produce several radically different interfaces before choosing.

## Process

### 1. Frame The Problem Space

Before spawning helpers or drafting alternatives, write a user-facing explanation of:

- constraints the new interface must satisfy
- dependencies it relies on and their category from [DEEPENING.md](DEEPENING.md)
- a rough code sketch to ground constraints, not as a proposal

Show this to the user, then proceed to alternatives.

### 2. Explore Alternatives

Create at least three radically different interface designs. Use native subagents when available, or reason through the variants yourself when not.

Give each variant a different constraint:

- minimize the interface; aim for 1-3 entry points
- maximize flexibility and extension
- optimize for the most common caller
- design around ports and adapters when cross-seam dependencies matter

Each variant should include:

1. Interface: methods, params, invariants, ordering, and error modes
2. Usage example
3. What the implementation hides behind the seam
4. Dependency strategy and adapters
5. Trade-offs in depth, locality, and seam placement

### 3. Compare And Recommend

Present designs sequentially, then compare them in prose.

Contrast by:

- depth: leverage at the interface
- locality: where change concentrates
- seam placement: where the interface lives

Give a strong recommendation. If pieces from multiple variants combine well, propose a hybrid.
