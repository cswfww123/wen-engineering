# Tracker Contract

Every generated `docs/agents/issue-tracker.md` must implement this logical
contract with exact commands or file operations. GitHub and GitLab may store
all five artifact kinds as issues; the workflow still treats them differently.

## Artifact Kinds

- `Kind: spec` — settled, non-runnable parent with stable requirement IDs
- `Kind: implementation-ticket` — normally one independently executable
  vertical slice; expand-contract permits the named behavior-preserving
  mechanical exception
- `Kind: wayfinder-map` — durable index of discovery decisions
- `Kind: wayfinder-ticket` — one research, prototype, grilling, or prerequisite task
- `Kind: bug-report` — confirmed defect intake that is not yet one-context executable

Only an open `implementation-ticket` with `Mode: AFK` may enter the
implementation frontier.
A spec, map, or Wayfinder ticket is never implementation work merely because
its tracker object is open or carries a readiness label.
A bug report stays `needs-triage` and outside execution frontiers until an
explicit conversion proves one-context readiness.

## Required Operations

The tracker adapter must say exactly how to:

1. create, read, update, comment on, list, reopen, and close an object;
2. store and find a spec and its stable requirement IDs;
3. create an implementation ticket and attach it to its spec parent;
4. add, read, and remove `blocked by` edges;
5. compute both implementation and human frontiers: open, unblocked, unclaimed
   `implementation-ticket` objects labeled `ready-for-agent`/`AFK` or
   `ready-for-human`/`HITL` respectively;
6. claim a ticket, re-read it to verify the claim, and release the claim;
7. resolve a ticket by recording its outcome and evidence before closing it;
8. create/read a Wayfinder map, attach discovery tickets, query that map's open,
   unblocked, unclaimed discovery frontier without a readiness label, resolve
   at most one discovery ticket per session under a map-level claim, append one
   result pointer to the map body, and resolve/close a fog-free map;
9. discover legacy PRDs/issues without renaming historical artifacts.
10. close out an accepted spec as delivered only after every in-scope child is
    resolved and requirement-level completion evidence is recorded.
11. publish a QA report, read it back by canonical path or URL, and link it to
    the source artifact; a delivered closeout additionally requires a spec.
12. publish and find a non-runnable `bug-report`, keep it out of readiness
    frontiers, claim it for conversion, find replacements by exact `Origin`,
    and after diagnosis/slicing create or reuse a linked implementation ticket
    or spec before recording `Converted to`, reading it back, and resolving the
    report as converted/superseded.

For a custom tracker, prose such as "use Jira" is insufficient. Record the
exact equivalent operation for every item above before the harness is complete.

## Relationship Capability And Fallback

Detect the installed CLI, server, permissions, and tier before choosing native
parent or blocking relationships. Use a native relationship when it is
available and can be read back. Otherwise use these parseable body fields:

```text
Kind: <spec|implementation-ticket|wayfinder-map|wayfinder-ticket|bug-report>
Subtype: <bug|n/a>
ID: <stable artifact ID>
Runnable: <yes|no|n/a>
Parent: <stable tracker reference|none>
Blocked by: <comma-separated stable references|none>
Mode: <AFK|HITL|n/a>
Covers: <comma-separated stable requirement/source IDs|n/a>
Supports: <comma-separated stable requirement/source IDs|n/a>
Decision: <stable spec decision or ADR reference|n/a>
Origin: <source bug-report/failing ticket/test reference|n/a>
Converted to: <canonical replacement references|none|n/a>
Scope disposition: <covered-by-existing-parent|moved-out-of-scope-to reference|pending|n/a>
Status: <draft|accepted|delivered|active|open|needs-triage|ready-for-agent|ready-for-human|in-progress|resolved>
Claimed by: <worker identity|none>
Claimed at: <ISO-8601 timestamp|none>
Resolution: <summary or evidence pointer|pending>
```

Choose one source of truth per relationship. Do not mirror a native parent or
blocking edge in body fields and then let the two copies drift. After every
relationship mutation, read it back through the same capability path.

## Frontiers And Claims

Recompute every affected frontier after a claim, release, resolution, mode
transition, or dependency change. A blocker is cleared only when the referenced
ticket is resolved and closed, not merely assigned or in progress.

- implementation frontier: `Kind: implementation-ticket`, `Mode: AFK`,
  `ready-for-agent`, open, unblocked, and unclaimed
- human frontier: `Kind: implementation-ticket`, `Mode: HITL`,
  `ready-for-human`, open, unblocked, and unclaimed
- discovery frontier: an open, unblocked, unclaimed `Kind: wayfinder-ticket`
  whose parent is the selected map; readiness labels do not apply

A manual-only human-frontier ticket closes directly after the named action or
decision and evidence are recorded; it does not invent TDD or code-review
results. If that decision leaves agent-executable work, update the mode and
readiness label to `AFK`/`ready-for-agent` explicitly. Only a code-bearing HITL
ticket may use a named paired `/implement` run, with the actual-change evidence
loop plus verification and review.

If an unexpected human-owned gate appears during AFK work, update both `Mode`
and the readiness role through the adapter, then read both back and reconcile a
partial failure. Release the claim only when no unfinished delta needs its
owner; otherwise keep the now-HITL ticket claimed until handoff resumes.

A claim is coordination, not automatically a distributed lock:

1. read the candidate and confirm that it is still on the frontier;
2. write the tracker-specific claim;
3. immediately re-read it and confirm one expected claimant;
4. on conflict, release the claim and stop;
5. if workers share one tracker identity or claiming is not atomic, run serially.

A specifically named bug report may use this same protocol as a conversion
claim even though it never enters a frontier. Before creating a replacement,
read `Converted to` and search all candidate artifacts for an exact `Origin`
reference to the report. Reuse an existing canonical replacement. Keep the
claim through replacement read-back and the report's final pointer, resolution,
and read-back; release it when conversion stops without an active continuation.

Discovery resolution claims the map before its child and releases the map only
after the decision pointer is read back. Standard body/description/file updates
are last-write-wins, so one map resolves serially unless its adapter documents
an atomic compare-and-swap update. The map itself carries claim fields when the
tracker has no native assignment.

Local Markdown claims are advisory unless the repo provides an atomic locking
mechanism. Never promise safe parallel execution from an ordinary file edit.

## Resolution And Legacy Inputs

Resolution records the acceptance result, verification evidence, review result,
and durable artifact pointers before closure. Wayfinder resolution also appends
one pointer to the map; the map must not duplicate the full research or
prototype result.

When the discovery frontier and unspecified fog are empty, record terminal
evidence, set the map to `resolved`, close its tracker object, and read it back.
When every in-scope implementation/human ticket is resolved, every child bug
report is resolved/converted or explicitly moved out of scope with evidence,
and every in-scope replacement is complete, a `Complete` QA run may record
requirement-level evidence, set the accepted spec to `delivered`, and close it.
If the lifecycle does not require `/qa-run`, an explicit human closeout performs
that same evidence gate; `/implement` never closes the parent.

When an existing spec covers a report, replacement tickets keep that spec as
parent so resolving intake does not unblock delivery. A new replacement spec is
valid only for genuinely new/out-of-scope work; record its canonical reference
and evidence-backed scope disposition on the report and original source before
resolution. Ambiguous scope leaves the report open.

New local artifacts use `SPEC.md`, `tickets/`, `bugs/`, `WAYFINDER.md`, and `wayfinder/`.
Continue reading `PRD.md`, `issues/`, old tracker links, and historical comments.
Never rename legacy artifacts merely to adopt the current vocabulary.
