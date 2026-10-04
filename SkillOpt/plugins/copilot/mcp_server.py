#!/usr/bin/env python3
"""SkillOpt-Sleep — minimal MCP server (stdio, stdlib-only).

Exposes the sleep engine as MCP tools so any MCP-capable client (GitHub Copilot
CLI / VS Code, Claude Desktop, etc.) can drive it. No third-party deps: speaks
JSON-RPC 2.0 over stdio with just the handful of MCP methods clients need.

Tools exposed:
  - sleep_status   : how many nights have run + the latest staged proposal
  - sleep_dry_run  : harvest+mine+replay, report only (no staging)
  - sleep_run      : full cycle, stages a proposal (nothing live changes)
  - sleep_adopt    : apply a reviewed legacy or per-skill proposal (with backup)
  - sleep_harvest  : debug — list mined recurring tasks

Each tool shells out to `python -m skillopt_sleep <action> ...` and returns its
stdout. Configure your client to launch:  python plugins/copilot/mcp_server.py
"""
from __future__ import annotations

import json
import os
import subprocess
import sys
from typing import NamedTuple

REPO_ROOT = os.environ.get("SKILLOPT_SLEEP_REPO") or os.path.abspath(
    os.path.join(os.path.dirname(__file__), "..", "..")
)
PROTOCOL_VERSION = "2024-11-05"

TOOLS = [
    {"name": "sleep_status", "action": "status",
     "description": "Show how many SkillOpt-Sleep nights have run and the latest staged proposal."},
    {"name": "sleep_dry_run", "action": "dry-run",
     "description": "Preview a sleep cycle (harvest+mine+replay) without staging anything."},
    {"name": "sleep_run", "action": "run",
     "description": "Run a full sleep cycle; stages a reviewed proposal. Nothing live changes until adopt."},
    {"name": "sleep_adopt", "action": "adopt",
     "description": "Apply a reviewed legacy or per-skill staged proposal (backs up first)."},
    {"name": "sleep_harvest", "action": "harvest",
     "description": "Debug: list the recurring tasks mined from recent sessions."},
    {"name": "sleep_schedule", "action": "schedule",
     "description": "Install a nightly cron entry to run the sleep cycle automatically."},
    {"name": "sleep_unschedule", "action": "unschedule",
     "description": "Remove the nightly cron entry for a project."},
]
_BY_NAME = {t["name"]: t for t in TOOLS}

_TOOL_SCHEMA = {
    "type": "object",
    "properties": {
        "project": {"type": "string",
                     "description": "Project dir to evolve (default: cwd)."},
        "backend": {
            "type": "string",
            "enum": ["mock", "claude", "codex", "copilot", "handoff"],
            "description": "mock = local/default; claude/codex/copilot = real; handoff = no API subprocess.",
        },
        "scope": {"type": "string", "enum": ["invoked", "all"],
                  "description": "Harvest scope (default: invoked project only)."},
        "source": {"type": "string", "enum": ["claude", "codex", "auto"],
                   "description": "Transcript source (default: claude)."},
        "model": {"type": "string",
                  "description": "Backend-specific model override."},
        "tasks_file": {"type": "string",
                       "description": "Path to reviewed TaskRecord JSON (skips harvest)."},
        "target_skill_path": {"type": "string",
                              "description": "Explicit SKILL.md path to evolve/stage/adopt."},
        "staging": {
            "type": "string",
            "description": "For sleep_adopt, use this exact staging directory instead of the latest night.",
        },
        "skills": {
            "type": "array",
            "items": {"type": "string", "minLength": 1},
            "uniqueItems": True,
            "description": "For sleep_adopt, adopt only these staged per-skill proposals.",
        },
        "all_skills": {
            "type": "boolean",
            "description": "For sleep_adopt, adopt every staged per-skill proposal.",
        },
        "legacy": {
            "type": "boolean",
            "description": "For sleep_adopt, adopt only the legacy managed SKILL.md/CLAUDE.md pair.",
        },
        "progress": {"type": "boolean",
                     "description": "Print phase progress to stderr."},
        "max_sessions": {"type": "integer", "minimum": 0, "maximum": 1_000_000,
                         "description": "Cap harvested sessions per run."},
        "max_tasks": {"type": "integer", "minimum": 0, "maximum": 1_000_000,
                       "description": "Cap mined tasks per run."},
        "lookback_hours": {"type": "integer", "minimum": 0, "maximum": 1_000_000,
                           "description": "Harvest window in hours (default: 72)."},
        "auto_adopt": {"type": "boolean",
                       "description": "Auto-adopt if gate passes (default: false)."},
        "json": {"type": "boolean",
                 "description": "Return machine-readable JSON output."},
        "edit_budget": {"type": "integer", "minimum": 0, "maximum": 1_000_000,
                        "description": "Max bounded edits per night (default: 4)."},
        "hour": {"type": "integer", "minimum": 0, "maximum": 23,
                 "description": "Hour for schedule (0-23, default: 3)."},
        "minute": {"type": "integer", "minimum": 0, "maximum": 59,
                   "description": "Minute for schedule (0-59, default: 17)."},
    },
    "additionalProperties": False,
}

