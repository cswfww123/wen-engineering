---
name: improve-codebase-architecture
description: Finds deepening opportunities and writes an HTML architecture report. Use for architecture review or module deepening.
disable-model-invocation: true
---

# Improve Codebase Architecture

Surface architectural friction and propose deepening opportunities: refactors that turn shallow modules into deep ones. The aim is testability and AI-navigability.

This workflow uses:

- `/codebase-design` for module, interface, depth, seam, adapter, leverage, and locality vocabulary
- `/deep-code-trace` for representative entrypoints, call chains, queries, conversions, and side effects
- `/domain-modeling` for glossary and ADR awareness
- `/grilling` after the user picks a candidate

## Process

### 1. Explore

Read the project's domain glossary and relevant ADRs first:

- `CONTEXT.md`, or `CONTEXT-MAP.md` plus the relevant context
- `docs/adr/` and context-specific ADRs when present

Then walk the codebase. Use native subagents for bounded exploration if available. Otherwise use normal repo search and file reads.

For every serious candidate, load `/deep-code-trace` on at least one representative entrypoint before calling a module shallow, tangled, hard to test, or worth deepening.

Look for friction:

- understanding one concept requires bouncing between many modules
- modules are shallow: interface nearly matches implementation
- pure functions were extracted only for testability, but bugs hide in orchestration
- tightly coupled modules leak across seams
- important behavior is untested or hard to test through the current interface

Apply the deletion test to suspected shallow modules. If deleting the module would just move complexity around, it is probably shallow.

### 2. Write HTML Report

Write a self-contained HTML file to the OS temp directory, not the repo.

Resolve temp dir from `$TMPDIR`, then `/tmp`, or `%TEMP%` on Windows. Write to:

```text
<tmpdir>/architecture-review-<timestamp>.html
```

Open it for the user and provide the absolute path.

The report should use Tailwind via CDN and Mermaid via CDN. Use Mermaid for graph-shaped diagrams and handcrafted CSS/SVG for editorial visuals. Each candidate gets before/after visualization.

For each candidate, render:

- files/modules involved
- problem
- solution
- benefits in locality, leverage, and testability
- before/after diagram
- recommendation strength: `Strong`, `Worth exploring`, or `Speculative`

End with a top recommendation.

Use `CONTEXT.md` vocabulary for domain names and `/codebase-design` vocabulary for architecture. If a candidate conflicts with an ADR, surface it only when the friction is real enough to justify revisiting the ADR.

See [HTML-REPORT.md](HTML-REPORT.md).

Do not propose interfaces yet. After the file is written, ask which candidate the user wants to explore.

### 3. Grill The Picked Candidate

Once the user picks a candidate, run `/grilling` to walk the design tree: constraints, dependencies, module shape, what sits behind the seam, and what tests survive.

Run `/domain-modeling` inline as decisions crystallize:

- add new domain terms to `CONTEXT.md`
- sharpen fuzzy terms immediately
- offer ADRs only for load-bearing, future-relevant decisions
- use `/codebase-design` and [DESIGN-IT-TWICE.md](../codebase-design/DESIGN-IT-TWICE.md) when exploring alternative interfaces
