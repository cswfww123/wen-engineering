# Stack recipes (generation briefs)

Load **only** the section that matches repo evidence. Each recipe is a
**generation brief** for the coding agent: what to wire, in what order, with
what names — not a full copy-paste dump. Prefer libraries already present in
lockfiles/manifests.

All recipes must satisfy [PRINCIPLES.md](PRINCIPLES.md).

---

## Java / Spring Boot

**Default surface:** SLF4J API + Logback (or the project’s existing backend).

| Piece | Prefer |
| --- | --- |
| API | `org.slf4j.Logger` / `@Slf4j` — never `System.out` on new code |
| Config | `logback-spring.xml` or `application-*.yml` `logging.*` per profile |
| Correlation | MDC keys e.g. `requestId`, `traceId`, `jobId` via `OncePerRequestFilter` / interceptor; clear in `finally` |
| Structure | Logback JSON encoder **or** structured key patterns the team already greps; document field names |
| Async / jobs | Set MDC (or equivalent) at job start from message headers; clear when done |
| Fail-open | Do not wrap business in try that rethrows logger errors; avoid custom appenders that throw into the caller; pattern layout evaluation must not abort requests |

**Build order:** (1) confirm SLF4J dependency, (2) profile levels/sinks, (3) MDC filter + pattern including `%X{requestId}`, (4) sample controller or filter log, (5) how-to-read (local file path or platform query).

**Avoid:** multiple logging facades on new modules; Log4j2 + Logback both writing without a bridge plan; putting MDC put outside try/finally.

---

## Node.js / TypeScript (generic API)

**Default surface:** `pino` (or existing `winston` / framework logger). Prefer one.

| Piece | Prefer |
| --- | --- |
| API | Single `logger` module exporting child-logger factory |
| Correlation | AsyncLocalStorage or framework request context; bind `requestId` on child logger |
| HTTP | Middleware that generates/propagates `x-request-id` (or project header) |
| Structure | JSON logs in prod; pretty transport only in dev |
| Fail-open | Never `await` remote log ship in the request path without isolation; child bindings must not throw domain errors |

**Build order:** logger module → env-based level → request middleware → one route smoke → how-to-read (`pino` stdout / log drain docs).

---

## Next.js (App Router or Pages)

**Default surface:** server-side structured logger (often `pino`); **do not** treat `console.log` in React client components as the production crime scene for backend paths.

| Piece | Prefer |
| --- | --- |
| Server / Route Handlers / Server Actions | Shared server logger + request id from headers or generated id |
| Edge | Lightweight logger compatible with Edge runtime constraints; document if Edge is out of full foundation |
| Client | User-facing errors only; send diagnostic detail via server or approved client pipeline — not secrets |
| Correlation | Propagate id across server components → route handlers → external fetch when the stack allows |
| Fail-open | Logging helpers must catch and swallow; never fail a Server Action because a log line failed |

**Build order:** server logger module → middleware/header id → one API route or Server Action sample → README how-to-read (Vercel logs / self-host journal).

**Avoid:** shipping a heavy Node-only logger into Edge without a thin path; dual client/server “logger” that mixes PII into browser consoles.

---

## Python (FastAPI / Django / Flask / workers)

**Default surface:** `structlog` **or** stdlib `logging` with a single project config. Prefer what the repo already imports.

| Piece | Prefer |
| --- | --- |
| API | Module-level `logger = get_logger(__name__)` pattern |
| Correlation | `contextvars` (or Django middleware context) for `request_id` / `job_id` |
| HTTP | Middleware that sets context + logs ingress summary |
| Structure | JSON renderer in prod; console in dev |
| Celery / RQ / ARQ | Job decorator/signal binds task id into context |
| Fail-open | Logging filters/processors must not raise into views; configure `raiseExceptions` carefully; never let a log processor abort a request |

**Build order:** dictConfig or structlog bootstrap → middleware → worker binder → smoke endpoint/test → how-to-read.

---

## Go

**Default surface:** `log/slog` (stdlib) or existing `zap` / `zerolog`.

| Piece | Prefer |
| --- | --- |
| API | Package-level or injected `*slog.Logger` with consistent attrs |
| Correlation | `context.Context` values + `Logger.With` / handler that reads context |
| HTTP | Middleware adds request id to context and logger |
| Structure | JSON handler in prod |
| Fail-open | Handlers should not panic on write failure in a way that kills handlers; document discard vs best-effort |

---

## Other / monorepo

1. Identify **production entrypoints** (services) that need full bar.
2. Apply one recipe **per service** — do not force one language’s logger across a polyglot monorepo.
3. Align **correlation header / field names** across services when they already share a gateway convention.
4. Document per-service how-to-read if sinks differ.

## Unknown stack

1. State stack from evidence.
2. Map PRINCIPLES properties to the ecosystem’s standard logger (search lockfile first).
3. Implement the smallest facade that meets full foundation.
4. If no production I/O → thin bar, stop.

## Shared field vocabulary (suggest, then adapt)

Document project names in how-to-read; defaults agents can start from:

| Field | Use |
| --- | --- |
| `requestId` / `traceId` | HTTP / inbound correlation |
| `jobId` / `messageId` | Async / MQ |
| `outcome` | `success` \| `empty` \| `error` \| `skipped` |
| `reason` | Short machine-stable skip/error class |
| `entityId` (or domain id names) | What the operation touched |
| `before` / `after` | State transitions (values safe to log) |

Feature paths add these at **decision boundaries** under implement — foundation
only needs the keys and correlation mechanism to exist and be documented.
