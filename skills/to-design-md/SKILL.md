---
name: to-design-md
description: Generate or update a Google Labs–format DESIGN.md for frontend visual identity. Use when the user wants DESIGN.md, AI UI tokens, or to capture a settled look after prototype.
---

# To DESIGN.md

Produce a **repo-local visual identity** agents can apply on UI work: one
`DESIGN.md` that pairs machine-readable tokens with human-readable rationale.

**Format conformance is mandatory** against the public Google Labs DESIGN.md
spec — not a WEN-private dialect. See [UPSTREAM.md](UPSTREAM.md).

This is **not** product intent (`/to-spec`), domain language
(`/domain-modeling`), or module architecture (`/codebase-design`). Backend-only
/ no-UI repos skip this skill.

## Authority (do not skip)

| Rank | Source |
| --- | --- |
| 1 | `npx @google/design.md lint` (current package) |
| 2 | Upstream `docs/spec.md` in [google-labs-code/design.md](https://github.com/google-labs-code/design.md) |
| 3 | [SPEC-BRIEF.md](SPEC-BRIEF.md) — **non-normative cache only** |

If cache and upstream/lint disagree, **upstream/lint win**. Do not extend the
schema “for our projects.”

Before drafting in a session that will write the file: open or re-fetch the
live spec when network is available ([UPSTREAM.md](UPSTREAM.md)); note the lint
package version in the done report when useful.

## Gate

Run only when at least one is true:

- User asked for `DESIGN.md`, design tokens for agents, or a visual identity file
- The package has a real UI surface (web/app/components) and identity is unset or drifting
- A UI prototype settled a look and should be captured as durable environment

If the work is pure API/CLI/library with no UI: stop and say this skill does not apply.

## Artifact

Default path: **`DESIGN.md` at the UI package root** (app or design-system
package). Monorepo: one file per distinct product UI surface — not a forced
monorepo-root copy for every package.

- Tokens (YAML front matter) are **normative** for values
- Prose (`##` sections) explains *why* and how to apply
- Prefer syncing from existing theme code over inventing a parallel palette

## Branches

Pick one primary branch from evidence (state it at the top of the draft):

| Branch | When | Load |
| --- | --- | --- |
| **Extract** | Tailwind theme, CSS variables, tokens.json, component library theme, or Figma-export already encodes the system | [EXTRACT.md](EXTRACT.md) |
| **Synthesize** | No durable tokens yet; brand brief, reference UI, settled prototype, or user taste must fill the gap | short grill below + live upstream / [SPEC-BRIEF.md](SPEC-BRIEF.md) cache |
| **Refresh** | `DESIGN.md` exists; tokens or product look changed | re-extract or re-grill only the delta; preserve intentional `omitted` and Do's/Don'ts |

If both code tokens and a prototype exist and they conflict, surface the
conflict — do not silently prefer inventing a third system.

## Process

### 1. Explore

Map what already governs look-and-feel:

- Existing `DESIGN.md` (if any)
- Theme / tokens sources (see [EXTRACT.md](EXTRACT.md))
- Global styles, component library defaults, brand docs the user points at
- Recent UI prototype winner (if this run follows `/prototype`)
- Live format rules: [UPSTREAM.md](UPSTREAM.md) (spec + lint), not memory alone

Completion: list sources found, proposed path for `DESIGN.md`, chosen branch,
and whether live upstream/lint was available.

### 2. Fill gaps (synthesize only)

Ask only what code cannot answer. Prefer one short batch over serial
micro-questions:

- Personality / audience (dense vs airy, editorial vs playful, B2B vs consumer)
- Primary accent and what it is *for* (one CTA vs multi-accent)
- Type pairing intent (if fonts are free)
- Hard don'ts (no pure black, no drop shadows, max two typefaces, etc.)

Do not invent market positioning or product requirements. If taste is blocked
and the user is unavailable, extract what code proves and mark prose as
incomplete — do not fake brand voice.

### 3. Draft

Write a full draft before overwriting. Structure must match **live** upstream
rules (use SPEC-BRIEF only as a shape reminder):

1. YAML front matter: `version` per current upstream, `name`, token groups the
   live schema accepts
2. Markdown body sections in the **current** official order; intentional skips
   via `omitted` (+ reason) when the live schema supports it
3. Prose cites the same hex/size values as tokens; tokens win on conflict
4. Component entries use token references (`{colors.primary}`) where possible
5. Cover light/dark only when the product actually ships both

Completion: draft is ready for official lint (or explicitly
`conformance: unchecked` if offline).

### 4. Confirm

Show the user:

- Path and branch (Extract / Synthesize / Refresh)
- Token summary (palette + type + spacing scale)
- Any conflict with existing theme code
- Sections intentionally omitted
- Conformance plan (lint package / offline residual)

Wait for accept or edits before write, unless the user already authorized
"write DESIGN.md without further confirm".

### 5. Write and verify

1. Write `DESIGN.md` at the agreed path
2. **Required when Node/network allow:**

   ```bash
   npx --yes @google/design.md lint DESIGN.md
   ```

   Fix structural errors and real contrast failures before claiming done.
   Informational warnings may remain if noted. Prefer this package over
   hand-waving “looks like the examples.”
3. If lint is unavailable: do not claim full Google Labs conformance; run only
   residual offline checks from [SPEC-BRIEF.md](SPEC-BRIEF.md) and report
   `conformance: unchecked`

Completion: file on disk; lint clean of errors **or** explicit unchecked
status; report path, residual warnings, and lint/package version when known.

### 6. Downstream

- Point UI implement / review fidelity at this file when it exists
- Optional: offer to align Tailwind/CSS variables *toward* tokens only when the
  user wants a migration — this skill does not silently rewrite the theme
- After a UI prototype win: fold decisions here, then promote production UI
  under `/implement`

## WEN bounds

- **Optional** for frontend/UI packages only — never required by harness for
  backend-only repos
- Durable environment artifact; same-session chat is not a substitute once
  identity is settled
- **Format authority is upstream** ([UPSTREAM.md](UPSTREAM.md)); WEN owns
  workflow and extraction, not the schema
- Do not treat `DESIGN.md` as PRD, domain glossary, or architecture ADR
- Side effects limited to `DESIGN.md` (and optional lint). Theme/code migration
  needs explicit user ask
- Prefer existing wire values over "cleaner" reinvented palettes
