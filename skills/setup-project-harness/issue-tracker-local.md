# Lifecycle tracker: Local Markdown

Lifecycle artifacts live under `.scratch/<feature-slug>/`:

```text
.scratch/<feature-slug>/
├── SPEC.md
├── tickets/
│   └── <NN>-<slug>.md
├── bugs/
│   └── <NN>-<slug>.md
├── WAYFINDER.md
└── wayfinder/
    └── <NN>-<slug>.md
```

Create only the artifact kinds the work needs. `SPEC.md` is a non-runnable
parent; `tickets/` stores implementation tickets; `bugs/` stores non-runnable
bug intake; `WAYFINDER.md` indexes a foggy effort; `wayfinder/` stores discovery
tickets.

## File Contract

Each ticket or bug-report file starts with parseable fields:

```text
Kind: <implementation-ticket|wayfinder-ticket|bug-report>
Subtype: <bug|n/a>
ID: <stable ID>
Runnable: <yes|no>
Status: <open|canonical triage role|in-progress|resolved>
Mode: <AFK|HITL|n/a>
Parent: <relative path>
Blocked by: <comma-separated relative paths|none>
Covers: <comma-separated stable requirement/source IDs|none>
Supports: <comma-separated stable requirement/source IDs|none>
Decision: <stable spec decision or ADR reference|none>
Origin: <source bug-report/failing ticket/test reference|none>
Converted to: <comma-separated replacement paths|none>
Scope disposition: <covered-by-existing-parent|moved-out-of-scope-to path|pending|n/a>
Claimed by: <worker identity|none>
Claimed at: <ISO-8601 timestamp|none>
Resolution: <summary or artifact pointer|pending>
```

`SPEC.md` starts with `Kind: spec`, a stable `ID`, `Runnable: no`, `Status: draft
| accepted | delivered`, `Origin: <bug-report path | none>`, and stable
requirement IDs.
`WAYFINDER.md` starts with `Kind: wayfinder-map`, a stable `ID`, `Runnable: no`,
`Status: active | resolved`, `Claimed by: none`, and `Claimed at: none`.
Comments and history append
under `## Comments`; never erase prior decisions when changing status.

## Base Operations

- Create: add the correctly named file with the required fields.
- Read: open the referenced file and its `## Comments` history.
- Update: edit fields in place and append a dated comment for material changes.
- List: enumerate `tickets/*.md`, `bugs/*.md`, or `wayfinder/*.md` and read their fields.
- Comment: append under `## Comments`.
- Reopen: set `Status:` to the configured readiness state, clear only a stale
  resolution/claim, and append the reason.
- Close/resolve: set a ticket/map to `Status: resolved`, or a completed spec to
  `Status: delivered`; fill `Resolution:` where present, append acceptance,
  verification, and review evidence, and keep the file in place.

## Parent, Blocking, And Frontiers

Use repository-relative paths in `Parent:` and `Blocked by:`. To add or remove
an edge, edit the field and re-read every referenced file. A blocker clears only
when its file has `Status: resolved` and a non-pending resolution.

The implementation frontier contains only files in `tickets/` with all of:

- `Kind: implementation-ticket`
- `Status:` mapped to `ready-for-agent`
- `Mode: AFK`
- every `Blocked by:` file resolved, or `none`
- `Claimed by: none`

Specs, bug reports, Wayfinder maps, and files in `bugs/` or `wayfinder/` never enter the implementation
frontier. The human frontier applies the same filters with
`Status: ready-for-human` and `Mode: HITL`. A settled human gate can be changed
to `Mode: AFK` and `Status: ready-for-agent` in one edit, followed by read-back.
If an AFK ticket surfaces a new human-owned gate, update both fields in one edit
and read them back. Keep an existing claim while unfinished changes exist;
otherwise clear it only after the HITL state reads back. Reconcile a partial
edit before recomputing either frontier.

For one selected `WAYFINDER.md`, the discovery frontier contains only its open,
unblocked, unclaimed child files in `wayfinder/`, regardless of readiness
labels. Recompute affected frontiers after every edge, claim, release, mode
transition, or resolution change.

## Claim And Release

Claim a ticket by confirming it is still on its frontier, setting `Claimed by:`,
`Claimed at:`, and `Status: in-progress`, then immediately re-reading it.
Release a ticket by restoring the appropriate status (`ready-for-agent`,
`ready-for-human`, or `open`), clearing both claim fields, and appending the
reason. Claim a map by confirming `Status: active`, setting only its two claim
fields, and re-reading it; the map remains `active`. Release an open map by
clearing those fields while preserving `active`; after terminal closeout, clear
them while preserving `resolved`. Claim release never changes map status.

These edits are advisory, not atomic locks. Unless the repo provides an atomic
claim mechanism, run workers serially; an immediate re-read does not make
parallel file edits safe.

For explicit bug-report conversion, confirm `Status: needs-triage`, set only its
two claim fields, and re-read it; the report stays `needs-triage`. Before
creating anything, find exact prior replacements with:

```bash
rg -l -x -F 'Origin: <bug-report-relative-path>' .scratch
```

Keep only `Kind: spec` or `Kind: implementation-ticket` results. Reuse every
canonical result and convert one report serially. Keep the report
claim through replacement and report read-back; clear it when conversion stops
without an active continuation.

For Wayfinder, claim and re-read `WAYFINDER.md` before claiming a child. Keep
the map claim through child resolution, fog graduation, relationship changes,
and final map read-back; then clear its claim fields. Resolve one map serially.

## Wayfinder And Legacy

Link each discovery ticket to `WAYFINDER.md` through `Parent:`. Resolve at most
one per session. Record the result in its `Resolution:` and append exactly one
artifact/context pointer to `WAYFINDER.md`; do not duplicate the full result.
When no child or unspecified fog remains, set the map to `Status: resolved`,
append terminal evidence, and read it back.

Store each QA run as `qa-reports/<run-id>.md` beside the source lifecycle
artifacts and link it from the source spec, ticket, bug, or test artifact. Never
overwrite an earlier run. Store a broad or under-diagnosed defect in `bugs/`
with `Kind: bug-report`, `Runnable: no`, and `Status: needs-triage`. Conversion
reuses exact `Origin` matches or creates new replacement artifacts. When its
accepted parent spec covers the defect, every replacement stays under that spec;
after the graph reads back, set `Converted to`, `Scope disposition:
covered-by-existing-parent`, `Resolution`, and `Status: resolved`, then clear the
claim and re-read the report. For genuinely new/out-of-scope work, create an
accepted spec with `Origin` pointing to the report, record `moved-out-of-scope-to
<spec path>` with evidence on the report and original source, then resolve and
read it back. Never move or rename the intake; ambiguous scope stays open.
On `Complete`, after every in-scope child and replacement resolves and every
remaining bug report is explicitly out of scope with evidence,
set a source spec to `Status: delivered`, append requirement-level evidence,
and read it back. Otherwise leave it accepted; an explicit human closeout uses
the same gate when QA is optional.

Continue reading `.scratch/<feature-slug>/PRD.md` and
`.scratch/<feature-slug>/issues/*.md` as legacy spec/ticket inputs. Preserve old
numbering, links, comments, and filenames. Never rename historical artifacts
merely to adopt `SPEC.md` or `tickets/`.
