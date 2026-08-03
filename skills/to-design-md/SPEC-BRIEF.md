# DESIGN.md format brief (non-normative cache)

**Not the source of truth.** Authority order: live lint package → upstream
`docs/spec.md` → this file. Full rules:
[UPSTREAM.md](UPSTREAM.md).

Cached orientation for drafting when you already know the shape. If anything
here disagrees with
[docs/spec.md](https://github.com/google-labs-code/design.md/blob/main/docs/spec.md)
or `npx @google/design.md lint`, **drop this cache**.

*Cache aligned roughly to public alpha / `@google/design.md` ~0.4.x — re-check upstream on write.*

## Two layers

1. **YAML front matter** between `---` fences — normative tokens
2. **Markdown body** — rationale; `##` sections only (optional `#` title is not a section)

Prose may use evocative names ("Boston Clay"); tokens carry the real values.

## Token schema (front matter) — orientation only

```yaml
version: alpha                 # follow upstream current version string
name: <string>
description: <string>          # optional
omitted:                       # optional intentional omissions
  - spacing
  - section: rounded
    reason: "Brand book forbids rounded corners"
colors:
  <token-name>: <Color>
typography:
  <token-name>:
    fontFamily: <string>
    fontSize: <Dimension>      # px | em | rem
    fontWeight: <number>
    lineHeight: <Dimension|number>
    letterSpacing: <Dimension> # optional
rounded:
  <scale-level>: <Dimension>
spacing:
  <scale-level>: <Dimension|number>
components:
  <component-name>:
    backgroundColor: <Color|ref>
    textColor: <Color|ref>
    typography: <ref>
    rounded: <Dimension|ref>
    padding: <Dimension>
    # …other component props per live upstream, not frozen here
```

| Type | Orientation | Examples |
| --- | --- | --- |
| Color | Valid CSS color; hex common | `"#1A1C1E"`, `oklch(…)` |
| Dimension | number + `px` \| `em` \| `rem` | `16px`, `-0.02em` |
| Token ref | `{path.to.token}` | `{colors.primary}` |

Component variants are typically **sibling keys** (`button-primary`,
`button-primary-hover`), not nested state maps — confirm against live spec.

## Section order (body) — orientation only

Present sections must follow upstream order. Common order when this cache was
written:

Overview (Brand & Style) → Colors → Typography → Layout (Layout & Spacing) →
Elevation & Depth → Shapes → Components → Do's and Don'ts

Unknown extra `##` headings: usually preserve. Duplicate section headings:
reject. Re-verify aliases and order in upstream before finalize.

## Minimal skeleton

Useful only as a starting paste; expand/trim to live spec + product evidence.

```md
---
version: alpha
name: Example
colors:
  primary: "#1A1C1E"
  secondary: "#6C7278"
  tertiary: "#B8422E"
  neutral: "#F7F5F2"
typography:
  body-md:
    fontFamily: Public Sans
    fontSize: 16px
    fontWeight: 400
    lineHeight: 1.6
rounded:
  sm: 4px
  md: 8px
spacing:
  sm: 8px
  md: 16px
  lg: 32px
---

## Overview

Personality, audience, density.

## Colors

Roles tied to the same hex values as tokens.

## Typography

## Layout

## Elevation & Depth

## Shapes

## Components

## Do's and Don'ts
```

## Conformance

```bash
npx --yes @google/design.md lint DESIGN.md
```

Offline / no Node: do **not** claim full conformance. Use a short residual
checklist only as risk notes (valid `---` fences, parseable YAML, section
order, token refs resolve, prose matches token values) and mark
`conformance: unchecked`.
