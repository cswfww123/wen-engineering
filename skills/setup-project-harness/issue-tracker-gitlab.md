# Lifecycle tracker: GitLab

Specs, implementation tickets, Wayfinder maps, and discovery tickets live as
GitLab issues. `Ticket` is the workflow term; the GitLab object remains an
issue. Run `glab` inside the clone so it infers the repository from the remote.
The commands below require `jq` for deterministic JSON filtering; the harness
must verify it or substitute and document an equivalent parser.

## Base Operations

- Create: `glab issue create --title "..." --description "..."`
- Read: `glab issue view <number> -F json`, then exhaustively read notes with `glab api 'projects/:id/issues/<number>/notes?per_page=100' --paginate --output ndjson`
- Update: `glab issue update <number> --title "..." --description "..."`
- Comment/note: `glab issue note <number> --message "..."`
- List open exhaustively: `glab api 'projects/:id/issues?scope=all&state=opened&per_page=100' --paginate --output ndjson`
- List all exhaustively: `glab api 'projects/:id/issues?scope=all&per_page=100' --paginate --output ndjson`
- Label: `glab issue update <number> --label "..."` or `--unlabel "..."`
- Reopen: `glab issue reopen <number>`
- Close: post the resolution note, then run `glab issue close <number>`

Use `Kind: spec`, `Kind: implementation-ticket`, `Kind: wayfinder-map`, or
`Kind: wayfinder-ticket`, or `Kind: bug-report` in every description. A spec
contains stable requirement IDs and never receives `ready-for-agent`. Only an
`AFK` implementation ticket may receive that label; a bug report receives
`needs-triage` and no readiness label.

Find an artifact by its kind and stable issue IID/URL, for example:

```bash
glab api 'projects/:id/issues?scope=all&per_page=100' --paginate --output ndjson | jq -c 'select(.description // "" | test("(?m)^Kind: spec$"))'
```

## Parent And Blocking Relationships

Check the installed `glab` version, GitLab server version/tier, permissions, and
whether the target issue type supports child and linked-item quick actions.
When supported, create and remove native relationships with notes:

```bash
glab issue note <parent> --message "/add_child #<child>"
glab issue note <parent> --message "/remove_child #<child>"
glab issue note <ticket> --message "/blocked_by #<blocker>"
glab issue note <blocker> --message "/blocks #<ticket>"
glab issue note <ticket> --message "/unlink #<blocker>"
```

Use only one direction to create a blocking edge; `/blocked_by` and `/blocks`
are equivalent inverse views. Re-read the issue and relationship activity after
every quick action. Blocking links and hierarchy support can depend on the
GitLab tier, server version, item type, and permissions.

Read blocking links exhaustively with:

```bash
glab api 'projects/:id/issues/<number>/links?per_page=100' --paginate --output ndjson | jq -c 'select(.link_type == "is_blocked_by" and .state == "opened")'
```

Any output is an open blocker for `<number>`; no output means the native edge
set is unblocked. Use native blocking only when this read-back works. Use native parent
hierarchy only when the generated adapter also records an exact child-list
API/GraphQL query; this template defaults parent storage to body fields.

If the native action is unavailable or rejected, use description fields
`Parent: #<number>` and `Blocked by: #<number>, ...`. Treat those fields as the
source of truth and do not duplicate native relationships in the description.

