# Upstream authority (Google Labs DESIGN.md)

This skill **must** produce files that conform to the public DESIGN.md format.
WEN does **not** own that format. Do not invent a private schema.

## Canonical sources (in force order)

When anything conflicts, higher wins:

| Rank | Source | Role |
| --- | --- | --- |
| 1 | **`npx @google/design.md lint`** (current published package) | Machine gate for structure, refs, contrast. Run on every write. |
| 2 | **Upstream format spec** | Human-normative schema and section rules |
| 3 | **Upstream README / examples** | Orientation and worked samples |
| 4 | **[SPEC-BRIEF.md](SPEC-BRIEF.md)** in this skill | Offline/orientation **cache only** — may lag |

Never treat SPEC-BRIEF as law when lint or upstream disagrees.

## Links (refresh if moved)

| What | URL |
| --- | --- |
| Repo | https://github.com/google-labs-code/design.md |
| Spec (primary) | https://github.com/google-labs-code/design.md/blob/main/docs/spec.md |
| Spec (rendered homepage, if present) | https://stitch.withgoogle.com/docs/design-md/specification |
| Package | https://www.npmjs.com/package/@google/design.md |
| Examples | https://github.com/google-labs-code/design.md/tree/main/examples |

Raw fetch when tools allow:

```text
https://raw.githubusercontent.com/google-labs-code/design.md/main/docs/spec.md
```

```bash
# Conformance (preferred)
npx --yes @google/design.md lint path/to/DESIGN.md
npx --yes @google/design.md --help   # discover new commands after package updates
```

Record in the done report when useful:

- package version used (`npm view @google/design.md version` or lint banner)
- whether the live `docs/spec.md` was consulted this run

## When to open the live spec

**Must** open or re-fetch upstream `docs/spec.md` (or rely on a just-run lint that encodes the same rules) when:

- First use of this skill in a session that will write `DESIGN.md`
- Lint reports errors the local brief does not explain
- Spec or package clearly advanced past what SPEC-BRIEF assumes (e.g. new token groups, renamed sections, non-alpha `version`)
- User asks for strict / latest compliance

**May** use SPEC-BRIEF alone only for a first draft shape when offline; still run lint before claiming conformance. If offline and lint unavailable, mark the artifact `conformance: unchecked` and list residual risk.

## Refreshing the local cache (pack maintainers)

When editing this skill or after a known upstream breaking change:

1. Re-read upstream `docs/spec.md` and package changelog / README
2. Update [SPEC-BRIEF.md](SPEC-BRIEF.md) only for **high-frequency draft rules** (front matter groups, section order, ref syntax)
3. Keep brief short — full tables and philosophy stay upstream
4. Note the upstream revision date or package version in the SPEC-BRIEF header line

Do **not** vendor the whole upstream repo into `skills/to-design-md/`. A stale full copy is worse than a pointer.

## What this skill owns vs upstream

| Owns (WEN) | Does not own |
| --- | --- |
| When to run (frontend gate, branches Extract/Synthesize/Refresh) | Token schema evolution |
| Theme extraction heuristics for real codebases | Official section aliases / linter rules |
| Confirm-before-write and environment hygiene | Brand examples in Google's `examples/` |
| Wiring to `/prototype` and `/implement` | CLI flags and export formats beyond lint |
