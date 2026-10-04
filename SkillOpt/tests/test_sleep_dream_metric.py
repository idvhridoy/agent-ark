"""Gate-aligned scoring for SkillOpt-Sleep contrastive dream rollouts."""
from __future__ import annotations

from unittest import mock

from skillopt_sleep.backend import Backend, MockBackend
from skillopt_sleep.consolidate import consolidate
from skillopt_sleep.rollout import RolloutSet, contrastive_reflect
from skillopt_sleep.types import ReplayResult, TaskRecord


class RecordingBackend(Backend):
    name = "recording"

    def __init__(self) -> None:
        super().__init__()
        self.prompts = []

    def _call(self, prompt: str, *, max_tokens: int = 1024) -> str:
        self.prompts.append(prompt)
        return '[{"op":"add","content":"prefer the stronger attempt"}]'


def _soft_spread() -> RolloutSet:
    task = TaskRecord(id="t1", project="/p", intent="produce the best answer")
    return RolloutSet(
        task=task,
        attempts=[
            ReplayResult(id="t1", hard=1.0, soft=0.2, response="weak partial answer"),
            ReplayResult(id="t1", hard=1.0, soft=0.9, response="strong complete answer"),
        ],
    )


def test_hard_metric_preserves_no_contrast_for_equal_hard_scores():
    backend = RecordingBackend()

    edits = contrastive_reflect(backend, [_soft_spread()], "skill", "")

    assert edits == []
    assert backend.prompts == []


def test_soft_metric_learns_from_partial_credit_spread():
    backend = RecordingBackend()

    edits = contrastive_reflect(
        backend,
        [_soft_spread()],
        "skill",
        "",
        gate_metric="soft",
    )

    assert len(edits) == 1
    assert "strong complete answer" in backend.prompts[0]
    assert "weak partial answer" in backend.prompts[0]
    assert "soft score 0.900" in backend.prompts[0]
    assert "soft score 0.200" in backend.prompts[0]


def test_mixed_metric_uses_the_configured_weight():
    backend = RecordingBackend()

    edits = contrastive_reflect(
        backend,
        [_soft_spread()],
        "skill",
        "",
        gate_metric="mixed",
        gate_mixed_weight=0.25,
    )

    assert len(edits) == 1
    assert "mixed score 0.975" in backend.prompts[0]
    assert "mixed score 0.800" in backend.prompts[0]


def test_consolidate_passes_gate_objective_to_dream_reflection():
    tasks = [
        TaskRecord(id="train", project="/p", intent="train", split="train"),
        TaskRecord(id="val", project="/p", intent="validate", split="val"),
    ]
    rollout = RolloutSet(
        task=tasks[0],
        attempts=[ReplayResult(id="train", hard=0.0, soft=0.1)],
    )

    with mock.patch("skillopt_sleep.rollout.multi_rollout", return_value=rollout), mock.patch(
        "skillopt_sleep.rollout.contrastive_reflect", return_value=[]
    ) as reflect:
        consolidate(
            MockBackend(),
            tasks,
            "# skill\n",
            "",
            rollouts_k=2,
            gate_metric="soft",
            gate_mixed_weight=0.7,
            evolve_memory=False,
        )

    assert reflect.call_args.kwargs["gate_metric"] == "soft"
    assert reflect.call_args.kwargs["gate_mixed_weight"] == 0.7
