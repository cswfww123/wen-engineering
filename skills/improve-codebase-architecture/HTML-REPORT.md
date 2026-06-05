# HTML Report Format

The architecture review is a single self-contained HTML file in the OS temp directory. Tailwind and Mermaid come from CDNs.

Use Mermaid for graph-shaped relationships. Use handcrafted CSS/SVG for mass diagrams, cross-sections, call-graph collapse, and before/after editorial visuals.

## Scaffold

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Architecture review - {{repo name}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <style>
      .seam { stroke-dasharray: 4 4; }
      .leak { stroke: #dc2626; }
      .deep { background: linear-gradient(135deg, #0f172a, #1e293b); }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans">
    <main class="max-w-5xl mx-auto px-6 py-12 space-y-12">
      <header>...</header>
      <section id="candidates" class="space-y-10">...</section>
      <section id="top-recommendation">...</section>
    </main>
  </body>
</html>
```

## Header

Include repo name, date, and a compact legend:

- solid box = module
- dashed line = seam
- red arrow = leakage
- thick dark box = deep module

No long intro. Go straight into candidates.

## Candidate Card

Each candidate is one `article`:

- title: short, names the deepening
- badge row: recommendation strength plus dependency category
- files: monospaced list
- before/after diagram: centerpiece
- problem: one sentence
- solution: one sentence
- wins: short bullets
- ADR callout, if applicable

If a diagram needs a paragraph to be understood, redraw the diagram.

## Diagram Patterns

Use different patterns when they fit:

- Mermaid graph for dependencies or call flow
- handcrafted boxes and arrows when Mermaid layout fights you
- cross-section for layered shallowness
- mass diagram for interface size versus implementation size
- call-graph collapse for turning scattered calls into one deep module

Keep diagrams around 320px tall so before/after fits side by side.

## Top Recommendation

One larger card:

- candidate name
- one sentence on why
- anchor link to its card

## Tone

Plain English, concise, and faithful to `/codebase-design` vocabulary.

Use exactly:

- module
- interface
- implementation
- depth
- deep
- shallow
- seam
- adapter
- leverage
- locality

Avoid:

- component, service, unit
- API, signature
- boundary
- generic claims like "cleaner code" unless tied to leverage or locality
