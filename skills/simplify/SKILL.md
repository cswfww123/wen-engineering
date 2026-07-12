---
name: simplify
description: Behavior-preserving cleanup of non-trivial diffs. Use for reuse, over-engineering, efficiency, or altitude.
---

# Simplify

Improve changed-code quality without hunting behavior bugs. After non-trivial implementation, or when the user asks for cleanup/simplify/reuse/over-engineering review. Skip empty or one-/two-line mechanical diffs.

## Scope

User-provided PR/branch/commit/fixed point/path when present; else local staged + unstaged. Empty/tiny mechanical → stop, report skipped.

Do **not** change intended behavior, public contracts, auth, validation, migrations, SQL semantics, or data transformations.

## Passes (changed code + nearby helpers only)

- **Reuse** — existing helpers, local types, stdlib, platform features over reimplementation
- **Simplification** — redundant state, copy-paste, deep nesting, dead code, narrating comments
- **Efficiency** — repeated compute/IO, needless sequential work, long-lived closures holding large scopes
- **Altitude** — fix the shared owner, not a caller bandaid, when sibling callers share the root cause

## Fix

Small behavior-preserving fixes only. Skip product choices, broad refactors, correctness bugs, security decisions. Run smallest relevant verification. Report fixed / skipped / verification.

Multi-file or non-trivial cleanup: **hard try** project `Executor` per `docs/agents/orchestration.md` (then general-purpose → parent). Never abort simplify if `Executor` is missing.
