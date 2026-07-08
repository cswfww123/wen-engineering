---
name: security-review
description: System-level security review: threat model and audit of a service or feature. Use before release, after security-relevant changes, or periodically.
---

# Security Review

Review the security of a target feature or service at the system level: threat
model its trust boundaries and data flow, then audit auth, secrets, dependencies,
and data exposure. This complements `/code-review`, which catches vulnerabilities
introduced by a diff. This skill does not re-review diffs.

Hold every finding report-only. Security changes — auth, crypto, secrets,
authorization rules — are never auto-fixed; the smallest fix is proposed and left
to `/to-issues`.

Trace the relevant code path whenever a claim depends on actual call behavior,
permission checks, query conditions, converters, or side effects. Do not reason
about hidden behavior from names.

## What Is Out Of Scope

- **Diff-level vulnerability review.** That is the `/code-review` security axis.
- **Running scanners.** SCA, secret scanning, and config scanning are executed by
  project tools configured via `/setup-project-harness`. This skill reads their
  output and judges it; it does not re-implement scanning.

## 1. Establish The Target

Default the target to the feature or service currently being worked on. Accept a
named path, service, entrypoint, or change set when the user provides one.

If the target is unclear, ask what to secure before proceeding.

## 2. Threat Model (judgment)

1. Trace the target and map its trust boundaries and data flow: where untrusted
   input enters, where it crosses a boundary, where it is persisted or returned.
2. Apply STRIDE per boundary: spoofing, tampering, repudiation, information
   disclosure, denial of service, elevation of privilege.
3. For each threat, state whether the code already defends against it, and cite
   the defense (or its absence) from the trace. Mark anything you cannot confirm
   as unknown — do not invent.

## 3. Existing-Risk Audit (consume and judge)

4. **Auth and authorization:** trace authn and authz paths for bypass, privilege
   escalation, tenant or row-level leakage, and missing checks on new entrypoints.
5. **Secrets and dependencies:** read scanner output already present in the repo
   (lockfile audit, secret scan, config scan). If a scanner is missing, note it
   as a harness gap and recommend adding it — do not scan manually.
6. **Data exposure:** check PII and secrets in logs, errors, URLs, client bundles,
   metrics, and exported files; check retention and redaction.

Skip a dimension with a one-line note when it does not apply (for example, no auth
in a pure frontend module). Say which dimensions were checked instead of staying
silent.

## 4. Report

Lead with threats ordered by severity. For each finding:

```markdown
### <severity>: <one-line summary>

- **Boundary / flow**: <where in the trust model>
- **Evidence**: <trace line, scanner output, or code line>
- **Why it matters**: <concrete exploit or exposure>
- **Fix direction**: <smallest useful change>
```

End with: dimensions checked, scanners consumed, harness gaps (missing tools), and
any threat that could not be confirmed.

## Related Skills

- `/code-review` — diff-level vulnerability review of changes
- `/to-issues` — turn critical findings into tracked security issues
- `/setup-project-harness` — configure security tooling (scanners, secret management)

Use any, in any order; this skill prescribes no sequence.
