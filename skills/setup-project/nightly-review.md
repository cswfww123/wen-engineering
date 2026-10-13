# Nightly review

This is the heartbeat. The files are not the system. If this review does not
run, LESSONS.md freezes into a stale doc and the standards stop growing.

The schedule is not a GitHub cron workflow. It runs locally, because the
review needs the day's commits and a session long enough to read them. Setup
records the hour here: daily at the hour the maintainer chose, local time.
The default is 03:00. The trigger is a host scheduled task in this repo.
Until that task exists, a person starts it. Skipped is not a quiet day.

## Input

- Every commit on the integration branch since the `reviewed-through` line at
  the top of LESSONS.md.
- The issues opened, closed, and reopened in that window.
- The CI runs for those commits, including the ones the next push cancelled.

## What to look for

Only these three. Do not widen the review into a design critique — that is
[decisions.md](decisions.md), and it is the maintainer's.

1. Fixed, then fixed again. Same bug, a sibling the first fix missed, a
   reporter reopening because the fix covered the screenshot and not their
   surface.
2. Should not have merged. Its own new test failed. A review had listed a
   known problem. It reversed a deliberate decision. It bundled two goals.
3. Verified too thinly. "Not run" was left out. "Fails the same on main"
   named a stale sha. A platform claim was a cross-compile. A real system was
   not tried, and the next commit built on it anyway.

Also record what was done right, as `Done right`, with the commit. The next
agent needs a shape to copy.

## Output

One lesson per finding, in the shape LESSONS.md specifies: one sentence, why,
evidence, `Seen N×` with the date. A finding that matches an existing lesson
increments Seen and adds the date. It does not get a new heading.

Then:

- A lesson seen on 3 separate days moves into code-standards.md, with its
  evidence. Leave a pointer in the "Moved" section. If a moved rule is missed
  again, record the miss under it. Promotion is not compliance.
- A same-day incident that shipped broken to a user is written into the
  standards the same night, under Release or the acceptance criteria. It does
  not wait for 3.
- A security gap found in a doc is filed as an issue in the same commit as
  the lesson, and reproduced, not described.
- Update the `reviewed-through` line to the last commit actually read, with
  the time. A review that stops halfway says so. Do not claim a sha you did
  not reach.

## What this review is not

- It does not decide whether a feature should exist.
- It does not reverse a product decision.
- It does not tag a release. If it finds a release that went out on a
  cancelled run, the lesson is the gate, and the fix is a commit, not a
  silent re-tag.
- It does not run the community PR's code. Harm checks still come first.