_STRING_ARGS = {
    "project", "backend", "scope", "source", "model", "tasks_file",
    "target_skill_path", "staging",
}
_BOOLEAN_ARGS = {"all_skills", "legacy", "progress", "auto_adopt", "json"}
_INTEGER_BOUNDS = {
    "max_sessions": (0, 1_000_000),
    "max_tasks": (0, 1_000_000),
    "lookback_hours": (0, 1_000_000),
    "edit_budget": (0, 1_000_000),
    "hour": (0, 23),
    "minute": (0, 59),
}
_ADOPT_ONLY_ARGS = {"staging", "skills", "all_skills", "legacy"}
_SCHEDULE_ONLY_ARGS = {"hour", "minute"}


class EngineResult(NamedTuple):
    """One engine invocation, including status hidden by the old text-only API."""

    text: str
    returncode: int
    diagnostics: str = ""


def _validate_text(key: str, value: object) -> None:
    if type(value) is not str:
        raise ValueError(f"{key} must be a string")
    if any(ord(ch) < 32 or ord(ch) == 127 for ch in value):
        raise ValueError(f"{key} must not contain control characters")


def _validate_tool_arguments(action: str, args: object) -> dict:
    """Validate MCP input at runtime; clients are not trusted to enforce schema."""
    if action not in {tool["action"] for tool in TOOLS}:
        raise ValueError(f"unknown action: {action}")
    if type(args) is not dict:
        raise ValueError("arguments must be an object")
    unknown = sorted(set(args) - set(_TOOL_SCHEMA["properties"]))
    if unknown:
        raise ValueError(f"unknown argument(s): {', '.join(unknown)}")
    if action != "adopt" and set(args) & _ADOPT_ONLY_ARGS:
        raise ValueError("staging/skills/all_skills/legacy are valid only for sleep_adopt")
    if action != "schedule" and set(args) & _SCHEDULE_ONLY_ARGS:
        raise ValueError("hour/minute are valid only for sleep_schedule")

    for key in _STRING_ARGS & set(args):
        _validate_text(key, args[key])
    for key in _BOOLEAN_ARGS & set(args):
        if type(args[key]) is not bool:
            raise ValueError(f"{key} must be a boolean")
    for key, (minimum, maximum) in _INTEGER_BOUNDS.items():
        if key not in args:
            continue
        value = args[key]
        if type(value) is not int:
            raise ValueError(f"{key} must be an integer")
        if not minimum <= value <= maximum:
            raise ValueError(f"{key} must be between {minimum} and {maximum}")

    for key in ("backend", "scope", "source"):
        if key in args and args[key] not in _TOOL_SCHEMA["properties"][key]["enum"]:
            raise ValueError(f"unsupported {key}: {args[key]!r}")

    skills = args.get("skills", [])
    if type(skills) is not list:
        raise ValueError("skills must be an array of strings")
    normalized = []
    for skill in skills:
        _validate_text("every skills entry", skill)
        name = skill.strip()
        if not name:
            raise ValueError("every skills entry must be non-empty")
        normalized.append(name)
    if len(set(normalized)) != len(normalized):
        raise ValueError("skills entries must be unique")

    modes = sum((bool(normalized), args.get("all_skills") is True, args.get("legacy") is True))
    if modes > 1:
        raise ValueError("choose at most one of skills, all_skills, or legacy")
    validated = dict(args)
    if "skills" in validated:
        validated["skills"] = normalized
    return validated


