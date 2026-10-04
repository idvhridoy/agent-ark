"""Regression-sensitive validation gate coverage for issue #174."""

from __future__ import annotations

import importlib
import json
import os

from skillopt_sleep.__main__ import _report_payload
from skillopt_sleep.backend import Backend, MockBackend
from skillopt_sleep.config import DEFAULTS, load_config
from skillopt_sleep.cycle import _render_report_md, run_sleep_cycle
from skillopt_sleep.evidence import EvidenceLog
from skillopt_sleep.experiments.personas import researcher_persona
from skillopt_sleep.memory import set_learned
from skillopt_sleep.mine import assign_splits
from skillopt_sleep.staging import write_staging
from skillopt_sleep.types import EditRecord, ReplayResult, SleepReport, TaskRecord

EDIT = EditRecord(
    target="skill",
    op="add",
    content="A candidate rule.",
    rationale="improve the validation slice",
)


class EditingBackend(Backend):
    name = "editing-stub"

    def reflect(self, *args, **kwargs):
        return [EDIT]


def _tasks() -> list[TaskRecord]:
    return [
        TaskRecord(id="train", project="test", intent="train", split="train"),
        TaskRecord(
            id="improved",
            project="test",
            intent="improve",
            split="val",
            tags=["essay"],
        ),
        TaskRecord(
            id="regressed",
            project="test",
            intent="do not regress",
            split="val",
            tags=["router", "held-out"],
        ),
    ]


def _patch_scores(monkeypatch, batches: list[list[float | None]]) -> None:
    consolidate_module = importlib.import_module("skillopt_sleep.consolidate")
    scores = iter(batches)

    def fake_replay_batch(backend, tasks, skill, memory):
        batch = next(scores)
        assert len(batch) == len(tasks)
        return [
            (
                task,
                ReplayResult(
                    id=task.id,
                    hard=score,
                    soft=score,
                    response="candidate",
                ),
            )
            for task, score in zip(tasks, batch)
        ]

    monkeypatch.setattr(consolidate_module, "replay_batch", fake_replay_batch)


def _patch_score_maps(monkeypatch, batches: list[dict[str, float]]) -> None:
    consolidate_module = importlib.import_module("skillopt_sleep.consolidate")
    scores = iter(batches)

    def fake_replay_batch(backend, tasks, skill, memory):
        batch = next(scores)
        return [
            (
                task,
                ReplayResult(
                    id=task.id,
                    hard=batch[task.id],
                    soft=batch[task.id],
                    response="candidate",
                ),
            )
            for task in tasks
            if task.id in batch
        ]

    monkeypatch.setattr(consolidate_module, "replay_batch", fake_replay_batch)


def _consolidate(**kwargs):
    consolidate_module = importlib.import_module("skillopt_sleep.consolidate")
    return consolidate_module.consolidate(
        EditingBackend(),
        _tasks(),
        set_learned("# Skill\n", []),
        "",
        gate_metric="hard",
        evolve_memory=False,
        **kwargs,
    )


def test_default_keeps_aggregate_only_gate_behavior(monkeypatch) -> None:
    # Baseline mean 0.4 -> candidate mean 0.85, while one task falls 0.8 -> 0.7.
    batches = [[0.0, 0.8], [0.0], [1.0, 0.7], [1.0, 0.7]]
    _patch_scores(monkeypatch, batches)

    default_result = _consolidate()

    _patch_scores(monkeypatch, batches)
    explicit_result = _consolidate(gate_no_regression=False)

    assert default_result.accepted is True
    assert explicit_result.accepted is True
    for field in (
        "gate_action",
        "baseline_score",
        "candidate_score",
        "new_skill",
        "new_memory",
        "applied_edits",
        "rejected_edits",
        "holdout_baseline",
        "holdout_candidate",
    ):
        assert getattr(default_result, field) == getattr(explicit_result, field)


def test_opt_in_gate_accepts_when_no_task_regresses(monkeypatch) -> None:
    _patch_scores(
        monkeypatch,
        [[0.0, 0.8], [0.0], [1.0, 0.8], [1.0, 0.8]],
    )

    result = _consolidate(gate_no_regression=True)

    assert result.accepted is True
    assert result.gate_action == "accept_new_best"
    assert result.gate_trials[0]["accepted"] is True
    assert result.gate_trials[0]["blocked_by_regression"] is False
    assert [row["status"] for row in result.gate_trials[0]["task_deltas"]] == [
        "improved",
        "unchanged",
    ]


