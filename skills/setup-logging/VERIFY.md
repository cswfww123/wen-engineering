# Verify logging foundation

Run after implement. Evidence required — claims without a command or sample line
do not count.

## Required checks (full bar)

### 1. Emits

- [ ] Start the app or run the smoke path in the cheapest realistic env.
- [ ] Produce **one** structured (or project-standard) log line with known text/fields.
- [ ] Retrieve that line via the documented **how-to-read** path (file, stdout capture, platform UI query).

Paste: command used + the matching log line (redact secrets).

### 2. Correlation

- [ ] Two log lines (or ingress + one downstream) share the same correlation id.
- [ ] Id appears in the configured context key / child logger binding, not only free text once.

### 3. Fail-open posture

Review the foundation code (not every call site yet):

- [ ] No business control flow requires “log succeeded”.
- [ ] Context/MDC set/clear cannot abort the request on failure (try/finally or framework guarantee).
- [ ] Custom appenders/shippers are not on an uncaught path that fails the domain transaction.
- [ ] Redaction forbid-list or helpers exist **or** are explicitly documented for implementers.

If a check cannot be automated, state the file:line evidence.

### 4. Docs

- [ ] How-to-read is written where agents will find it (README section and/or `docs/agents/logging.md`).
- [ ] Correlation key names and env-specific sinks are listed.
- [ ] Always-loaded `AGENTS.md` does **not** contain a logging essay (Checklist pin only if failure-proven).

### 5. Thin bar

- [ ] Project signal is pure library / no production I/O.
- [ ] Done report records `observability: n/a` / thin with one-line reason.
- [ ] No unnecessary logging framework forced into a pure package.

## Optional stretch (not required for foundation done)

- Log level override via env without rebuild.
- JSON logs in prod + human-readable in dev.
- Sample unit/integration test that the logger module constructs without throwing.

## Failure disposition

| Gap | Action |
| --- | --- |
| Does not emit | Fix sinks/config before claiming done |
| No correlation | Add middleware/context before claiming done |
| Log-unsafe foundation | Fix fail-open — blocking; same class as production log-unsafe |
| Missing how-to-read | Write the doc; foundation unusable by agents without it |
| Feature paths still quiet | Expected — track as implement debt, not setup-logging failure |
