"""Isolation regressions for SkillOpt-Sleep's in-process default state."""

from skillopt_sleep.state import SleepState


def test_fresh_states_do_not_share_nested_default_containers(tmp_path):
    first = SleepState.load(str(tmp_path / "first.json"))
    second = SleepState.load(str(tmp_path / "second.json"))

    first.set_last_harvest("/project/one", "2026-08-15T00:00:00")
    first.record_night({"night": 1})
    first.add_to_archive([{"id": "private-to-first"}])

    assert second.last_harvest_for("/project/one") is None
    assert second.data["history"] == []
    assert second.task_archive() == []
