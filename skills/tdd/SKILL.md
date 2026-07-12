---
name: tdd
description: Vertical Red-Green-Refactor through public-behavior tests. Use for TDD, test-first, regressions, or bug fixes.
---

# Test-Driven Development

Tests verify **observable behavior through public interfaces**, not implementation. Prefer vertical tracer bullets over horizontal "all tests then all code."

Detail: [tests.md](tests.md), [mocking.md](mocking.md), [refactoring.md](refactoring.md).

## Workflow

### 0. Context

When `/implement` or another skill loads this, use its ticket, AC, and public surface — do not restart from `CONTEXT.md`. Otherwise read relevant context/ADRs, confirm the public interface and prioritized behaviors (behaviors, not impl steps). Trace the entrypoint before the first RED when changing existing behavior or picking a seam in unfamiliar code. Ask only for user-owned or undiscoverable decisions.

### 1. Tracer Bullet

```text
RED  → one test for one behavior → fails
GREEN → minimal code to pass
```

Proves the path end to end.

### 2. Incremental Loop

For each remaining behavior: same RED → GREEN. One test at a time; only enough code for the current test; no anticipating future tests.

### 3. Refactor

Only after GREEN. Refactor, re-run tests after each step. Never refactor while RED.

## Per Cycle

- behavior-named test via public interface (survives internal refactor)
- minimal code for this test; no speculative features

## Done

Planned behaviors have passing public-behavior tests; code is minimal; refactor done with tests still green.
