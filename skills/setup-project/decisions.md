# Decisions

This file is the part the lessons system deliberately does not cover. Lessons
optimize doing a decision correctly. They do not decide whether it was the
right decision. That gap is the maintainer's, and it is recorded here so an
agent does not fill it.

## How a decision gets made

- The maintainer says what is wrong, usually in one line, often as a
  complaint about what they are looking at. The agent turns that line into a
  verifiable change and keeps the line verbatim in the commit subject.
- A decision recorded in the table below is deliberate. A PR does not reverse
  it. A review that finds one reversed leaves it for the maintainer.
- Where two designs both work, the agent does not pick by taste. It cites the
  row below, or it asks. Claude Code's memory and the design docs in
  [subsystems/](subsystems/README.md) are the other two inputs, and they are
  read, not invented.

## What the maintainer still does

- Direction. What gets built, what gets refused, what "ugly" means.
- The gate. A harm check that fires waits for the maintainer. An agent
  proposes a block; the maintainer decides.
- The night pass on UI. The loops do not see taste. A person looks.

The maintainer does not write, review, merge, or release. Those are the
loops.

## Deliberate decisions

Add a row when the maintainer makes a call an agent would otherwise redo.
Date it. A row with no date is a rumor and an agent may not cite it.

| Date | Decision | Do not |
| --- | --- | --- |
| — | none recorded yet | — |

## Real machines

A platform claim needs the platform. The working set is:

- one macOS machine
- one Windows machine
- one Linux VM on the Windows machine

A bug is reproduced on the machine the reporter used, then fixed there. A
cross-compile is not that reproduction. Without the three machines, acceptance
criterion 5 degrades into an honest "not run" on every platform bug — honest,
and still unfixed. Say so rather than implying the check happened.
