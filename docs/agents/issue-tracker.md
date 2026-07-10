# Lifecycle tracker: GitHub

Specs, implementation tickets, Wayfinder maps, and discovery tickets live as
GitHub issues. `Ticket` is the workflow term; the GitHub object remains an
issue. Use the `gh` CLI for `cswfww123/wen-engineering`; inside this clone it
infers the repository from the remote.

## Base Operations

- Create: `gh issue create --title "..." --body-file <file>`
- Read: `gh issue view <number> --comments --json number,title,state,body,labels,assignees,comments,url`
- Update: `gh issue edit <number> --title "..." --body-file <file>`
- Comment: `gh issue comment <number> --body "..."`
- List exhaustively: `gh api --paginate 'repos/cswfww123/wen-engineering/issues?state=open&per_page=100'`
- Label: `gh issue edit <number> --add-label "..."` or `--remove-label "..."`
- Reopen: `gh issue reopen <number> --comment "..."`
- Close: `gh issue close <number> --comment "..."`

Use `Kind: spec`, `Kind: implementation-ticket`, `Kind: wayfinder-map`, or
`Kind: wayfinder-ticket`, or `Kind: bug-report` in every issue body. A spec
contains stable requirement IDs and never receives `ready-for-agent`. Only an
`AFK` implementation ticket may receive that label; a bug report receives
`needs-triage` and no readiness label.

Find an artifact by its kind and stable tracker number/URL, for example:

```bash
gh api --paginate 'repos/cswfww123/wen-engineering/issues?state=all&per_page=100' --jq '.[] | select(.pull_request == null and ((.body // "") | test("(?m)^Kind: spec$"))) | {number,title,state,body,html_url}'
```

## Parent And Blocking Relationships

Detect capabilities before choosing a relationship strategy:

```bash
gh --version
gh issue create --help | rg -- '--parent|--blocked-by|--blocking'
gh issue edit --help | rg -- '--parent|--add-sub-issue|--add-blocked-by|--add-blocking'
```

Use a flag only when the installed help advertises it. Current newer clients
support `gh issue create --parent <number-or-url>` and conditional
`--blocked-by` / `--blocking` flags,
`gh issue edit <child> --parent <parent>`,
`gh issue edit <parent> --add-sub-issue <child>`, and
`gh issue edit <ticket> --add-blocked-by <blocker>`. They also advertise
`--remove-parent`, `--remove-sub-issue`, `--remove-blocked-by`, and
`--remove-blocking`. The local `gh 2.86.0` snapshot verified for this contract
does not expose these relationship flags.

When flags are missing but the server exposes the REST capability, use:

```bash
gh api repos/cswfww123/wen-engineering/issues/<child> --jq .id
gh api --method POST repos/cswfww123/wen-engineering/issues/<parent>/sub_issues -F sub_issue_id=<child-rest-id>
gh api --method POST repos/cswfww123/wen-engineering/issues/<ticket>/dependencies/blocked_by -F issue_id=<blocker-rest-id>
gh api --paginate repos/cswfww123/wen-engineering/issues/<parent>/sub_issues
gh api --paginate repos/cswfww123/wen-engineering/issues/<ticket>/dependencies/blocked_by
gh api --method DELETE repos/cswfww123/wen-engineering/issues/<parent>/sub_issue -F sub_issue_id=<child-rest-id>
gh api --method DELETE repos/cswfww123/wen-engineering/issues/<ticket>/dependencies/blocked_by/<blocker-rest-id>
```

If the CLI and REST capability are unavailable for the installed server or
permissions, use body fields `Parent: #<number>` and
`Blocked by: #<number>, ...`. Read and update those fields as the source of
truth. Do not duplicate native relationships in the body. Re-read every native
or fallback relationship after changing it.