def test_opt_in_gate_rejects_regression_during_skill_trial(monkeypatch) -> None:
    # The rejected trial is followed by a final replay of the unchanged skill.
    _patch_scores(
        monkeypatch,
        [[0.0, 0.8], [0.0], [1.0, 0.7], [0.0, 0.8]],
    )

    result = _consolidate(gate_no_regression=True)

    assert result.accepted is False
    assert result.applied_edits == []
    assert result.rejected_edits == [EDIT]
    skill_trial = result.gate_trials[0]
    assert skill_trial["target"] == "skill"
    assert skill_trial["blocked_by_regression"] is True
    assert skill_trial["accepted"] is False
    assert skill_trial["task_deltas"] == [
        {
            "task_id": "improved",
            "tags": ["essay"],
            "baseline_score": 0.0,
            "candidate_score": 1.0,
            "status": "improved",
            "scores_are_finite": True,
        },
        {
            "task_id": "regressed",
            "tags": ["router", "held-out"],
            "baseline_score": 0.8,
            "candidate_score": 0.7,
            "status": "regressed",
            "scores_are_finite": True,
        },
    ]


def test_opt_in_gate_rechecks_regressions_on_final_replay(monkeypatch) -> None:
    # The skill trial has no regression, but the fresh final replay does.
    _patch_scores(
        monkeypatch,
        [[0.0, 0.8], [0.0], [1.0, 0.8], [1.0, 0.7]],
    )

    result = _consolidate(gate_no_regression=True)

    assert result.accepted is False
    assert result.applied_edits == []
    assert result.rejected_edits == [EDIT]
    final_trial = result.gate_trials[-1]
    assert final_trial["target"] == "final"
    assert final_trial["blocked_by_regression"] is True
    assert final_trial["accepted"] is False
    assert [row["status"] for row in final_trial["task_deltas"]] == [
        "improved",
        "regressed",
    ]


def test_opt_in_gate_rejects_missing_task_during_trial(monkeypatch) -> None:
    _patch_score_maps(
        monkeypatch,
        [
            {"improved": 0.0, "regressed": 0.8},
            {"train": 0.0},
            {"improved": 1.0},
            {"improved": 0.0, "regressed": 0.8},
        ],
    )

    result = _consolidate(gate_no_regression=True)

    assert result.accepted is False
    missing = result.gate_trials[0]["task_deltas"][1]
    assert missing["task_id"] == "regressed"
    assert missing["candidate_score"] is None
    assert missing["scores_are_finite"] is False
    assert missing["status"] == "regressed"


def test_opt_in_gate_rejects_missing_baseline_task(monkeypatch) -> None:
    _patch_score_maps(
        monkeypatch,
        [
            {"improved": 0.0},
            {"train": 0.0},
            {"improved": 1.0, "regressed": 0.8},
            {"improved": 0.0, "regressed": 0.8},
        ],
    )

    result = _consolidate(gate_no_regression=True)

    assert result.accepted is False
    missing = result.gate_trials[0]["task_deltas"][1]
    assert missing["task_id"] == "regressed"
    assert missing["baseline_score"] is None
    assert missing["candidate_score"] == 0.8
    assert missing["status"] == "regressed"


def test_opt_in_gate_rejects_missing_task_during_final_replay(monkeypatch) -> None:
    _patch_score_maps(
        monkeypatch,
        [
            {"improved": 0.0, "regressed": 0.8},
            {"train": 0.0},
            {"improved": 1.0, "regressed": 0.8},
            {"improved": 1.0},
        ],
    )

    result = _consolidate(gate_no_regression=True)

    assert result.accepted is False
    final_trial = result.gate_trials[-1]
    assert final_trial["blocked_by_regression"] is True
    assert final_trial["task_deltas"][1]["candidate_score"] is None


def test_opt_in_gate_rejects_regression_during_memory_trial(monkeypatch) -> None:
    _patch_scores(
        monkeypatch,
        [[0.0, 0.8], [0.0], [0.0], [1.0, 0.7], [0.0, 0.8]],
    )
    consolidate_module = importlib.import_module("skillopt_sleep.consolidate")

    result = consolidate_module.consolidate(
        EditingBackend(),
        _tasks(),
        "",
        set_learned("# Memory\n", []),
        gate_metric="hard",
        gate_no_regression=True,
        evolve_skill=False,
        evolve_memory=True,
    )

    assert result.accepted is False
    assert result.gate_trials[0]["target"] == "memory"
    assert result.gate_trials[0]["blocked_by_regression"] is True


