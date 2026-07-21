# Skill composition: profiles, decoupled skills, and the judgment/execution boundary

Status: superseded in part by ADR 0004

We keep skills as atomic, freely combinable units, capture role-based bundles and
recommended workflow order in a separate `profiles/` layer, and locate all
deterministic execution (scanners, builds, deploys, signing) outside skills.
Skills hold judgment; tools, CI, and the project harness hold execution.

## Context

The repo grew an implicit linear pipeline — `to-prd → to-issues → implement →
code-review → qa-run` — hard-coded as "Recommended Next Step" command chains inside
five skills. That chain assumes every user enters at `to-prd` and follows one
ordering, which conflicts with role-based use: a tester enters at `to-test-plan`,
security through the security axis of `code-review`, a bug fix at
`diagnosing-bugs`.

Two enterprise gaps — release/delivery and security/compliance — needed filling,
but the repo philosophy ("small beats comprehensive") rules out folding ops, data
migration, scanning, build, and deploy into skills: those are platform-specific,
deterministic execution.

## Decision

1. **Profiles, not physical subdirectories.** Role-to-skill bundles live in
   `profiles/` (for example `qa.md`, `dev.md`, `security.md`, `release.md`). The
   physical `skills/` tree stays flat. `scripts/sync-skills.sh` gains
   `--profile <name>` and `--only <a,b,c>` so a tester installs the few skills
   they need, not all of them.
2. **Skills are decoupled; order lives in profiles.** No skill prescribes a
   "Then run X, then Y" sequence. A skill may end with an unordered
   `Related Skills` list (discovery) and condition-gated soft suggestions
   ("only when X"). The recommended ordering is expressed in the matching
   profile, not baked into each skill.
3. **Judgment is the skill; execution is not.** A skill does threat modeling,
   release go/no-go, bypass reasoning, and prioritization. It consumes outputs
   from scanners, builders, and deployers; it does not replace them. Scanning,
   builds, deploys, and signing belong to CI, the project harness
   (`setup-project-harness`), or external tools.
4. **Enterprise gaps stay inside existing review boundaries.** Security is a
   `code-review` axis for changed code. Ops, release automation, and data
   migration stay project-harness concerns, not general skills. **Forensic
   observability** (logging foundation at setup, decision-boundary logs,
   fail-open) is a pack gate shared with harness — see ADR 0006; it is not a
   free-standing "ops skill" dump.

## Considered Options

- **Physical subdirectories per role.** Rejected: shared skills have no clean
  home, and reorganization breaks the sync manifest, README layout, relative
  references, and installed-user upgrades.
- **Keep command chains and add profiles.** Rejected: the two contradict each
  other — profiles say "freely compose," chains say "follow this order."
- **Full-stack skills that scan, build, and deploy.** Rejected: violates the
  "no generic best-practice dump" rule and couples skills to platforms.

## Consequences

- Five existing skills (`to-prd`, `to-issues`, `implement`, `to-test-plan`,
  `qa-run`) lose their "Recommended Next Step" command chains, replaced by
  unordered `Related Skills` lists.
- `code-review` owns diff-level security review; scanners and deterministic
  security tooling stay in CI or the project harness.
- Every future skill follows the same boundary: judgment in, execution out.