References: [GitHub CLI issue edit](https://cli.github.com/manual/gh_issue_edit),
[sub-issues REST API](https://docs.github.com/en/rest/issues/sub-issues), and
[issue-dependencies REST API](https://docs.github.com/en/rest/issues/issue-dependencies).

## Implementation And Human Frontiers

Query both readiness roles, then filter by kind, matching mode, no open blocker
through the chosen relationship strategy, and no assignee:

```bash
gh api --paginate 'repos/cswfww123/wen-engineering/issues?state=open&labels=ready-for-agent&per_page=100' --jq '.[] | select(.pull_request == null and ((.body // "") | test("(?m)^Kind: implementation-ticket$")) and ((.body // "") | test("(?m)^Mode: AFK$")) and (.assignees | length == 0)) | {number,title,body,labels,assignees,html_url}'
gh api --paginate 'repos/cswfww123/wen-engineering/issues?state=open&labels=ready-for-human&per_page=100' --jq '.[] | select(.pull_request == null and ((.body // "") | test("(?m)^Kind: implementation-ticket$")) and ((.body // "") | test("(?m)^Mode: HITL$")) and (.assignees | length == 0)) | {number,title,body,labels,assignees,html_url}'
```

The first result yields the `AFK` implementation candidates; the second yields
the `HITL` human candidates. For every candidate, use the selected relationship
source and keep it only when this native query prints no open blocker number:

```bash
gh api --paginate 'repos/cswfww123/wen-engineering/issues/<number>/dependencies/blocked_by?per_page=100' --jq '.[] | select(.state == "open") | .number'
```

For body fallback, parse the exact `Blocked by:` line and read each referenced
issue state; `None` or all `CLOSED` references is unblocked. These filtered sets
are the typed frontiers. To turn a settled human gate into agent work, update
the body from `Mode: HITL` to `Mode: AFK`, replace `ready-for-human` with
`ready-for-agent`, and read both body and labels back. Never change only one.
If AFK work surfaces a new human-owned gate, update the body to `Mode: HITL`,
replace `ready-for-agent` with `ready-for-human`, and read both back. Reconcile a
partial update before releasing the assignee; retain it while an unfinished
delta still needs one owner.

## Claim, Release, Resolve

Before editing an AFK ticket, or a specifically named paired HITL ticket,
re-read the candidate, claim it, and re-read again:

```bash
gh issue view <number> --json state,body,labels,assignees
gh issue edit <number> --add-assignee @me
gh issue view <number> --json state,body,labels,assignees
```

Proceed only when the second read shows one expected claimant and the ticket is
still unblocked. Release with
`gh issue edit <number> --remove-assignee @me` and comment with the reason.
Assignee claims are coordination, not locks; sessions sharing one GitHub login
must run serially.

Resolve by commenting with acceptance results, verification, review outcome,
and artifact links, then close the issue. A human-only gate records its manual
action or decision and evidence before closure. Recompute affected frontiers
afterward. A blocker clears only when its issue is resolved and closed.

## Wayfinder And Legacy

Store the map as `Kind: wayfinder-map`; store each discovery item as
`Kind: wayfinder-ticket`, attach it to the map with the chosen parent strategy,
and never apply a readiness label. Claim and re-read the map with the same
assignee protocol before claiming a child; this serializes its body updates.
Query one map's native children with:

```bash
gh api --paginate 'repos/cswfww123/wen-engineering/issues/<map>/sub_issues?per_page=100' --jq '.[] | select(.state == "open" and ((.body // "") | test("(?m)^Kind: wayfinder-ticket$")) and (.assignees | length == 0))'
```

With body fallback, query every open issue and keep bodies containing both
`Kind: wayfinder-ticket` and `Parent: #<map>`:

```bash
gh api --paginate 'repos/cswfww123/wen-engineering/issues?state=open&per_page=100' --jq '.[] | select(.pull_request == null and ((.body // "") | test("(?m)^Kind: wayfinder-ticket$")) and ((.body // "") | test("(?m)^Parent: #<map>$")) and (.assignees | length == 0))'
```

In either mode, run the same native or body-fallback blocker check used above;
the remaining children are the discovery frontier. Claim the child with the
read/assign/read protocol and resolve at most one per session.

Before closing the child, read the map body, append exactly one named pointer
under `Decisions So Far`, update it with `gh issue edit <map> --body-file
<draft>`, and read every graph change back. If no child or fog remains, set the
map body to `Status: resolved` and close it. Release the map assignee only after
the final read-back. The map body, not comments, is the decision index.

Publish and read back a QA report by exact comment identity:

```bash
comment_id="$(gh api --method POST repos/cswfww123/wen-engineering/issues/<source>/comments -F body=@<qa-report> --jq .id)"
gh api repos/cswfww123/wen-engineering/issues/comments/$comment_id
```

Use the returned comment URL as the canonical evidence link. When the source is
a spec and QA is `Complete`, close it only after every in-scope child and
replacement closes and every remaining child bug report has evidence-backed
out-of-scope disposition. Then update its body to `Status: delivered`, comment
with requirement-level evidence, close it, and read it back. Otherwise leave it
open; an explicit human closeout uses the same sequence when QA is optional.

A broad or under-diagnosed defect is `Kind: bug-report`, `Runnable: no`, and
`needs-triage`. Find intake exhaustively with:

```bash
gh api --paginate 'repos/cswfww123/wen-engineering/issues?state=open&labels=needs-triage&per_page=100' --jq '.[] | select(.pull_request == null and ((.body // "") | test("(?m)^Kind: bug-report$")))'
```

Convert only an explicitly named report. Read it, claim it, and re-read it with
the same assignee commands used above. Before creating anything, reuse an exact
replacement from `Converted to` or this exhaustive `Origin` query:

```bash
gh api --paginate 'repos/cswfww123/wen-engineering/issues?state=all&per_page=100' --jq '.[] | select(.pull_request == null and any(((.body // "") | split("\n"))[]; . == "Origin: #<report>" or . == "Origin: <report-url>")) | {number,title,state,body,html_url}'
```

If no replacement exists, create the approved ticket or spec with that exact
`Origin`, then read it back. For a defect covered by an accepted spec, every
replacement keeps that spec as parent and the report records `Scope disposition:
covered-by-existing-parent`. For genuinely new/out-of-scope work, the report and
original source both record `Scope disposition: moved-out-of-scope-to
<new-spec>` with evidence; ambiguous scope remains open.

After all replacement and relationship reads succeed, update the report body
with `Converted to`, `Scope disposition`, and `Resolution`, remove
`needs-triage`, close it with a conversion comment, and read it back. Then remove
only the conversion assignee and read it back again. If conversion stops without
an active continuation, remove the assignee and leave the report open. Sessions
sharing one GitHub login convert serially. An open child report or open in-scope
replacement blocks spec closeout.

Discover legacy artifacts exhaustively by querying all issues and filtering for
the old exact heading sets: PRDs contain `## Problem Statement`, `## User
Stories`, `## Implementation Decisions`, and `## Testing Decisions`; legacy
implementation issues contain `## What To Build`, `## Acceptance Criteria`, and
`## Blocked By`:

```bash
gh api --paginate 'repos/cswfww123/wen-engineering/issues?state=all&per_page=100' --jq '.[] | select(.pull_request == null and ((((.body // "") | test("(?m)^## Problem Statement$")) and ((.body // "") | test("(?m)^## User Stories$")) and ((.body // "") | test("(?m)^## Implementation Decisions$")) and ((.body // "") | test("(?m)^## Testing Decisions$"))) or (((.body // "") | test("(?m)^## What To Build$")) and ((.body // "") | test("(?m)^## Acceptance Criteria$")) and ((.body // "") | test("(?m)^## Blocked By$")))))'
```

Preserve their numbers, URLs, and comments. Do not rename or
recreate them merely to change vocabulary.
