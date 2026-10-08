# PR Packet

Applies to: writing or updating a PR/MR description, title, or review comment that stands in for the diff.

The description is the review surface. A reviewer reads it and decides; they do not read the diff first. The packet makes that decision possible: purpose, the behavior change, and the evidence that proves it.

## Order

Write these, in this order. Stop a section when it has nothing true to say.

1. **Decision.** One or two sentences: what this change is for, and the review decision it asks for (merge, request changes, or hold). If it is not mergeable yet, the title and this paragraph both say Draft. Claim a platform Draft state only after the API set it and a read-back confirmed it.
2. **Behavior.** The smallest view of what changed, via `/show-me`: pseudocode, a call tree, a data-flow or sequence diagram, or a shaped diff. One view. A file list is not a view.
3. **Review checklist.** One line per item the reviewer must accept or reject. Each line points at the acceptance condition, the file that carries it, and the evidence below that proves it.
4. **Gaps.** What was not exercised, what can break, and the release or rollback note when SQL, config, deployment, or user-visible behavior is involved.

## Evidence

Attach only the kinds this change can actually produce. Each item names the command or path and the result, not a claim that it passed.

- **Flow** — a mermaid diagram when the change crosses modules, ownership, or an async boundary. Sequence for a request path; flowchart for a state change.
- **Repro** — the steps that show the old behavior failing, for a bug fix.
- **TDD** — the test command and the red-then-green result. The log shows the failing test before the fix and the same test passing after. A test the same change authored, with no red result, is not TDD evidence.
- **Walkthrough** — the steps a reviewer runs to see the behavior themselves.
- **Proof** — a screenshot or short recording of the behavior after the change, for UI or externally visible behavior. It shows the case exercised, not a happy-path tour.
- **Decisions** — a design note listing each decision point: the choice, the alternative not taken, and why. For a change with more than one real fork.

## Agent review

Before requesting review on a behavior change, run `/review` once in each code agent available in this checkout and name each run in the packet: agent, scope, findings, and what was done with them. Findings left open stay in **Gaps**.

## Shape

- The checklist is the index. Evidence sits under the item it supports, so a reviewer opens one item and sees its proof.
- Prefer the evidence that can be re-run over a restated implementation.
- A section with nothing true to put in it is absent, not filled with a placeholder.
