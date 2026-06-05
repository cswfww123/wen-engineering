# Rule File Template

Use this shape for files under `.agent/rules/**`. Keep each file focused on one language, layer, workflow, or boundary. Rules should prevent drift, not remove useful judgment.

If the project already has a clearer severity vocabulary, preserve it and map the meaning explicitly.

## Severity Labels

- `[MUST]` Required boundary. Use sparingly for constraints that protect correctness, consistency, safety, or maintainability.
- `[SHOULD]` Strong default. Agents may choose differently when evidence or user intent justifies it, but should say why.
- `[FORBID]` Prohibited pattern. Use only for known harmful choices or project decisions with no acceptable default exception.

## Template

```markdown
# <Rule Area>

Applies to: <paths, languages, layers, or project areas>
Source: <repo evidence, user decision, ADR, or config file>

## Rules

- [MUST] <non-negotiable rule>
- [SHOULD] <preferred convention and when it applies>
- [FORBID] <disallowed pattern>

## Verify

- <command, inspection, test, or review step that proves compliance>

## Exceptions

- <allowed exception and required documentation, or "None">
```

## Writing Rules

- Prefer concrete rules over principles.
- Name the boundary and the reason, not just the preference.
- Include only rules agents would otherwise get wrong.
- Prefer `[SHOULD]` unless the cost of divergence is high.
- Leave room for user taste when the decision is aesthetic, product-driven, or not yet settled.
- Split files when a rule mixes unrelated languages, layers, or workflows.
