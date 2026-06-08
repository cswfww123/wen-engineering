# Project Lenses

First identify the project shape from setup harness output, `AGENTS.md`, `CONTEXT.md`, `.agents/rules/**`, build files, routes, services, and deployment config. Apply only the lenses that fit the changed files.

## Frontend

Look for:

- page-load regressions: larger bundles, blocking imports, unbounded client fetches, or missing lazy loading
- render regressions: expensive work during render, unstable dependencies, loops, layout thrash, or unnecessary re-renders
- memory leaks: listeners, timers, subscriptions, object URLs, caches, or workers without cleanup
- UX breakage: requested flows not reachable, loading/error/empty states missing, form state lost, accessibility regressions
- client security: XSS, unsafe HTML, exposed secrets, token leakage, broken authorization assumptions, or unsafe redirects

## Backend

Look for:

- slow queries: N+1 access, missing filters, missing indexes, full scans, unbounded result sets, or per-row network calls
- timeout risks: sequential remote calls, missing deadlines, missing cancellation, unbounded retries, or blocking hot paths
- memory risks: loading whole files/results into memory, unbounded queues/maps, missing stream backpressure, or missing cleanup
- data correctness: transaction gaps, idempotency breaks, race conditions, partial writes, migration hazards, or cache invalidation gaps
- security: injection, authn/authz bypass, tenant leaks, insecure deserialization, secret logging, SSRF/path traversal, or unsafe file handling

## Full-Stack

Look across the seam:

- API contracts: request/response shape drift, status-code mismatches, missing pagination, or client assumptions not guaranteed by the server
- latency budget: backend changes that make a page waterfall slower, frontend polling that overloads the API, or no timeout/retry strategy
- auth and privacy: client-visible fields, role checks split incorrectly, tenant identifiers trusted from the browser, or cache leaks
- migrations and rollout: frontend deployed before backend support, backward-incompatible API changes, or missing feature flags

## Library Or CLI

Look for:

- backward compatibility breaks outside the requested scope
- unbounded file-system traversal, memory-heavy parsing, or poor streaming behavior
- unsafe shell/path handling, surprising side effects, or confusing exit/error behavior
- missing coverage for the public interface the changed code exposes
