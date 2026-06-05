# Deepening

How to deepen a cluster of shallow modules safely, given its dependencies.

This assumes the vocabulary in [SKILL.md](SKILL.md): module, interface, seam, adapter, depth, leverage, and locality.

## Dependency Categories

### 1. In-Process

Pure computation, in-memory state, no I/O.

Always deepenable. Merge the modules and test through the new interface directly. No adapter is needed.

### 2. Local-Substitutable

Dependencies that have local test stand-ins, such as PGLite for Postgres or an in-memory filesystem.

Deepenable if the stand-in exists. Test the deepened module with the stand-in running in the test suite. The seam can stay internal; no port is needed at the external interface.

### 3. Remote But Owned

Your own services across a network seam.

Define a port at the seam. The deep module owns the logic; the transport is injected as an adapter. Tests use an in-memory adapter. Production uses an HTTP, RPC, queue, or similar adapter.

Recommendation shape:

```text
Define a port at the seam, implement a production adapter and an in-memory test adapter, so the logic sits in one deep module even though it crosses a network seam.
```

### 4. True External

Third-party services you do not control.

The deepened module takes the external dependency as an injected port. Tests provide a mock adapter.

## Seam Discipline

- One adapter means a hypothetical seam. Two adapters means a real seam.
- Do not introduce a port unless at least two adapters are justified, usually production and test.
- Internal seams can exist inside a deep module, but do not expose them just because tests use them.

## Testing Strategy

Replace, do not layer:

- Old unit tests on shallow modules become waste once tests at the deepened interface exist.
- Write new tests at the deepened module's interface.
- The interface is the test surface.
- Tests assert observable outcomes, not internal state.
- Tests should survive internal refactors.