def test_opt_in_gate_rejects_non_finite_task_score(monkeypatch) -> None:
    _patch_scores(
        monkeypatch,
        [[0.0, 0.8], [0.0], [float("inf"), 0.8], [0.0, 0.8]],
    )

    result = _consolidate(gate_no_regression=True)

    assert result.accepted is False
    trial = result.gate_trials[0]
    assert trial["blocked_by_regression"] is True
    invalid = trial["task_deltas"][0]
    assert invalid["candidate_score"] is None
    assert invalid["scores_are_finite"] is False
    assert invalid["status"] == "regressed"
    json.dumps(result.gate_trials, allow_nan=False)


def test_opt_in_gate_rejects_nan_task_score(monkeypatch) -> None:
    _patch_scores(
        monkeypatch,
        [[0.0, 0.8], [0.0], [float("nan"), 0.8], [0.0, 0.8]],
    )

    result = _consolidate(gate_no_regression=True)

    assert result.accepted is False
    trial = result.gate_trials[0]
    assert trial["blocked_by_regression"] is True
    invalid = trial["task_deltas"][0]
    assert invalid["candidate_score"] is None
    assert invalid["scores_are_finite"] is False
    assert invalid["status"] == "regressed"
    json.dumps(result.gate_trials, allow_nan=False)


def test_opt_in_gate_rejects_nan_on_final_replay(monkeypatch) -> None:
    _patch_scores(
        monkeypatch,
        [[0.0, 0.8], [0.0], [1.0, 0.8], [float("nan"), 0.8]],
    )

    result = _consolidate(gate_no_regression=True)

    assert result.accepted is False
    final_trial = result.gate_trials[-1]
    assert final_trial["target"] == "final"
    assert final_trial["blocked_by_regression"] is True
    assert final_trial["candidate_score"] is None
    assert final_trial["task_deltas"][0]["candidate_score"] is None
    json.dumps(result.gate_trials, allow_nan=False)


def test_missing_numeric_score_still_aborts_candidate_evaluation(monkeypatch) -> None:
    batches_by_phase = (
        [[0.0, 0.8], [0.0], [None, 0.8]],
        [[0.0, 0.8], [0.0], [1.0, 0.8], [None, 0.8]],
    )

    for batches in batches_by_phase:
        _patch_scores(monkeypatch, batches)
        try:
            _consolidate(gate_no_regression=True)
        except (TypeError, ValueError):
            continue
        raise AssertionError("a validation task without a numeric score was accepted")


def test_replay_exception_still_propagates(monkeypatch) -> None:
    consolidate_module = importlib.import_module("skillopt_sleep.consolidate")

    def failed_replay(*args, **kwargs):
        raise RuntimeError("validation replay failed")

    monkeypatch.setattr(consolidate_module, "replay_batch", failed_replay)

    try:
        _consolidate(gate_no_regression=True)
    except RuntimeError as exc:
        assert str(exc) == "validation replay failed"
    else:
        raise AssertionError("validation replay failure was swallowed")


def test_no_regression_setting_defaults_off() -> None:
    assert DEFAULTS["gate_no_regression"] is False


def test_report_surfaces_task_level_gate_changes() -> None:
    report = SleepReport(
        night=1,
        project="/tmp/project",
        gate_action="reject",
        gate_no_regression=True,
        gate_trials=[
            {
                "target": "skill",
                "baseline_score": 0.4,
                "candidate_score": 0.85,
                "accepted": False,
                "blocked_by_regression": True,
                "task_deltas": [
                    {
                        "task_id": "essay|one",
                        "tags": ["writing"],
                        "baseline_score": 0.0,
                        "candidate_score": 1.0,
                        "status": "improved",
                    },
                    {
                        "task_id": "router-two",
                        "tags": ["routing", "held-out"],
                        "baseline_score": 0.8,
                        "candidate_score": 0.7,
                        "status": "regressed",
                    },
                    {
                        "task_id": "missing",
                        "tags": [],
                        "baseline_score": 0.6,
                        "candidate_score": None,
                        "status": "regressed",
                    },
                ],
            }
        ],
    )

    markdown = _render_report_md(
        report,
        load_config(gate_no_regression=True),
    )

    assert "no-regression gate: enabled" in markdown
    assert "Held-out task changes" in markdown
    assert "essay&#124;one" in markdown
    assert "routing, held-out" in markdown
    assert "0.800" in markdown
    assert "0.700" in markdown
    assert "regressed" in markdown
    assert "| `missing` | — | 0.600 | — | regressed |" in markdown