Reference: [GitLab quick actions](https://docs.gitlab.com/user/project/quick_actions/).

## Implementation And Human Frontiers

Run both queries, then keep only implementation tickets with the matching mode,
no open blocker through the chosen relationship strategy, and no assignee:

```bash
glab api 'projects/:id/issues?scope=all&state=opened&labels=ready-for-agent&per_page=100' --paginate --output ndjson | jq -c 'select((.description // "" | test("(?m)^Kind: implementation-ticket$")) and (.description // "" | test("(?m)^Mode: AFK$")) and (.assignees | length == 0))'
glab api 'projects/:id/issues?scope=all&state=opened&labels=ready-for-human&per_page=100' --paginate --output ndjson | jq -c 'select((.description // "" | test("(?m)^Kind: implementation-ticket$")) and (.description // "" | test("(?m)^Mode: HITL$")) and (.assignees | length == 0))'
```

The first yields typed AFK candidates; the second yields typed HITL candidates.
For native blocking, keep only candidates whose exhaustive link query has no
open `is_blocked_by` object. For body fallback, parse the exact `Blocked by:`
line and read every referenced issue state. Those filtered sets are the
frontiers. To reclassify a
settled human gate, update its description to `Mode: AFK`, run
`glab issue update <number> --unlabel ready-for-human --label ready-for-agent`,
then read both description and labels back.
If AFK work surfaces a new human-owned gate, update its description to `Mode:
HITL`, run `glab issue update <number> --unlabel ready-for-agent --label
ready-for-human`, and read both back. Reconcile a partial update before removing
the worker; retain it while an unfinished delta still needs one owner.

## Claim, Release, Resolve

Before editing an AFK ticket, or a specifically named paired HITL ticket,
re-read the candidate, claim it, and re-read again:

```bash
username="$(glab api user --output ndjson | jq -r '.username')"
glab issue view <number> --comments -F json
glab issue update <number> --assignee "+$username"
glab issue view <number> --comments -F json
```

Proceed only when the second read shows one expected claimant and the ticket is
still unblocked. Release only the worker with
`glab issue update <number> --assignee "-$username"`. The `+` and `-` prefixes
preserve unrelated assignees; never use replacement assignment or `--unassign`
for a claim. Add a note explaining the release. Assignee claims are
coordination, not locks; sessions sharing one GitLab login must run serially.

Resolve by adding a note with acceptance results, verification, review outcome,
and artifact links, then close the issue. A human-only gate records its manual
action or decision and evidence before closure. Recompute affected frontiers
afterward. A blocker clears only when its issue is resolved and closed.

## Wayfinder And Legacy

Store the map as `Kind: wayfinder-map`; store each discovery item as
`Kind: wayfinder-ticket`, attach it to the map with the chosen parent strategy,
and never apply a readiness label. Resolve the current username, claim the map
with `+$username`, and re-read it before claiming a child; release the map with
`-$username` only after all body/graph updates are read back. Native hierarchy
is acceptable only when the generated adapter records an exact child-list
API/GraphQL query as well as the quick action. Otherwise use `Parent: #<map>`
and query:

```bash
glab api 'projects/:id/issues?scope=all&state=opened&per_page=100' --paginate --output ndjson | jq -c 'select((.description // "" | test("(?m)^Kind: wayfinder-ticket$")) and (.description // "" | test("(?m)^Parent: #<map>$")) and (.assignees | length == 0))'
```

Run the same native/body blocker check used above; the remaining objects form
the discovery frontier. Claim with the same
read/assign/read protocol above and resolve at most one child per session.

Before closing the child, read the map description, append exactly one named
pointer under `Decisions So Far`, update it with `glab issue update <map>
--description "$(cat <draft>)"`, and read every graph change back. If no child
or fog remains, set the map description to `Status: resolved` and close it
before releasing the map claim. The map description, not notes, is the decision
index.

Publish and read back a QA report by exact note identity:

```bash
note_id="$(glab api --method POST projects/:id/issues/<source>/notes --raw-field "body=$(cat <qa-report>)" --output ndjson | jq -r '.id')"
glab api projects/:id/issues/<source>/notes/$note_id
```

Use the source issue URL plus `#note_$note_id` as the canonical evidence link.
When `<source>` is a spec and QA is `Complete`, close it only after every
in-scope child and replacement closes and every remaining child bug report has
evidence-backed out-of-scope disposition. Then update its description to
`Status: delivered`, add requirement-level evidence, close it, and read it back.
Otherwise leave it open; an explicit human closeout uses the same sequence when
QA is optional.

A broad or under-diagnosed defect is `Kind: bug-report`, `Runnable: no`, and
`needs-triage`. Find intake exhaustively with:

```bash
glab api 'projects/:id/issues?scope=all&state=opened&labels=needs-triage&per_page=100' --paginate --output ndjson | jq -c 'select(.description // "" | test("(?m)^Kind: bug-report$"))'
```

Convert only an explicitly named report. Resolve the username, read it, claim it
with `+$username`, and re-read it with the same commands used above. Before
creating anything, reuse an exact replacement from `Converted to` or:

```bash
glab api 'projects/:id/issues?scope=all&per_page=100' --paginate --output ndjson | jq -c 'select(any(((.description // "") | split("\n"))[]; . == "Origin: #<report>" or . == "Origin: <report-url>"))'
```

If none exists, create the approved ticket or spec with that exact `Origin`,
then read it back. For a defect covered by an accepted spec, every replacement
keeps that spec as parent and the report records `Scope disposition:
covered-by-existing-parent`. For genuinely new/out-of-scope work, the report and
original source both record `Scope disposition: moved-out-of-scope-to
<new-spec>` with evidence; ambiguous scope remains open.

After all replacement and relationship reads succeed, update the report
description with `Converted to`, `Scope disposition`, and `Resolution`, remove
`needs-triage`, add a conversion note, close it, and read it back. Then remove
only `-$username` and read it again. If conversion stops without an active
continuation, remove that worker and leave the report open. Sessions sharing one
GitLab login convert serially. An open child report or open in-scope replacement
blocks spec closeout.

Discover legacy artifacts exhaustively from the all-issues API output. PRDs
match the exact headings `## Problem Statement`, `## User Stories`,
`## Implementation Decisions`, and `## Testing Decisions`; legacy
implementation issues match `## What To Build`, `## Acceptance Criteria`, and
`## Blocked By`:

```bash
glab api 'projects/:id/issues?scope=all&per_page=100' --paginate --output ndjson | jq -c 'select((((.description // "") | test("(?m)^## Problem Statement$")) and ((.description // "") | test("(?m)^## User Stories$")) and ((.description // "") | test("(?m)^## Implementation Decisions$")) and ((.description // "") | test("(?m)^## Testing Decisions$"))) or (((.description // "") | test("(?m)^## What To Build$")) and ((.description // "") | test("(?m)^## Acceptance Criteria$")) and ((.description // "") | test("(?m)^## Blocked By$"))))'
```

Preserve their IIDs, URLs, and notes; never rename or recreate
them merely to change vocabulary.
