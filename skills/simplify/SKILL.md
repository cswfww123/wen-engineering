---
name: simplify
description: Simplify changed code after larger edits. Use for cleanup, reuse, over-engineering, efficiency, or altitude.
---

# Simplify

Improve changed code quality without hunting behavior bugs. Use after non-trivial
implementation work, or when the user asks for cleanup, simplification, reuse,
or over-engineering review. Skip one- or two-line mechanical diffs.

## Scope

Review the current diff:

- user-provided PR, branch, commit, fixed point, or file path when present
- otherwise local staged and unstaged changes

If the diff is empty or only a tiny mechanical change, stop and say it was
skipped.

Do not change intended behavior, public contracts, auth, validation, migrations,
SQL semantics, or data transformations.

## Pass

Check only changed code and nearby helpers:

- **Reuse**: replace reimplemented helpers, local types, stdlib, or platform
  features with the existing thing.
- **Simplification**: remove redundant state, copy-paste variation, deep
  nesting, dead code, and comments that narrate obvious code.
- **Efficiency**: remove repeated computation, repeated IO, unnecessary
  sequential work, and long-lived closures that retain large scopes.
- **Altitude**: fix the shared owner instead of adding a caller-level bandaid
  when sibling callers have the same root cause.

## Fix

Apply small behavior-preserving fixes directly. Skip findings that need product
choices, broad refactors, correctness fixes, or security decisions.

Run the smallest relevant verification after edits. Report what was fixed, what
was skipped, and the verification result.
