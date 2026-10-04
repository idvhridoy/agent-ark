"""Opt-in smoke test for harvesting a real OpenCode transcript database.

This test only reads the local SQLite database. It does not launch the
OpenCode CLI, call a model, or use the network. It is skipped unless
``SKILLOPT_TEST_REAL_OPENCODE_SOURCE=1`` is set. Set
``SKILLOPT_TEST_OPENCODE_DB`` to test a specific database; otherwise the
harvester uses OpenCode's normal ``OPENCODE_DB``/XDG path resolution.
"""

from __future__ import annotations

import os

import pytest

from skillopt_sleep.harvest_opencode import (
    default_opencode_db,
    harvest_opencode,
)
from skillopt_sleep.types import SessionDigest

_LIVE_ENABLED = os.environ.get("SKILLOPT_TEST_REAL_OPENCODE_SOURCE", "").strip() == "1"

pytestmark = pytest.mark.skipif(
    not _LIVE_ENABLED,
    reason=("set SKILLOPT_TEST_REAL_OPENCODE_SOURCE=1 to read a real OpenCode transcript database"),
)


def _live_database_path() -> str:
    configured = os.environ.get("SKILLOPT_TEST_OPENCODE_DB", "").strip()
    path = os.path.abspath(os.path.expanduser(configured)) if configured else default_opencode_db()
    if not path or not os.path.isfile(path):
        pytest.fail(
            "no OpenCode database was found for the opted-in source test; "
            "set SKILLOPT_TEST_OPENCODE_DB to an existing database",
            pytrace=False,
        )
    return path


def _invalid_digest_field(digest: SessionDigest) -> str:
    checks = (
        ("session_id", isinstance(digest.session_id, str) and bool(digest.session_id)),
        ("project", isinstance(digest.project, str) and os.path.isabs(digest.project)),
        ("started_at", isinstance(digest.started_at, str) and bool(digest.started_at)),
        ("ended_at", isinstance(digest.ended_at, str) and bool(digest.ended_at)),
        ("user_prompts", isinstance(digest.user_prompts, list) and bool(digest.user_prompts)),
        ("n_user_turns", type(digest.n_user_turns) is int and digest.n_user_turns >= 1),
        (
            "n_assistant_turns",
            type(digest.n_assistant_turns) is int and digest.n_assistant_turns >= 0,
        ),
        (
            "raw_path",
            isinstance(digest.raw_path, str) and digest.raw_path == f"opencode://{digest.session_id}",
        ),
    )
    return next((field for field, valid in checks if not valid), "")


def test_real_opencode_harvest_smoke() -> None:
    """Read real sessions without exposing transcript content in test output."""
    path = _live_database_path()
    digests = harvest_opencode(path, scope="all", limit=20)
    if not digests:
        pytest.fail(
            "the real OpenCode database contained no harvestable root session",
            pytrace=False,
        )

    invalid_field = next(
        (field for digest in digests if (field := _invalid_digest_field(digest))),
        "",
    )
    if invalid_field:
        pytest.fail(
            f"the real OpenCode database produced an invalid {invalid_field} field",
            pytrace=False,
        )
