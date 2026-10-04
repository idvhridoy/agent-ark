"""Regression tests for trainer failure-pattern extraction."""

from skillopt.engine.trainer import _extract_failure_patterns


def test_failure_patterns_ignore_excessively_nested_analyst_patch(tmp_path) -> None:
    """A malformed cached patch must not abort failure-pattern fallback."""
    patches_dir = tmp_path / "patches"
    patches_dir.mkdir()
    nested = "[" * 2000 + "0" + "]" * 2000
    (patches_dir / "minibatch_fail_0.json").write_text(nested, encoding="utf-8")

    result = _extract_failure_patterns(
        [{"id": "task-1", "hard": 0, "fail_reason": "timeout: command stalled"}],
        str(tmp_path),
    )

    assert result == [
        {"pattern": "timeout", "count": 1, "task_ids": ["task-1"]},
    ]


def test_failure_patterns_ignore_oversized_integer_in_analyst_patch(tmp_path) -> None:
    """Python's integer limit is another malformed-JSON boundary condition."""
    patches_dir = tmp_path / "patches"
    patches_dir.mkdir()
    malformed = '{"failure_summary":' + "9" * 5000 + "}"
    (patches_dir / "minibatch_fail_0.json").write_text(malformed, encoding="utf-8")

    result = _extract_failure_patterns(
        [{"id": "task-2", "hard": 0, "fail_reason": "crash: invalid output"}],
        str(tmp_path),
    )

    assert result == [
        {"pattern": "crash", "count": 1, "task_ids": ["task-2"]},
    ]
