---
name: deep-code-trace
description: Traces an entry point through internal calls. Use for deep code analysis, debugging, reviews, or risky edits.
---

# Deep Code Trace

## Purpose

Use when reading only the entry method would miss business behavior. Hidden behavior lives in:

- validation, state machines, and conditional branches
- data-access query conditions, which often encode the real business rule
- async side effects: messages, cache writes, events
- conversion, mapping, and serialization logic

Core rule: after reading a method, follow every project-internal call until the chain reaches an external library, an already visited method, or a data-only boundary.

## What Counts As A Project-Internal Call

Trace into anything the project owns, in any language:

- same-file or same-class methods and private helpers
- injected or constructed services, managers, repositories, handlers, clients
- data-access layers: ORM or repository methods, query builders, SQL or template fragments, raw queries — read the query conditions
- mappers, converters, serializers, and DTO/VO assemblers
- project utilities, shared modules, and common packages
- closures, lambdas, callbacks, and async handlers that call project code
- project constants and enum values that drive branching, queries, or output

Do **not** trace the implementation internals of:

- standard libraries and language builtins
- third-party frameworks and libraries (web frameworks, ORMs, queues, caches, UI libraries)
- pure data construction (empty collections, plain struct, record, or object literals)
- enum `valueOf`/`values` or trivial field accessors

## Workflow

1. **Read the entry** — the file, function, method, endpoint, handler, stack frame, or failing test the user named. Extract every project-internal call from the visible control flow.
2. **Build the queue** — list the internal calls found above. Maintain a **visited ledger** so you never re-read a method; pick one stable id format (e.g. `Module#function`) and stay consistent.
3. **Read queued calls in parallel** — when several methods are queued, read or search them in one batch, not serially. If a location is unclear, search by symbol name (prefer `rg`, fall back to `grep`).
4. **Recurse** — for each newly read method, repeat steps 2–3. Stop a branch only when it reaches an external library, an already-visited method, a data-only boundary, or a project boundary you cannot inspect locally (say so explicitly).
5. **Report** — compact call tree, key business logic, and risks or notes, using the template below.

If this trace supports a risky edit, finish the trace before changing behavior, unless the user explicitly asks for a fast patch.

### Report Template

```markdown
## Call Tree

entryMethod()
|-- internalCallA()
|   |-- internalCallA1() [stops: ORM query read]
|   `-- internalCallA2() [stops: external library]
`-- internalCallB()
    `-- internalCallB1() [stops: already visited]

## Key Business Logic
- [Validation] ...
- [Data access / query] ...
- [Conversion / mapping] ...
- [Side effect] ...

## Risks And Notes
- ...
```

## Hard Rules

1. **Names lie.** A name like `convertToVO`, `toDto`, `sanitize`, or `findActive` is not its body. Conversion, mapping, and data-access layers often hide the real rule — read them.
2. **Read every branch.** Every arm of `if/else`, `switch`/`match`, early returns, error and exception paths, callbacks, and async handlers must be traced. Branches that look unused still encode rules.
3. **Do not invent.** If you cannot read a query condition, constant, or downstream effect, mark it unknown. Never fabricate the missing piece.

## References

- `EXAMPLES.md` — trace examples in Java/Spring, Next.js/TypeScript, Rust, Go, and Python.
