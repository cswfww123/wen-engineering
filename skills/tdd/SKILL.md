---
name: tdd
description: Guides Red-Green-Refactor development. Use for TDD, test-first work, regression tests, or bug fixes.
---

# Test-Driven Development

## Philosophy

Tests should verify behavior through public interfaces, not implementation details. Code can change entirely; tests should not.

Good tests are integration-style: they exercise real code paths through public APIs. They describe what the system does, not how it does it. A good test reads like a specification: "user can checkout with valid cart" tells you exactly what capability exists.

Bad tests are coupled to implementation. They mock internal collaborators, test private methods, or verify through external means instead of the public interface.

See [tests.md](tests.md), [mocking.md](mocking.md), and [refactoring.md](refactoring.md).

## Anti-Pattern: Horizontal Slices

Do not write all tests first, then all implementation. That treats RED as "write all tests" and GREEN as "write all code."

Correct approach: vertical slices via tracer bullets.

```text
WRONG:
  RED:   test1, test2, test3
  GREEN: impl1, impl2, impl3

RIGHT:
  RED -> GREEN: test1 -> impl1
  RED -> GREEN: test2 -> impl2
  RED -> GREEN: test3 -> impl3
```

## Workflow

### 1. Planning

Before writing code:

- read `CONTEXT.md` or relevant context docs when present
- respect ADRs in the area you are touching
- confirm the public interface change
- confirm the behaviors to test and their priority
- list behaviors, not implementation steps

Ask only for decisions that are user-owned or not discoverable from the repo.

### 2. Tracer Bullet

Write one test that confirms one behavior:

```text
RED:   Write test for first behavior -> test fails
GREEN: Write minimal code to pass -> test passes
```

This proves the path works end to end.

### 3. Incremental Loop

For each remaining behavior:

```text
RED:   Write next test -> fails
GREEN: Minimal code to pass -> passes
```

Rules:

- one test at a time
- only enough code to pass the current test
- do not anticipate future tests
- keep tests focused on observable behavior

### 4. Refactor

After all tests pass, look for refactor candidates. Run tests after each refactor step.

Never refactor while RED. Get to GREEN first.

## Checklist Per Cycle

- test describes behavior, not implementation
- test uses public interface only
- test would survive internal refactor
- code is minimal for this test
- no speculative features added
