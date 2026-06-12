---
name: deep-code-trace
description: Traces an entry method through internal calls. Use for deep code analysis, debugging, reviews, or risky edits.
---

# Deep Code Trace

## Purpose

Use this skill when understanding only the entry method would miss business behavior.

Common hidden behavior includes:

- validation, state machines, and conditional branches
- Mapper/DAO query conditions, which often encode the real business rule
- asynchronous side effects such as messages, cache writes, and events
- conversion logic in MapStruct or custom converter classes

Core rule: after reading a method, follow every project-internal call until the chain reaches an external library, an already visited method, or a data-only boundary.

## Workflow

### 1. Read the entry method

Read the user-provided file, class, method, stack frame, endpoint, or test failure. Extract every project-internal call from the visible control flow.

### 2. Build the trace queue

Trace these project-internal calls:

- `this.someMethod()` same-class methods
- `service`, `manager`, `repository`, and `client` calls owned by the project
- `mapper` and DAO calls, including XML, annotations, `QueryWrapper`, SQL fragments, and query conditions
- MapStruct mappings and custom converters
- project utility methods
- project calls inside lambdas and method references
- project constants and enum fields that affect branching, status, query conditions, or output values

Do not trace implementation internals for:

- standard library methods
- third-party frameworks and libraries such as Spring, MyBatis-Plus, Hutool, Redis, React, or Express
- pure data constructors such as `new ArrayList<>()`
- enum `valueOf()` or `values()` implementations

### 3. Read queued calls in parallel

When several methods must be read, read or search them in parallel. If the location is unclear, prefer `rg -n "methodName" -g "*.java"` and fall back to `grep` only when `rg` is unavailable.

Maintain a visited ledger to prevent loops:

```text
Visited:
- UserService#validateUser(UserCreateDTO)
- UserMapper#selectByPhone(String)
```

Skip methods that are already in the ledger, but mention the skip in the report when it matters to the call tree.

### 4. Recurse until the chain closes

For each newly read method, repeat steps 2 and 3. Stop only when every branch reaches one of these boundaries:

- external library/framework behavior
- an already visited project method
- a data-only object or trivial constructor
- a project boundary that cannot be inspected locally; state the missing evidence

### 5. Report the trace

Return a compact report:

```markdown
## Call Tree

entryMethod()
|-- internalCallA()
|   |-- internalCallA1() [stops: mapper query read]
|   `-- internalCallA2() [stops: external library]
`-- internalCallB()
    `-- internalCallB1() [stops: already visited]

## Key Business Logic
- [Validation] ...
- [Database Query] ...
- [Conversion] ...
- [Side Effect] ...

## Risks And Notes
- ...
```

## Trace Rules

1. Read every branch in `if/else`, `switch`, early returns, error paths, callbacks, and async handlers.
2. Always read Mapper/DAO layers. Query conditions are business logic.
3. Never trust method names alone. A method named `convertToVO()` can filter, mask, branch, or enrich data.
4. Read MapStruct annotations and custom mapping methods. Mappings are behavior.
5. Trace cross-module project code, including common modules and shared utility modules.
6. If tracing is part of a risky edit, finish the trace before changing behavior unless the user explicitly asks for a fast patch.
7. Mark uncertainty as uncertainty. Do not invent missing query conditions, constants, or downstream effects.

## References

- `EXAMPLES.md` - Java/Spring trace example.
