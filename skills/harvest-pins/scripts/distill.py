#!/usr/bin/env python3
"""Deterministic session scan + distill for /harvest-pins.

No model. Stdlib only. Transcripts stay on disk except the distilled files
written under --out. Obvious secrets are redacted before write.
"""
from __future__ import annotations

import argparse
import json
import os
import re
import sys
from datetime import datetime, timezone, timedelta
from pathlib import Path
from typing import Any, Iterable
from urllib.parse import quote

BUDGET_DEFAULT = 1200
MAX_SESSIONS_DEFAULT = 20
SINCE_DEFAULT = "90d"
USER_LIMIT = 2000
ASSISTANT_LIMIT = 1600
TOOL_ARG_LIMIT = 160
TOOL_OUT_LIMIT = 200
SESSION_CHAR_LIMIT = 9000
SELF_QUERY_RE = re.compile(r"(?i)^\s*/harvest-pins\b")
USER_QUERY_RE = re.compile(r"<user_query>\s*(.*?)\s*</user_query>", re.S)
SECRET_RES = [
    re.compile(r"sk-[A-Za-z0-9]{10,}"),
    re.compile(r"ghp_[A-Za-z0-9]{20,}"),
    re.compile(r"github_pat_[A-Za-z0-9_]{20,}"),
    re.compile(r"xox[baprs]-[A-Za-z0-9-]{10,}"),
    re.compile(r"AKIA[0-9A-Z]{16}"),
    re.compile(r"-----BEGIN [A-Z ]*PRIVATE KEY-----[\s\S]+?-----END [A-Z ]*PRIVATE KEY-----"),
    re.compile(r"(?i)(api[_-]?key|token|secret|password)\s*[:=]\s*\S+"),
]
SCAFFOLD_PREFIXES = (
    "<system-reminder>",
    "<user_info>",
    "<environment_context>",
    "<permissions instructions>",
    "<INSTRUCTIONS>",
    "# AGENTS.md instructions",
    "You are Grok ",
    "You are Codex",
    "You are Claude",
    "<command-name>",
    "<command-message>",
    "<command-args>",
    "<local-command-",
    "Base directory for this skill:",
)


def utc_now() -> datetime:
    return datetime.now(timezone.utc)


def parse_since(value: str) -> datetime | None:
    if value in ("all", "0", ""):
        return None
    m = re.fullmatch(r"(\d+)([dhm])", value.strip().lower())
    if not m:
        raise SystemExit(f"invalid --since {value!r}; use Nd/Nh/Nm or all")
    n = int(m.group(1))
    unit = m.group(2)
    delta = {"d": timedelta(days=n), "h": timedelta(hours=n), "m": timedelta(minutes=n)}[unit]
    return utc_now() - delta


