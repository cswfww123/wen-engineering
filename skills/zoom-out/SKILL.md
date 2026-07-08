---
name: zoom-out
description: Ask the agent to zoom out a level and map the relevant modules and callers using the project's domain language.
disable-model-invocation: true
---

# Zoom Out

You are in unfamiliar code. Go up one level of abstraction and map the surrounding area so you can reason about it.

## What To Produce

A compact module map with three sections:

```markdown
## Zoom Out: <area name>

### Modules

- **<module>** — <one-line responsibility> → called by: <callers> → calls: <key dependencies>

### Data Flow

<How data enters, transforms, and exits this area. 2-4 sentences max.>

### What I Still Don't Know

- <unresolved questions about this area, if any>
```

## Depth

Map at **module level** — packages, services, or top-level files. Do not descend to individual functions or classes unless a module is the only file in the area.

If the module map depends on exact behavior, callers, queries, converters, permissions, or side effects, trace the relevant entrypoint, then summarize the result back at module level.

Use the project's domain glossary from `CONTEXT.md` for names. Do not invent new terms.

## Scope

Map only the area directly surrounding the code you were just looking at. Do not map the entire codebase.

When the map is clear enough to reason about the original question, stop.
