# Code standards

A reviewer checks each rule that applies. A change that misses one gets a
comment naming which. These are judgement rules. A mechanical miss (a banned
API, an import shape, a file location) belongs in the repo's own check, not
here.

A rule arrives here two ways. The nightly review moves a lesson seen on 3
separate days. A miss that shipped broken to a user the same day is written
here that night, evidence attached, without waiting for 3. Either way the
evidence stays, so a later agent can see why the rule exists.

The rules below are the seed, taken from yetone/magpie as checked on
2026-10-13. They are already in force. A review that finds one missed records
the miss in `LESSONS.md` under the rule. Promotion is not compliance.

## What a change contains

| Rule | What a reviewer looks at |
| --- | --- |
| A change does only what its goal needs. | Every behavior change has a reason. Unrelated refactors, extra features, and policy changes go in a change of their own. |
| A fix covers exactly the cases it means to. | Which cases change, and which neighboring ones stay the same. Different errors are not handled as one. |
| A change holds on the whole path. | Follow it from the user's input to the end result, through the callers, the state it changes, and the side effects. One correct function does not make the operation correct. A value saved under one id is read under the same id. A button updates the thing that actually runs. |
| A fix reaches every sibling of the bug. | Grep for the same pattern. Every caller of the same shape, every branch of the same operation, and every message that names the same rule gets the fix in the same change. |
| A change re-derives everything built on what it changes. | When a formula, a list, a layout breakpoint, or the timing of an async step changes, find every caller, saved copy, and test that assumed the old meaning, and run it. |
| Checks cover the edges the change touches. | Numbers: the boundaries. Paths: each platform. Concurrency: races and stale state. Pick checks by risk. |

## Tests

| Rule | What a reviewer looks at |
| --- | --- |
| A fix comes with a test that fails without it. | Put the old code back and run the test. It must fail. The record says what it failed with. |
| Tests use real inputs. | Fixtures look like real requests, real serialized output, and real files. Include missing fields, empty values, and defaults. Build a fixture from the reporter's literal bytes, not a similar sample. |
| Tests check behavior, not implementation. | Assert what the user or caller needs. A formatting change should not break a test unless exact bytes are the requirement. |
| A test that fails on the integration branch is a bug to fix now. | "Fails the same on main" is not a baseline, and neither is "fails under the full run, passes alone". Fix it at its cause, or open an issue naming the cause, in the same commit, before shipping on top of it. Name the sha just fetched. |
| A test never touches the real machine. | Run under a temp home with caches pinned. Never read or write a live config or a real credential. |
| Whatever a test starts ends when the test does. | A fake process, a goroutine, or an async refresh the test starts is stopped or waited for before the test returns. |
| A timing test leaves room on both sides. | Never bound a test by a wall-clock time a loaded runner can exceed. Reproduce a timing failure by injecting the delay, not by rerunning until it fails. |
| A test named for a guarantee fails when the guarantee breaks. | Break the guarantee by hand and watch the test go red. A test that still passes does not count. |

## Acceptance

A change is merged only when the record shows each of these. A check that was
not run is listed as not run, never left out.

1. **A test that fails without the change.** Put the old code back and run
   the new test. It fails with a real `FAIL` that names the behavior. A
   compile error or a skipped test does not count. Say which test, and what
   it failed with. Restore the change. The test passes.
2. **Break it on purpose.** Revert the fix, or break the code it guards in
   more than one way. The new tests catch each break. Reading the diff is not
   a review.
3. **Tests in a sandbox.** A temporary home, caches pinned, removed afterwards.
   A test never reads or writes a live config or a real credential.
4. **The build and the suite, on each platform the change claims.** A
   cross-compile does not compile the tests, and it is not a run on that
   platform. A platform report is checked on that platform.
5. **Real use where the change touches a real system.** A real account or key,
   the real config format, the real reply, in a sandbox with copies of the
   credentials. Never touch the live system. What was not tried is not built
   on, and is not told to users as working. When two guesses about a vendor
   differ, design the check that tells them apart, or ask the reporter to run it.
6. **The UI rules of this repo**, when the change has a UI. Run the GUI suite
   in every engine and every language the app ships, including the narrow
   width. If CI does not run that suite, run it locally and say so.

Write what was run, at which head, then merge. A merge with no record cannot
be checked afterwards.

Merge only the reviewed head. A push during the review stops the merge. A head
pushed after the review is reviewed again, and the comment names the new head.

## Reviewing a change

- **Run it.** Pull the head, merge it onto current main, run the acceptance
  checks. Reading the diff alone is not a review.
- **Check the vendor, not the change's account of it.** Read the upstream
  source for a vendor's behavior. Try the change against a real upstream.
- **Check each platform.** An integer conversion safe on one architecture can
  wrap on another. A refused connection is reported differently per OS.
- **Follow the whole path.** Saved and read under the same id. The button
  works on the thing that actually runs. Aliases do not collide.
- **Classify narrowly.** Decide whether a refusal is about the account, the
  model, or the request content before resting an account or relabeling the
  error. Fix what the error is about, not only how it is worded.
- **Scope a rule to what it is about.** A vendor rule stays on that vendor. A
  privacy or security exemption is scoped by where the value sits in the
  protocol, never by a key's name. Test the exemption with the protected key
  placed where the user's data goes.
- **A security gap a doc names is an open bug, not a description.** File the
  issue in the same commit as the sentence, and reproduce it.
- **A preview writes nothing.** A dry run, a plan, or a preview has no side
  effects.
- **Do not reverse a deliberate decision.** Product decisions the maintainer
  recorded are the maintainer's to change. A change that reverses one is left
  for them.
- **Docs match the source.** A reference is checked against the code it links.
  Every link resolves.
- **Keep the change to its goal.** One commit, one goal. A fix found on the
  way goes in its own commit.

## The user's own files

- A default never overrides a value the user set. Before writing a key, list
  everywhere that setting is read from. Test with a user-owned value present.
- A failed read, parse, or hash means unknown. It never means empty or equal.
  A file that does not parse is copied aside before it is written over. When a
  shared helper is wrong, fix the helper, not a private copy beside it.
- Before deleting or overwriting a live credential, find every record that
  could match the same key. Matching by display name is not matching by key.
- When users get a writable copy, test "the user edits it, then sync".

## Commits

A commit message names the area, then says what the user now sees, as plain
behavior. Give the issue or the reporter. The body says how it was verified,
and which test fails without the change.

A large commit has a body. A squash merge's message is written, not the host's
default: a subject and a body holding the change and what was run at the
reviewed head. Before pushing, check the message is a few KB at most.

The maintainer's one-line complaint stays verbatim in the subject, in
parentheses. The body is the agent turning that complaint into a verifiable
change.