def estimate_tokens(data: bytes | str) -> int:
    if isinstance(data, str):
        data = data.encode("utf-8")
    return max(1, len(data) // 4) if data else 0


def redact(text: str) -> str:
    out = text
    for rx in SECRET_RES:
        out = rx.sub("[REDACTED]", out)
    return out


def clip(text: str, limit: int) -> str:
    text = text.replace("\r\n", "\n").strip()
    if len(text) <= limit:
        return text
    return text[: limit - 1] + "…"


def flatten_text(content: Any) -> str:
    if content is None:
        return ""
    if isinstance(content, str):
        return content
    if isinstance(content, list):
        parts = [flatten_text(x) for x in content]
        return "\n".join(p for p in parts if p)
    if isinstance(content, dict):
        if content.get("type") in ("text", "output_text", "input_text", "summary_text"):
            return flatten_text(content.get("text") or content.get("content"))
        if "text" in content:
            return flatten_text(content["text"])
        if "content" in content:
            return flatten_text(content["content"])
        if "message" in content:
            return flatten_text(content["message"])
    return ""


def is_scaffold(text: str) -> bool:
    s = text.lstrip()
    return any(s.startswith(p) for p in SCAFFOLD_PREFIXES)


def extract_user_text(text: str) -> str | None:
    if not text or not text.strip():
        return None
    m = USER_QUERY_RE.search(text)
    if m:
        q = m.group(1).strip()
        return q or None
    if is_scaffold(text):
        return None
    return text.strip()


def one_line(text: str, limit: int) -> str:
    return clip(re.sub(r"\s+", " ", text).strip(), limit)


def tool_line(name: str, args: Any, result: str | None = None) -> str:
    arg_s = one_line(args if isinstance(args, str) else json.dumps(args, ensure_ascii=False), TOOL_ARG_LIMIT)
    if result is None:
        return f"tool: {name} {arg_s}"
    return f"tool: {name} {arg_s} -> {one_line(result, TOOL_OUT_LIMIT)}"


def mtime_iso(path: Path) -> str:
    ts = path.stat().st_mtime
    return datetime.fromtimestamp(ts, timezone.utc).isoformat(timespec="seconds")


def file_fresh(path: Path, since: datetime | None) -> bool:
    if since is None:
        return True
    return datetime.fromtimestamp(path.stat().st_mtime, timezone.utc) >= since


def run_git(repo: Path, *args: str) -> str | None:
    import subprocess

    try:
        out = subprocess.check_output(
            ["git", "-C", str(repo), *args],
            stderr=subprocess.DEVNULL,
            text=True,
        )
        return out.strip()
    except (subprocess.CalledProcessError, FileNotFoundError):
        return None


def repo_roots(repo: Path) -> list[Path]:
    roots = [repo.resolve()]
    raw = run_git(repo, "worktree", "list", "--porcelain")
    if raw:
        for line in raw.splitlines():
            if line.startswith("worktree "):
                roots.append(Path(line.split(" ", 1)[1]).resolve())
    seen: list[Path] = []
    for p in roots:
        if p not in seen:
            seen.append(p)
    return seen


def repo_remotes(repo: Path) -> set[str]:
    raw = run_git(repo, "remote", "-v") or ""
    urls: set[str] = set()
    for line in raw.splitlines():
        parts = line.split()
        if len(parts) >= 2:
            urls.add(normalize_remote(parts[1]))
    return urls


def normalize_remote(url: str) -> str:
    u = url.strip().rstrip("/")
    u = re.sub(r"\.git$", "", u)
    u = u.replace("git@github.com:", "https://github.com/")
    u = u.replace("ssh://git@github.com/", "https://github.com/")
    return u.lower()


def cwd_in_repo(cwd: str | None, roots: Iterable[Path]) -> bool:
    if not cwd:
        return False
    try:
        path = Path(cwd).resolve()
    except OSError:
        return False
    for root in roots:
        try:
            path.relative_to(root)
            return True
        except ValueError:
            continue
    return False


def claude_slug(cwd: Path) -> str:
    return str(cwd).replace("/", "-")


def grok_slug(cwd: Path) -> str:
    return quote(str(cwd), safe="")


def home() -> Path:
    return Path(os.path.expanduser("~"))


# --- distill records -------------------------------------------------------

class Session:
    def __init__(self, harness: str, sid: str, source: Path, cwd: str | None, mtime: str):
        self.harness = harness
        self.id = sid
        self.source = source
        self.cwd = cwd
        self.mtime = mtime
        self.lines: list[str] = []
        self.tool_at: dict[str, int] = {}
        self.user_turns = 0
        self.tool_calls = 0
        self.skip_reason: str | None = None
        self.tier = 1

    def add_user(self, text: str) -> None:
        q = extract_user_text(text)
        if not q:
            return
        q = redact(q)
        if self.user_turns == 0 and SELF_QUERY_RE.search(q):
            self.skip_reason = "harvest-pins self session"
            return
        self.user_turns += 1
        self.lines.append("## user")
        self.lines.append(clip(q, USER_LIMIT))
        self.lines.append("")

    def add_assistant(self, text: str) -> None:
        t = flatten_text(text).strip()
        if not t or is_scaffold(t):
            return
        t = redact(t)
        self.lines.append("## assistant")
        self.lines.append(clip(t, ASSISTANT_LIMIT))
        self.lines.append("")

    def add_tool(self, name: str, args: Any, result: str | None = None, cid: str | None = None) -> None:
        self.tool_calls += 1
        self.lines.append(tool_line(name, args, redact(result) if result else None))
        if cid:
            self.tool_at[cid] = len(self.lines) - 1

    def finish_tool(self, cid: str, name: str, args: Any, result: str) -> None:
        idx = self.tool_at.get(cid)
        line = tool_line(name, args, redact(result))
        if idx is not None:
            self.lines[idx] = line
        else:
            self.lines.append(line)

    def render(self) -> str:
        header = [
            f"# {self.harness}:{self.id}",
            f"cwd: {self.cwd or ''}",
            f"mtime: {self.mtime}",
            f"source: {self.source}",
            "",
        ]
        body = "\n".join(self.lines).strip()
        text = "\n".join(header) + body + "\n"
        if len(text) > SESSION_CHAR_LIMIT:
            text = text[: SESSION_CHAR_LIMIT - 1] + "…\n"
        return text


# --- grok ------------------------------------------------------------------

def iter_grok(roots: list[Path], since: datetime | None) -> list[Session]:
    base = home() / ".grok" / "sessions"
    if not base.is_dir():
        return []
    out: list[Session] = []
    slugs = {grok_slug(r): r for r in roots}
    for slug, root in slugs.items():
        d = base / slug
        if not d.is_dir():
            # leftover encoded names that still decode to this root
            continue
        for sess_dir in d.iterdir():
            if not sess_dir.is_dir():
                continue
            hist = sess_dir / "chat_history.jsonl"
            if not hist.is_file() or not file_fresh(hist, since):
                continue
            summary = {}
            sp = sess_dir / "summary.json"
            if sp.is_file():
                try:
                    summary = json.loads(sp.read_text(encoding="utf-8"))
                except json.JSONDecodeError:
                    summary = {}
            cwd = (summary.get("info") or {}).get("cwd") or str(root)
            sess = Session("grok", sess_dir.name, hist, cwd, mtime_iso(hist))
            pending: dict[str, tuple[str, Any]] = {}
            try:
                with hist.open(encoding="utf-8") as f:
                    for line in f:
                        try:
                            obj = json.loads(line)
                        except json.JSONDecodeError:
                            continue
                        kind = obj.get("type")
                        if kind == "user":
                            sess.add_user(flatten_text(obj.get("content")))
                        elif kind == "assistant":
                            sess.add_assistant(obj.get("content") or "")
                            for call in obj.get("tool_calls") or []:
                                cid = str(call.get("id") or "")
                                name = str(call.get("name") or "tool")
                                args = call.get("arguments")
                                if isinstance(args, str):
                                    try:
                                        args = json.loads(args)
                                    except json.JSONDecodeError:
                                        pass
                                pending[cid] = (name, args)
                                sess.add_tool(name, args, cid=cid)
                        elif kind == "tool_result":
                            cid = str(obj.get("tool_call_id") or "")
                            name, args = pending.pop(cid, ("tool", {}))
                            result = flatten_text(obj.get("content"))
                            if result:
                                sess.finish_tool(cid, name, args, result)
            except OSError:
                continue
            if sess.user_turns == 0 and not sess.skip_reason:
                sess.skip_reason = "no user turns"
            out.append(sess)
    return out


# --- claude ----------------------------------------------------------------

def claude_project_dirs(roots: list[Path]) -> list[Path]:
    bases = [home() / ".claude" / "projects"]
    extra = os.environ.get("CLAUDE_CONFIG_DIR")
    if extra:
        bases.append(Path(extra).expanduser() / "projects")
    dirs: list[Path] = []
    slugs = {claude_slug(r) for r in roots}
    for base in bases:
        if not base.is_dir():
            continue
        for slug in slugs:
            d = base / slug
            if d.is_dir():
                dirs.append(d)
    return dirs


def iter_claude(roots: list[Path], since: datetime | None) -> list[Session]:
    out: list[Session] = []
    for d in claude_project_dirs(roots):
        for path in sorted(d.glob("*.jsonl")):
            if not file_fresh(path, since):
                continue
            sess = Session("claude", path.stem, path, None, mtime_iso(path))
            pending: dict[str, tuple[str, Any]] = {}
            try:
                with path.open(encoding="utf-8") as f:
                    for line in f:
                        try:
                            obj = json.loads(line)
                        except json.JSONDecodeError:
                            continue
                        if obj.get("isSidechain"):
                            continue
                        if not sess.cwd:
                            sess.cwd = obj.get("cwd")
                        kind = obj.get("type")
                        msg = obj.get("message") or {}
                        content = msg.get("content")
                        if kind == "user":
                            if isinstance(content, list):
                                texts: list[str] = []
                                for block in content:
                                    if not isinstance(block, dict):
                                        continue
                                    if block.get("type") == "tool_result":
                                        cid = str(block.get("tool_use_id") or "")
                                        result = flatten_text(block.get("content"))
                                        name, args = pending.get(cid, ("tool", {}))
                                        if result:
                                            sess.finish_tool(cid, name, args, result)
                                    else:
                                        texts.append(flatten_text(block))
                                if texts:
                                    sess.add_user("\n".join(texts))
                            else:
                                sess.add_user(flatten_text(content))
                        elif kind == "assistant":
                            texts = []
                            if isinstance(content, list):
                                for block in content:
                                    if not isinstance(block, dict):
                                        continue
                                    btype = block.get("type")
                                    if btype in ("text", "output_text"):
                                        texts.append(flatten_text(block))
                                    elif btype == "tool_use":
                                        name = str(block.get("name") or "tool")
                                        args = block.get("input")
                                        cid = str(block.get("id") or "")
                                        pending[cid] = (name, args)
                                        sess.add_tool(name, args, cid=cid)
                            else:
                                texts.append(flatten_text(content))
                            body = "\n".join(t for t in texts if t)
                            if body:
                                sess.add_assistant(body)
            except OSError:
                continue
            if sess.user_turns == 0 and not sess.skip_reason:
                sess.skip_reason = "no user turns"
            if sess.cwd and not cwd_in_repo(sess.cwd, roots):
                sess.skip_reason = sess.skip_reason or "cwd mismatch"
            out.append(sess)
    return out


# --- codex -----------------------------------------------------------------

def iter_codex(roots: list[Path], remotes: set[str], since: datetime | None, strict: bool) -> list[Session]:
    base = home() / ".codex" / "sessions"
    if not base.is_dir():
        return []
    out: list[Session] = []
    for path in base.glob("*/*/*/*.jsonl"):
        if not path.is_file() or path.name.startswith("."):
            continue
        if not file_fresh(path, since):
            continue
        try:
            with path.open(encoding="utf-8") as f:
                first = f.readline()
        except OSError:
            continue
        try:
            meta = json.loads(first)
        except json.JSONDecodeError:
            continue
        if meta.get("type") != "session_meta":
            continue
        payload = meta.get("payload") or {}
        cwd = payload.get("cwd")
        git = payload.get("git") or {}
        remote = normalize_remote(git.get("repository_url") or "")
        tier = 0
        if cwd_in_repo(cwd, roots):
            tier = 1
        elif remote and remote in remotes:
            tier = 2
        if tier == 0 or (strict and tier == 2):
            continue
        sess = Session("codex", payload.get("id") or path.stem, path, cwd, mtime_iso(path))
        sess.tier = tier
        pending: dict[str, tuple[str, Any]] = {}
        try:
            with path.open(encoding="utf-8") as f:
                for line in f:
                    try:
                        obj = json.loads(line)
                    except json.JSONDecodeError:
                        continue
                    kind = obj.get("type")
                    pl = obj.get("payload") or {}
                    if kind == "event_msg" and pl.get("type") == "user_message":
                        sess.add_user(flatten_text(pl.get("message")))
                    elif kind == "event_msg" and pl.get("type") == "agent_message":
                        sess.add_assistant(flatten_text(pl.get("message")))
                    elif kind == "response_item" and pl.get("type") == "function_call":
                        name = str(pl.get("name") or "tool")
                        args = pl.get("arguments")
                        if isinstance(args, str):
                            try:
                                args = json.loads(args)
                            except json.JSONDecodeError:
                                pass
                        cid = str(pl.get("call_id") or "")
                        pending[cid] = (name, args)
                        sess.add_tool(name, args, cid=cid)
                    elif kind == "response_item" and pl.get("type") == "function_call_output":
                        cid = str(pl.get("call_id") or "")
                        name, args = pending.get(cid, ("tool", {}))
                        result = flatten_text(pl.get("output"))
                        if result:
                            sess.finish_tool(cid, name, args, result)
                    elif kind == "response_item" and pl.get("type") == "custom_tool_call":
                        sess.add_tool(str(pl.get("name") or "custom"), pl.get("input") or pl.get("arguments"))
        except OSError:
            continue
        if sess.user_turns == 0 and not sess.skip_reason:
            sess.skip_reason = "no user turns"
        out.append(sess)
    return out


# --- measure / write -------------------------------------------------------

def measure(path: Path) -> dict[str, Any]:
    data = path.read_bytes() if path.is_file() else b""
    return {
        "path": str(path),
        "bytes": len(data),
        "est_tokens": estimate_tokens(data),
        "exists": path.is_file(),
    }


def store_status(name: str, path: Path) -> dict[str, Any]:
    return {"store": str(path), "present": path.is_dir()}


def write_run(out_dir: Path, repo: Path, sessions: list[Session], budget_cap: int) -> dict[str, Any]:
    out_dir.mkdir(parents=True, exist_ok=True)
    sess_dir = out_dir / "sessions"
    sess_dir.mkdir(exist_ok=True)
    kept: list[dict[str, Any]] = []
    skipped: list[dict[str, Any]] = []
    for sess in sessions:
        rec = {
            "id": sess.id,
            "harness": sess.harness,
            "cwd": sess.cwd,
            "mtime": sess.mtime,
            "source": str(sess.source),
            "user_turns": sess.user_turns,
            "tool_calls": sess.tool_calls,
            "tier": sess.tier,
        }
        if sess.skip_reason:
            rec["skip_reason"] = sess.skip_reason
            skipped.append(rec)
            continue
        rel = f"sessions/{sess.harness}-{sess.id}.md"
        (out_dir / rel).write_text(sess.render(), encoding="utf-8")
        rec["distill"] = rel
        kept.append(rec)
    agents = repo / "AGENTS.md"
    bud = measure(agents)
    bud["cap"] = budget_cap
    bud["over"] = bud["est_tokens"] > budget_cap
    harnesses = {
        "grok": store_status("grok", home() / ".grok" / "sessions"),
        "claude": store_status("claude", home() / ".claude" / "projects"),
        "codex": store_status("codex", home() / ".codex" / "sessions"),
    }
    index = {
        "repo": str(repo),
        "generated_at": utc_now().isoformat(timespec="seconds"),
        "budget": bud,
        "harnesses": harnesses,
        "kept": kept,
        "skipped": skipped,
        "counts": {
            "kept": len(kept),
            "skipped": len(skipped),
            "by_harness": {
                h: sum(1 for s in kept if s["harness"] == h) for h in ("grok", "claude", "codex")
            },
        },
    }
    (out_dir / "index.json").write_text(json.dumps(index, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    return index


def cap_sessions(sessions: list[Session], limit: int) -> list[Session]:
    usable = [s for s in sessions if not s.skip_reason]
    skipped = [s for s in sessions if s.skip_reason]
    usable.sort(key=lambda s: s.mtime, reverse=True)
    if limit <= 0 or len(usable) <= limit:
        return usable + skipped
    overflow = usable[limit:]
    for s in overflow:
        s.skip_reason = f"over --max-sessions {limit}"
    return usable[:limit] + skipped + overflow


def self_test() -> int:
    failures = 0

    def check(cond: bool, msg: str) -> None:
        nonlocal failures
        if not cond:
            print(f"FAIL {msg}", file=sys.stderr)
            failures += 1

    check(extract_user_text("<user_query>\nhello\n</user_query>") == "hello", "user_query extract")
    check(extract_user_text("<system-reminder>\nskip\n") is None, "scaffold skip")
    check(extract_user_text("<command-name>/exit</command-name>") is None, "command wrapper skip")
    check("[REDACTED]" in redact("token=ghp_abcdefghijklmnopqrstuvwxyz012345"), "redact ghp")
    check(claude_slug(Path("/Users/apple/Develop/wen-engineering")) == "-Users-apple-Develop-wen-engineering", "claude slug")
    check("%2F" in grok_slug(Path("/Users/apple/Develop/wen-engineering")), "grok slug")
    check(estimate_tokens("abcd") == 1, "token estimate")
    check(SELF_QUERY_RE.search("/harvest-pins do the thing"), "self query")
    if failures:
        print(f"{failures} self-test failure(s)", file=sys.stderr)
        return 1
    print("self-test ok")
    return 0


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Scan and distill local agent sessions for /harvest-pins")
    parser.add_argument("--repo", default=".", help="repository root (default: cwd)")
    parser.add_argument("--since", default=SINCE_DEFAULT, help="Nd/Nh/Nm or all (default: 90d)")
    parser.add_argument("--max-sessions", type=int, default=MAX_SESSIONS_DEFAULT)
    parser.add_argument("--budget", type=int, default=BUDGET_DEFAULT)
    parser.add_argument("--out", default=None, help="output directory (default: <repo>/.scratch/harvest-pins/<stamp>)")
    parser.add_argument("--strict", action="store_true", help="cwd match only; drop git-remote fallback")
    parser.add_argument("--measure", metavar="FILE", help="print token estimate for a file and exit")
    parser.add_argument("--self-test", action="store_true")
    args = parser.parse_args(argv)

    if args.self_test:
        return self_test()
    if args.measure:
        print(json.dumps(measure(Path(args.measure)), ensure_ascii=False))
        return 0

    repo = Path(args.repo).resolve()
    if not repo.is_dir():
        print(f"repo not a directory: {repo}", file=sys.stderr)
        return 2
    since = parse_since(args.since)
    roots = repo_roots(repo)
    remotes = repo_remotes(repo)

    sessions: list[Session] = []
    sessions.extend(iter_grok(roots, since))
    sessions.extend(iter_claude(roots, since))
    sessions.extend(iter_codex(roots, remotes, since, args.strict))
    sessions = cap_sessions(sessions, args.max_sessions)

    stamp = utc_now().strftime("%Y%m%dT%H%M%SZ")
    out_dir = Path(args.out).resolve() if args.out else repo / ".scratch" / "harvest-pins" / stamp
    index = write_run(out_dir, repo, sessions, args.budget)
    summary = {
        "ok": True,
        "out": str(out_dir),
        "index": str(out_dir / "index.json"),
        "sessions": index["counts"]["kept"],
        "skipped": index["counts"]["skipped"],
        "by_harness": index["counts"]["by_harness"],
        "est_tokens": index["budget"]["est_tokens"],
        "budget": args.budget,
        "over": index["budget"]["over"],
        "harness_stores": {k: v["present"] for k, v in index["harnesses"].items()},
    }
    print(json.dumps(summary, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except BrokenPipeError:
        sys.exit(0)
