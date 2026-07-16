# Wayfinder short pastes

Humans should not re-explain the effort each session. After Chart, the agent
writes `next_paste` into the map's **Session handoff**; copy that one line.

If handoff is missing, use the templates below (still one line when possible).

## Chart (first session only)

```text
/wayfinder Chart <one-line destination>. Constraints: <optional bullets or @docs>. Prefer research over grill; frontier ≤5.
```

Optional extras (only if known): production URLs, "architecture cleanup out of scope", skills to consult.

## Resolve next HITL ticket

```text
/wayfinder
```

Agent reads the map handoff and takes the next frontier ticket. Even shorter if
you already know the map path:

```text
/wayfinder .scratch/<slug>/WAYFINDER.md
```

Named ticket:

```text
/wayfinder 票 <name or NN>
```

## Resolve AFK burn-down (same or new session)

```text
/wayfinder AFK
```

Agent closes open unblocked `research` / AFK `task` tickets only (may batch).

## Grill answers (during HITL)

Prefer diffs, not long essays:

```text
按推荐
```

```text
按推荐，除第 2、5 行：2→无效；5→删
```

## Map finished → coding track (no more wayfinder)

```text
/to-spec .scratch/<slug>/
```

then:

```text
/to-tickets
```

then:

```text
/implement
```

## When you feel lost after grilling

| Map status | What you do |
| --- | --- |
| `active`, frontier has HITL | `/wayfinder` (or handoff `next_paste`) |
| `active`, frontier only AFK | `/wayfinder AFK` |
| `resolved`, no SPEC yet | `/to-spec .scratch/<slug>/` |
| SPEC `accepted` | `/to-tickets` → `/implement` |
| Implementing | `/implement` only — do not re-open wayfinder |

Wayfinder ends when the **route is clear**, not when code ships.
