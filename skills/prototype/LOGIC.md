# Logic Prototype

Use this branch when the question is about business rules, state transitions,
data shape, permissions, pricing, quotas, or another behavior that needs to be
driven through examples.

## Process

1. State the question in a short README, note, or top-of-file comment.
2. Use the project's existing language and task runner.
3. Put the decision logic behind a small pure interface where practical:
   reducer, state machine, pure function set, or tiny module.
4. Build the thinnest interactive shell around it. A terminal loop is enough:
   show current state, list commands, accept one action, re-render.
5. Keep all state in memory unless persistence is the thing being tested.
6. Give the user the exact command to run.
7. Record what the prototype proved, then delete the shell or lift only the
   validated logic into production work.

## Avoid

- tests for the prototype shell
- real customer data or production databases
- speculative options unrelated to the named question
- terminal or prompt code mixed into the portable logic
- leaving the shell in the repo after the answer is known
