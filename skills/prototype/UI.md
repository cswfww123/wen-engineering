# UI Prototype

Use this branch when the question is what a page, component, dashboard, form, or
workflow should feel like before production implementation.

## Process

1. State the question and number of variants. Default to three variants; avoid
   more than five.
2. Build an isolated scratch surface. Reuse installed UI conventions when they
   can be imported without changing manifests or production routing; otherwise
   use a standalone local HTML artifact.
3. Make variants structurally different: information hierarchy, layout,
   workflow, or primary action should change. Color-only variants do not count.
4. Switch variants with a URL parameter or another shareable local control.
5. Keep mutations stubbed unless mutation behavior is the question.
6. Provide the local URL and variant keys.
7. Record the user's reaction, the winning evidence, and remaining uncertainty
   in `RESULTS.md`. Recommend keep, delete, or promote to the caller.

## Avoid

- polished marketing pages when the need is an operational tool
- shared layout so heavy that variants cannot disagree
- production data writes, routes, or behavior changes
- package-manifest changes or new runtime dependencies
