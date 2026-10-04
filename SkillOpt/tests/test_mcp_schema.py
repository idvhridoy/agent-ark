"""Tests for the Copilot MCP server schema completeness."""
import contextlib
import importlib.util
import io
import json
import os
import subprocess
import sys
import unittest
from unittest import mock

PLUGIN = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "..", "plugins", "copilot")
)
MODULE_PATH = os.path.join(PLUGIN, "mcp_server.py")
SPEC = importlib.util.spec_from_file_location("copilot_mcp_server_test", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
mcp_server = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(mcp_server)


def _call(name="sleep_status", arguments=None, **params):
    call_params = {"name": name, "arguments": {} if arguments is None else arguments}
    call_params.update(params)
    return {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "tools/call",
        "params": call_params,
    }


class TestMcpSchema(unittest.TestCase):
    def test_schema_includes_all_engine_flags(self):
        required_params = {
            "project", "backend", "scope", "source", "model",
            "tasks_file", "target_skill_path", "staging", "skills",
            "all_skills", "legacy", "progress",
            "max_sessions", "max_tasks", "lookback_hours",
            "auto_adopt", "json", "edit_budget",
        }
        schema_props = set(mcp_server._TOOL_SCHEMA["properties"].keys())
        missing = required_params - schema_props
        self.assertEqual(missing, set(), f"MCP schema missing: {missing}")

    def test_adopt_selection_schema_types(self):
        props = mcp_server._TOOL_SCHEMA["properties"]
        self.assertEqual(props["staging"]["type"], "string")
        self.assertEqual(props["skills"]["type"], "array")
        self.assertEqual(props["skills"]["items"]["type"], "string")
        self.assertEqual(props["all_skills"]["type"], "boolean")
        self.assertEqual(props["legacy"]["type"], "boolean")

    def test_all_backends_in_enum(self):
        backends = mcp_server._TOOL_SCHEMA["properties"]["backend"]["enum"]
        for b in ["mock", "claude", "codex", "copilot", "handoff"]:
            self.assertIn(b, backends)

    def test_schedule_tools_exist(self):
        names = {t["name"] for t in mcp_server.TOOLS}
        self.assertIn("sleep_schedule", names)
        self.assertIn("sleep_unschedule", names)

    def test_adopt_forwards_staging_and_repeated_skills_as_argv(self):
        completed = subprocess.CompletedProcess(
            args=[], returncode=0, stdout="adopted\n", stderr=""
        )
        arguments = {
            "staging": "/tmp/night with spaces",
            "skills": ["alpha", "--leading-dash", "space ; $(literal)"],
        }
        with mock.patch.object(
            mcp_server.subprocess, "run", return_value=completed
        ) as run:
            result = mcp_server._run_engine("adopt", arguments)

        self.assertEqual(result.text, "adopted")
        self.assertEqual(result.returncode, 0)
        run.assert_called_once()
        command = run.call_args.args[0]
        self.assertEqual(
            command[-7:],
            [
                "--staging", "/tmp/night with spaces",
                "--skill", "alpha",
                "--skill=--leading-dash",
                "--skill", "space ; $(literal)",
            ],
        )
        self.assertNotIn("shell", run.call_args.kwargs)

    def test_adopt_forwards_boolean_selection_flags(self):
        completed = subprocess.CompletedProcess(
            args=[], returncode=0, stdout="", stderr=""
        )
        for argument, flag in (("all_skills", "--all-skills"), ("legacy", "--legacy")):
            with self.subTest(argument=argument), mock.patch.object(
                mcp_server.subprocess, "run", return_value=completed
            ) as run:
                mcp_server._run_engine("adopt", {argument: True})
                self.assertEqual(run.call_args.args[0][-1], flag)

    def test_adopt_rejects_non_array_skills_without_spawning(self):
        with mock.patch.object(mcp_server.subprocess, "run") as run:
            with self.assertRaisesRegex(ValueError, "skills must be an array"):
                mcp_server._run_engine("adopt", {"skills": "alpha"})

        run.assert_not_called()


class TestMcpRuntimeValidation(unittest.TestCase):
    def test_malformed_request_envelopes_return_json_rpc_errors(self):
        cases = (
            ([], "request must be a JSON object"),
            ({"method": "ping", "id": 1}, "jsonrpc must be '2.0'"),
            ({"jsonrpc": "2.0", "id": 1, "method": "", "params": {}},
             "method must be a non-empty string"),
            ({"jsonrpc": "2.0", "id": 1, "method": "ping", "params": []},
             "params must be an object"),
            ({"jsonrpc": "2.0", "id": False, "method": "ping"},
             "id must be a string"),
            ({"jsonrpc": "2.0", "id": 1, "method": "ping", "extra": 1},
             "unknown request member"),
        )
        for request, message in cases:
            with self.subTest(request=request):
                response = mcp_server.handle(request)
                self.assertEqual(response["error"]["code"], -32600)
                self.assertIn(message, response["error"]["message"])
                if type(request) is dict and type(request.get("id")) not in {str, int}:
                    self.assertIsNone(response["id"])

    def test_known_method_params_reject_unknown_or_wrong_typed_properties(self):
        cases = (
            (_call(extra="value"), "unknown params member"),
            ({"jsonrpc": "2.0", "id": 1, "method": "tools/list",
              "params": {"cursor": 4}}, "cursor must be a string"),
            ({"jsonrpc": "2.0", "id": 1, "method": "ping",
              "params": {"_meta": "bad"}}, "_meta must be an object"),
        )
        for request, message in cases:
            with self.subTest(request=request):
                response = mcp_server.handle(request)
                self.assertEqual(response["error"]["code"], -32602)
                self.assertIn(message, response["error"]["message"])

    def test_invalid_tool_arguments_never_spawn(self):
        cases = (
            ([], "arguments must be an object"),
            ({"bogus": 1}, "unknown argument"),
            ({"json": "false"}, "json must be a boolean"),
            ({"auto_adopt": "false"}, "auto_adopt must be a boolean"),
            ({"max_tasks": True}, "max_tasks must be an integer"),
            ({"max_tasks": -1}, "max_tasks must be between"),
            ({"backend": "other"}, "unsupported backend"),
            ({"skills": ["alpha"]}, "valid only for sleep_adopt"),
            ({"hour": 24}, "hour must be between"),
            ({"minute": -1}, "minute must be between"),
        )
        for arguments, message in cases:
            request = _call(arguments=arguments)
            if "hour" in arguments or "minute" in arguments:
                request = _call("sleep_schedule", arguments)
            with self.subTest(arguments=arguments), mock.patch.object(
                mcp_server.subprocess, "run"
            ) as run:
                response = mcp_server.handle(request)
                self.assertEqual(response["error"]["code"], -32602)
                self.assertIn(message, response["error"]["message"])
                run.assert_not_called()

    def test_adoption_modes_and_skill_array_are_strict(self):
        cases = (
            ({"all_skills": "false"}, "all_skills must be a boolean"),
            ({"legacy": "false"}, "legacy must be a boolean"),
            ({"skills": [1]}, "skills entry must be a string"),
            ({"skills": ["  "]}, "skills entry must be non-empty"),
            ({"skills": ["alpha", " alpha "]}, "skills entries must be unique"),
            ({"skills": ["alpha"], "all_skills": True}, "choose at most one"),
            ({"all_skills": True, "legacy": True}, "choose at most one"),
        )
        for arguments, message in cases:
            with self.subTest(arguments=arguments), mock.patch.object(
                mcp_server.subprocess, "run"
            ) as run:
                response = mcp_server.handle(_call("sleep_adopt", arguments))
                self.assertEqual(response["error"]["code"], -32602)
                self.assertIn(message, response["error"]["message"])
                run.assert_not_called()

    def test_every_string_boolean_and_integer_contract_is_exact_and_bounded(self):
        for key in mcp_server._STRING_ARGS:
            action = "adopt" if key == "staging" else "status"
            with self.subTest(kind="string", key=key), self.assertRaisesRegex(
                ValueError, f"{key} must be a string"
            ):
                mcp_server._validate_tool_arguments(action, {key: 1})
        for key in mcp_server._BOOLEAN_ARGS:
            action = "adopt" if key in {"all_skills", "legacy"} else "status"
            with self.subTest(kind="boolean", key=key), self.assertRaisesRegex(
                ValueError, f"{key} must be a boolean"
            ):
                mcp_server._validate_tool_arguments(action, {key: "false"})
        for key, (minimum, maximum) in mcp_server._INTEGER_BOUNDS.items():
            action = "schedule" if key in {"hour", "minute"} else "status"
            with self.subTest(kind="integer-bool", key=key), self.assertRaisesRegex(
                ValueError, f"{key} must be an integer"
            ):
                mcp_server._validate_tool_arguments(action, {key: False})
            for value in (minimum - 1, maximum + 1):
                with self.subTest(kind="integer-bound", key=key, value=value), \
                        self.assertRaisesRegex(ValueError, f"{key} must be between"):
                    mcp_server._validate_tool_arguments(action, {key: value})
            self.assertEqual(
                mcp_server._validate_tool_arguments(action, {key: minimum})[key],
                minimum,
            )
            self.assertEqual(
                mcp_server._validate_tool_arguments(action, {key: maximum})[key],
                maximum,
            )

    def test_engine_status_maps_to_mcp_error_and_handoff_states(self):
        cases = (
            (0, False, "ok"),
            (2, True, "error"),
            (3, False, "handoff_pending"),
        )
        for returncode, is_error, status in cases:
            with self.subTest(returncode=returncode), mock.patch.object(
                mcp_server, "_run_engine",
                return_value=mcp_server.EngineResult("engine output", returncode),
            ):
                response = mcp_server.handle(_call())
                result = response["result"]
                self.assertIs(result["isError"], is_error)
                self.assertEqual(result["structuredContent"]["status"], status)
                self.assertEqual(result["structuredContent"]["exit_code"], returncode)

    def test_subprocess_exit_status_reaches_mcp_result(self):
        completed = subprocess.CompletedProcess(
            args=[], returncode=9, stdout="failed", stderr="details"
        )
        with mock.patch.object(mcp_server.subprocess, "run", return_value=completed):
            result = mcp_server.handle(_call())["result"]
        self.assertTrue(result["isError"])
        self.assertEqual(result["structuredContent"]["exit_code"], 9)

    def test_json_failure_keeps_stderr_visible_when_stdout_is_empty(self):
        completed = subprocess.CompletedProcess(
            args=[], returncode=4, stdout="", stderr="actionable failure\n"
        )
        with mock.patch.object(mcp_server.subprocess, "run", return_value=completed):
            result = mcp_server.handle(_call(arguments={"json": True}))["result"]
        self.assertTrue(result["isError"])
        self.assertEqual(result["content"][0]["text"], "actionable failure")

    def test_json_output_is_parseable_and_stderr_is_diagnostic_only(self):
        completed = subprocess.CompletedProcess(
            args=[], returncode=0, stdout='{"ok": true}\n', stderr="provider warning\n"
        )
        with mock.patch.object(mcp_server.subprocess, "run", return_value=completed):
            run = mcp_server._run_engine("status", {"json": True})

        self.assertEqual(json.loads(run.text), {"ok": True})
        self.assertEqual(run.diagnostics, "provider warning")
        self.assertNotIn("stderr", run.text)

    def test_json_tool_result_includes_parsed_structured_output(self):
        completed = subprocess.CompletedProcess(
            args=[], returncode=0, stdout='{"nights": 2}\n', stderr=""
        )
        with mock.patch.object(mcp_server.subprocess, "run", return_value=completed):
            result = mcp_server.handle(_call(arguments={"json": True}))["result"]
        self.assertEqual(result["structuredContent"]["output"], {"nights": 2})
        self.assertEqual(json.loads(result["content"][0]["text"]), {"nights": 2})

    def test_main_emits_parse_error_for_malformed_json(self):
        output = io.StringIO()
        with mock.patch.object(sys, "stdin", io.StringIO("{bad json\n")), \
                contextlib.redirect_stdout(output):
            self.assertEqual(mcp_server.main(), 0)
        response = json.loads(output.getvalue())
        self.assertEqual(response["error"]["code"], -32700)
        self.assertIsNone(response["id"])


if __name__ == "__main__":
    unittest.main()
