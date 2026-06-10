# Project Lenses

First identify the project shape from setup harness output, `AGENTS.md`, `CONTEXT.md`, `.agents/rules/**`, build files, routes, services, and deployment config. Apply only the lenses that fit the changed files.

## Frontend

Look for:

- page-load regressions: larger bundles, blocking imports, unbounded client fetches, or missing lazy loading
- render regressions: expensive work during render, unstable dependencies, loops, layout thrash, or unnecessary re-renders
- memory and OOM risks: listeners, timers, subscriptions, object URLs, caches, workers, large client-side lists, or previews without cleanup or bounds
- CPU amplification: repeated parsing, filtering, sorting, serialization, or layout work over growing inputs
- observability regressions: swallowed fetch/render errors, missing error boundary propagation, or console/network failures made harder to diagnose
- UX breakage: requested flows not reachable, loading/error/empty states missing, form state lost, accessibility regressions
- client security: XSS, unsafe HTML, exposed secrets, token leakage, broken authorization assumptions, or unsafe redirects
- dependency risk: large blocking dependencies, client-only secrets in config, risky package sources, or unnecessary browser permissions

## Backend

Look for:

- query/IO amplification: N+1 access, repeated same-table/query calls in loops, duplicate request-scoped lookups, or per-row network calls
- slow queries: missing filters, missing indexes, full scans, unbounded result sets, unstable query plans, or expensive sorts/joins
- timeout risks: sequential remote calls, missing deadlines, missing cancellation, unbounded retries, or blocking hot paths
- memory and OOM risks: loading whole files/results into memory, unbounded queues/maps, large batch materialization, missing stream backpressure, or missing cleanup
- CPU amplification: nested loops over growing inputs, repeated parsing/serialization, repeated encryption/compression, or avoidable recomputation
- job/queue risks: non-idempotent retries, duplicate consumption, task fanout, missing dead-letter handling, schedule overlap, or missing backpressure
- observability regressions: swallowed exceptions, missing correlation IDs, missing timing/error metrics, high-cardinality labels, or logs that hide the failing entity
- data correctness: transaction gaps, idempotency breaks, race conditions, partial writes, migration hazards, or cache invalidation gaps
- security: injection, authn/authz bypass, tenant leaks, insecure deserialization, secret logging, SSRF/path traversal, or unsafe file handling
- dependency risk: new privileged libraries, unpinned external artifacts, risky transitive dependencies, license/policy exposure, or unnecessary runtime surface

## Full-Stack

Look across the seam:

- API contracts: request/response shape drift, status-code mismatches, missing pagination, or client assumptions not guaranteed by the server
- latency budget: backend changes that make a page waterfall slower, frontend polling that overloads the API, or no timeout/retry strategy
- duplicated work: both client and server recompute or refetch the same growing data without a stable contract
- observability seam: request IDs, job IDs, user-visible errors, and server logs no longer line up across the flow
- auth and privacy: client-visible fields, role checks split incorrectly, tenant identifiers trusted from the browser, or cache leaks
- migrations and rollout: frontend deployed before backend support, backward-incompatible API changes, or missing feature flags

## Library Or CLI

Look for:

- backward compatibility breaks outside the requested scope
- unbounded file-system traversal, memory-heavy parsing, CPU-heavy transforms, or poor streaming behavior
- unsafe shell/path handling, surprising side effects, or confusing exit/error behavior
- dependency risk: new runtime downloads, unpinned plugins, unsafe transitive packages, license/policy exposure, or unnecessary install-time side effects
- observability regressions: ambiguous exit codes, missing stderr context, or errors that cannot be tied to the input that failed