def test_cli_json_payload_surfaces_redacted_task_deltas() -> None:
    synthetic_secret = "api_key=synthetic-example-123456"
    report = SleepReport(
        night=1,
        project="/tmp/project",
        gate_action="reject",
        gate_no_regression=True,
        gate_trials=[
            {
                "target": "skill",
                "baseline_score": 0.4,
                "candidate_score": 0.85,
                "accepted": False,
                "blocked_by_regression": True,
                "task_deltas": [
                    {
                        "task_id": synthetic_secret,
                        "tags": [synthetic_secret],
                        "baseline_score": 0.8,
                        "candidate_score": 0.7,
                        "status": "regressed",
                    }
                ],
            }
        ],
    )
    outcome = type("Outcome", (), {"staging_dir": "", "adopted": False})()

    payload = _report_payload(report, outcome)

    serialized = json.dumps(payload)
    assert payload["gate_no_regression"] is True
    assert payload["gate_trials"][0]["task_deltas"][0]["status"] == "regressed"
    assert synthetic_secret not in serialized
    assert "REDACTED" in serialized


def test_machine_outputs_use_standard_json_for_non_finite_scores(tmp_path) -> None:
    report = SleepReport(
        night=1,
        project=str(tmp_path),
        baseline_score=float("nan"),
        candidate_score=float("inf"),
        gate_no_regression=True,
        gate_trials=[
            {
                "target": "final",
                "baseline_score": None,
                "candidate_score": None,
                "accepted": False,
                "blocked_by_regression": True,
                "task_deltas": [],
            }
        ],
    )
    outcome = type("Outcome", (), {"staging_dir": "", "adopted": False})()

    cli_payload = _report_payload(report, outcome)
    json.dumps(cli_payload, allow_nan=False)
    assert cli_payload["baseline"] is None
    assert cli_payload["candidate"] is None

    staging_dir = write_staging(
        str(tmp_path),
        report=report,
        proposed_skill=None,
        proposed_memory=None,
        live_skill_path="",
        live_memory_path="",
        report_md="report",
    )
    with open(os.path.join(staging_dir, "report.json"), encoding="utf-8") as handle:
        staged_payload = json.load(handle)
    assert staged_payload["baseline_score"] is None
    assert staged_payload["candidate_score"] is None

    evidence_path = tmp_path / "evidence.jsonl"
    EvidenceLog(str(evidence_path)).log("gate", "decision", score=float("nan"))
    with open(evidence_path, encoding="utf-8") as handle:
        evidence_record = json.loads(handle.read())
    assert evidence_record["score"] is None


def test_cycle_persists_gate_trials_in_diagnostics(tmp_path) -> None:
    project = tmp_path / "project"
    project.mkdir()
    config = load_config(
        invoked_project=str(project),
        projects="invoked",
        backend="mock",
        state_dir=str(tmp_path / "state"),
        claude_home=str(tmp_path / ".claude"),
        gate_no_regression=True,
        auto_adopt=False,
    )
    tasks = assign_splits(researcher_persona(), holdout_fraction=0.34, seed=42)

    outcome = run_sleep_cycle(
        config,
        seed_tasks=tasks,
        backend=MockBackend(),
    )

    with open(
        os.path.join(outcome.staging_dir, "diagnostics.json"),
        encoding="utf-8",
    ) as handle:
        diagnostics = json.load(handle)
    assert diagnostics["gate_no_regression"] is True
    assert diagnostics["gate_trials"]
    assert diagnostics["gate_trials"] == outcome.report.gate_trials


def test_task_delta_artifacts_redact_secret_shaped_metadata(tmp_path) -> None:
    project = tmp_path / "project"
    project.mkdir()
    config = load_config(
        invoked_project=str(project),
        projects="invoked",
        backend="mock",
        state_dir=str(tmp_path / "state"),
        claude_home=str(tmp_path / ".claude"),
        gate_no_regression=True,
        auto_adopt=False,
    )
    tasks = assign_splits(researcher_persona(), holdout_fraction=0.34, seed=42)
    synthetic_secret = "api_key=synthetic-example-123456"
    validation_task = next(task for task in tasks if task.split == "val")
    validation_task.id = synthetic_secret
    validation_task.tags.append(synthetic_secret)

    outcome = run_sleep_cycle(
        config,
        seed_tasks=tasks,
        backend=MockBackend(),
    )

    for filename in (
        "report.md",
        "report.json",
        "diagnostics.json",
        "evidence.jsonl",
    ):
        with open(os.path.join(outcome.staging_dir, filename), encoding="utf-8") as handle:
            persisted = handle.read()
        assert synthetic_secret not in persisted
        assert "REDACTED" in persisted