def _append_adopt_args(cmd: list[str], args: dict) -> None:
    """Append selection flags as argv tokens; never interpolate skill names."""
    staging = args.get("staging")
    if staging:
        cmd += ["--staging", str(staging)]

    skills = args.get("skills") or []
    for skill in skills:
        # argparse treats a following value beginning with '-' as another
        # option. The --flag=value form keeps such a skill name as data. All
        # other names stay separate argv tokens; no shell parses either form.
        if skill.startswith("-"):
            cmd.append(f"--skill={skill}")
        else:
            cmd += ["--skill", skill]
    if args.get("all_skills"):
        cmd.append("--all-skills")
    if args.get("legacy"):
        cmd.append("--legacy")


def _run_engine(action: str, args: object) -> EngineResult:
    args = _validate_tool_arguments(action, args)
    py = sys.executable or "python3"
    cmd = [py, "-m", "skillopt_sleep", action]
    # String-valued flags
    for flag, key in [
        ("--project", "project"), ("--backend", "backend"),
        ("--scope", "scope"), ("--source", "source"),
        ("--model", "model"), ("--tasks-file", "tasks_file"),
        ("--target-skill-path", "target_skill_path"),
    ]:
        val = args.get(key)
        if val:
            cmd += [flag, str(val)]
    # Integer-valued flags
    for flag, key in [
        ("--max-sessions", "max_sessions"), ("--max-tasks", "max_tasks"),
        ("--lookback-hours", "lookback_hours"), ("--edit-budget", "edit_budget"),
        ("--hour", "hour"), ("--minute", "minute"),
    ]:
        val = args.get(key)
        if val is not None:
            cmd += [flag, str(int(val))]
    # Boolean flags
    for flag, key in [
        ("--progress", "progress"), ("--auto-adopt", "auto_adopt"),
        ("--json", "json"),
    ]:
        if args.get(key):
            cmd.append(flag)
    if action == "adopt":
        _append_adopt_args(cmd, args)
    try:
        proc = subprocess.run(cmd, cwd=REPO_ROOT, capture_output=True, text=True, timeout=3600)
    except Exception as e:
        return EngineResult(f"[error] failed to run engine: {e}", 1)
    out = (proc.stdout or "").strip()
    err = (proc.stderr or "").strip()
    if args.get("json"):
        text = out if out or proc.returncode in {0, 3} else err
        return EngineResult(text, proc.returncode, err)
    text = out + (("\n[stderr]\n" + err) if err else "")
    return EngineResult(text, proc.returncode)


def _result(id_, result):
    return {"jsonrpc": "2.0", "id": id_, "result": result}


def _error(id_, code, message):
    return {"jsonrpc": "2.0", "id": id_, "error": {"code": code, "message": message}}


