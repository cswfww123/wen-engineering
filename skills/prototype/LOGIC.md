# Logic Prototype

Use this branch when the question is about business rules, state transitions,
data shape, permissions, pricing, quotas, or another behavior that needs to be
driven through examples.

## Process

1. State the question and resolution signal in the artifact README.
2. Use the project's existing language and task runner.
3. Put the decision logic behind a small pure interface where practical:
   reducer, state machine, pure function set, or tiny module.
4. Build the thinnest interactive shell around it. A terminal loop is enough:
   show current state, list commands, accept one action, re-render.
5. Keep all state in memory unless persistence is the thing being tested.
6. Give the user the exact command to run.
7. Record examples tried, the answer, and remaining uncertainty in `RESULTS.md`.
   Recommend whether the caller should keep, delete, or promote the decision.

## Avoid

- tests for the prototype shell
- real customer data, production databases, or existing production behavior
- speculative options unrelated to the named question
- terminal or prompt code mixed into the portable logic
- manifest changes or new runtime dependencies
