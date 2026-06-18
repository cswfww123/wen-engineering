# UI Prototype

Use this branch when the question is what a page, component, dashboard, form, or
workflow should feel like before production implementation.

## Process

1. State the question and number of variants. Default to three variants; avoid
   more than five.
2. Prefer an existing route or screen so variants sit beside real navigation,
   density, auth, and data. Create a throwaway route only when no natural host
   exists.
3. Make variants structurally different: information hierarchy, layout,
   workflow, or primary action should change. Color-only variants do not count.
4. Switch variants with a URL parameter or another shareable local control.
5. Keep mutations stubbed unless mutation behavior is the question.
6. Provide the local URL and variant keys.
7. When a direction wins, record why, fold the chosen direction into real work,
   and delete losing variants and switcher code.

## Avoid

- polished marketing pages when the need is an operational tool
- shared layout so heavy that variants cannot disagree
- production-only data writes
- shipping prototype switchers or losing variants