def _validate_request(req: object) -> tuple[str, object, dict]:
    if type(req) is not dict:
        raise ValueError("request must be a JSON object")
    unknown = sorted(set(req) - {"jsonrpc", "id", "method", "params"})
    if unknown:
        raise ValueError(f"unknown request member(s): {', '.join(unknown)}")
    if req.get("jsonrpc") != "2.0":
        raise ValueError("jsonrpc must be '2.0'")
    method = req.get("method")
    if type(method) is not str or not method:
        raise ValueError("method must be a non-empty string")
    params = req.get("params", {})
    if type(params) is not dict:
        raise ValueError("params must be an object")
    request_id = req.get("id")
    if "id" in req and request_id is not None and type(request_id) not in {str, int}:
        raise ValueError("id must be a string, integer, or null")
    return method, request_id, params


def _validate_method_params(method: str, params: dict) -> None:
    allowed_by_method = {
        "initialize": {"protocolVersion", "capabilities", "clientInfo", "_meta"},
        "notifications/initialized": {"_meta"},
        "initialized": {"_meta"},
        "tools/list": {"cursor", "_meta"},
        "tools/call": {"name", "arguments", "_meta"},
        "ping": {"_meta"},
    }
    allowed = allowed_by_method.get(method)
    if allowed is None:
        return
    unknown = sorted(set(params) - allowed)
    if unknown:
        raise ValueError(f"unknown params member(s): {', '.join(unknown)}")
    for key in ("capabilities", "clientInfo", "_meta"):
        if key in params and type(params[key]) is not dict:
            raise ValueError(f"{key} must be an object")
    for key in ("protocolVersion", "cursor"):
        if key in params and type(params[key]) is not str:
            raise ValueError(f"{key} must be a string")


def handle(req: object):
    try:
        method, id_, params = _validate_request(req)
    except ValueError as exc:
        candidate = req.get("id") if type(req) is dict else None
        request_id = candidate if candidate is None or type(candidate) in {str, int} else None
        return _error(request_id, -32600, f"invalid request: {exc}")
    try:
        _validate_method_params(method, params)
    except ValueError as exc:
        return _error(id_, -32602, f"invalid params: {exc}")
    if method == "initialize":
        return _result(id_, {
            "protocolVersion": PROTOCOL_VERSION,
            "capabilities": {"tools": {}},
            "serverInfo": {"name": "skillopt-sleep", "version": "0.1.0"},
        })
    if method in ("notifications/initialized", "initialized"):
        return None  # notification, no response
    if method == "tools/list":
        return _result(id_, {"tools": [
            {"name": t["name"], "description": t["description"], "inputSchema": _TOOL_SCHEMA}
            for t in TOOLS
        ]})
    if method == "tools/call":
        name = params.get("name")
        if type(name) is not str:
            return _error(id_, -32602, "tool name must be a string")
        tool = _BY_NAME.get(name)
        if not tool:
            return _error(id_, -32602, f"unknown tool: {name}")
        arguments = params.get("arguments", {})
        try:
            run = _run_engine(tool["action"], arguments)
        except ValueError as exc:
            return _error(id_, -32602, f"invalid {name} arguments: {exc}")
        status = "handoff_pending" if run.returncode == 3 else (
            "ok" if run.returncode == 0 else "error"
        )
        structured = {"status": status, "exit_code": run.returncode}
        if run.diagnostics:
            structured["diagnostics"] = run.diagnostics
        if type(arguments) is dict and arguments.get("json") is True and run.text:
            try:
                structured["output"] = json.loads(run.text)
            except json.JSONDecodeError:
                pass
        result = {
            "content": [{"type": "text", "text": run.text}],
            "structuredContent": structured,
            "isError": run.returncode not in {0, 3},
        }
        return _result(id_, result)
    if method == "ping":
        return _result(id_, {})
    return _error(id_, -32601, f"method not found: {method}")


def main() -> int:
    for line in sys.stdin:
        line = line.strip()
        if not line:
            continue
        try:
            req = json.loads(line)
        except json.JSONDecodeError:
            resp = _error(None, -32700, "parse error")
        else:
            resp = handle(req)
        if resp is not None:
            sys.stdout.write(json.dumps(resp) + "\n")
            sys.stdout.flush()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
