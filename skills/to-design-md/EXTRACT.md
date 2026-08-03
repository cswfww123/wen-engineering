# Extract branch — tokens from code

Use when the product already has a theme. Goal: **reflect** the live system in
`DESIGN.md`, then add only the prose agents need. Do not invent a second palette
"for cleanliness."

Output still must **lint-clean against** the current Google Labs format
([UPSTREAM.md](UPSTREAM.md)) — extraction does not justify a non-conforming file.

## Source priority

Scan in order; stop when you have a coherent set. Prefer the **shipped runtime theme** over stale design docs.

1. **Design token packages** — `tokens.json`, Style Dictionary output, DTCG-style JSON, `@theme` / CSS `@property` token sheets
2. **CSS variables** — `:root` / `[data-theme]` / `.dark` in global CSS / CSS modules that define `--color-*`, `--space-*`, `--radius-*`, `--font-*`
3. **Tailwind / Uno** — `tailwind.config.*` `theme.extend`, v4 `@theme` blocks, shared `theme.ts`
4. **Component library theme** — MUI `createTheme`, Chakra theme, shadcn CSS variables (`--primary`, `--radius`), Ant Design token APIs
5. **Framework tokens** — Next/UI kit theme files, native app color assets **only if** they are the real product UI source
6. **Scattered component defaults** — last resort; sample primary button, body text, page background from production components

Record every source path you used in the confirm step.

## Mapping rules

| Live source | DESIGN.md field |
| --- | --- |
| Brand / primary / accent colors | `colors.*` — keep semantic names the codebase already uses when they match agent-friendly roles (`primary`, `secondary`, …) |
| On-* / contrast pairs | `colors.on-primary`, `on-surface`, etc., or component `textColor` |
| Font families + type scale | `typography.*` with concrete `fontSize` / `fontWeight` / `lineHeight` |
| Spacing scale | `spacing.*` (4/8-based scales map cleanly to `xs`…`xl`) |
| Border radius scale | `rounded.*` |
| Button / input / card recipes | `components.*` with `{token}` refs back to primitives |

### Naming

- Prefer **semantic** token names over raw palette steps (`primary` over `blue-600`) when the theme already has semantics
- If the theme only has steps (`gray-50`…`gray-900`), map a small semantic layer in front matter **and** document the mapping in Colors prose — do not drop the step tokens if components still reference them
- Dark mode: either document both as separate token groups (`colors.surface`, `colors.surface-dark`) *or* separate files only if the product already splits that way; do not invent a dark theme the app does not ship

### Conflicts

| Situation | Action |
| --- | --- |
| Multiple packages define different primaries | Prefer the package that owns the user-facing shell; list losers in confirm |
| CSS var ≠ Tailwind extend | Prefer the value that wins at runtime (computed/global CSS usually) |
| Prototype winner ≠ theme | Confirm with user which becomes environment; update theme only on explicit ask |
| Dead tokens never used | Omit from DESIGN.md or list under `omitted` / Do's — do not preserve rot as identity |

## Prose after extract

Code gives *what*. Still write:

- **Overview** — density and personality inferred from real UI (tight admin tables vs marketing whitespace), not marketing fluff
- **Colors / Typography** — role of each token (when to use tertiary; label caps policy)
- **Do's and Don'ts** — patterns the codebase already enforces (or repeatedly violates)

If rationale is unknown, write short factual prose from usage ("Primary appears on main CTAs and focus rings") rather than invented brand mythology.

## Do not

- Replace working CSS hex with "nicer" oklch without user ask
- Expand extract into a full component rewrite
- Generate tokens for backend-only packages "for completeness"
- Claim WCAG pass without checking text/background pairs used in `components` or body roles
