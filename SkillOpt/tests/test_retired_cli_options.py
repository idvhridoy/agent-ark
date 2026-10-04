from __future__ import annotations

import sys
import warnings
from pathlib import Path

import pytest
import yaml

import scripts.train as train_script

_REPO_ROOT = Path(__file__).resolve().parents[1]
_REAL_CONFIG = _REPO_ROOT / "configs" / "searchqa" / "default.yaml"


def _argv(*extra: str, config: Path | None = None) -> list[str]:
    return [
        "skillopt-train",
        "--config",
        str(config or _REAL_CONFIG),
        *extra,
    ]


def _structured_config_setting_the_retired_key(tmp_path: Path) -> Path:
    """A real structured config that still sets ``gradient.max_analyst_rounds``.

    Inherits the shipped config through ``_base_`` (absolute, which ``_load_yaml``
    resolves via ``os.path.join``) so this is a complete config and not a
    hand-built fragment that only exercises the parts we remembered.
    """
    path = tmp_path / "still_sets_it.yaml"
    path.write_text(
        yaml.safe_dump(
            {"_base_": str(_REAL_CONFIG), "gradient": {"max_analyst_rounds": 3}}
        ),
        encoding="utf-8",
    )
    return path


def _legacy_flat_config_setting_the_retired_key(tmp_path: Path) -> Path:
    """The same thing in the legacy flat format.

    Built by flattening the shipped structured config, so it is exactly the
    layout `flatten_config` produces rather than an invented subset.
    """
    from skillopt.config import flatten_config, load_config

    flat = flatten_config(load_config(str(_REAL_CONFIG)))
    flat["max_analyst_rounds"] = 3
    path = tmp_path / "legacy_flat.yaml"
    path.write_text(yaml.safe_dump(flat), encoding="utf-8")
    return path


# "0" is the case from the original report: the option has to be recognised as
# supplied even when it is falsy.
@pytest.mark.parametrize("value", ["5", "0"])
def test_retired_option_warns_and_stays_out_of_the_config(monkeypatch, value) -> None:
    monkeypatch.setattr(sys, "argv", _argv("--max_analyst_rounds", value))

    with pytest.warns(FutureWarning, match="max_analyst_rounds"):
        cfg = train_script.load_config(train_script.parse_args())

    # A retired option has no structured path, so without an explicit skip the
    # legacy CLI mapping files it under ``env.`` and it reaches the trainer.
    assert "max_analyst_rounds" not in cfg


def test_the_warning_survives_pythons_default_filters(monkeypatch) -> None:
    """``DeprecationWarning`` would not reach a user here.

    ``skillopt-train`` is a console script pointing at ``scripts.train:main``, so
    the warning is raised from an imported module rather than from ``__main__``,
    and Python's default filters end in ``ignore::DeprecationWarning``. Asserting
    the category alone would not catch that, so this runs the real
    ``load_config`` under those filters instead of pytest's permissive ones and
    asserts the user is told.
    """
    monkeypatch.setattr(sys, "argv", _argv("--max_analyst_rounds", "5"))
    args = train_script.parse_args()

    with warnings.catch_warnings(record=True) as caught:
        warnings.resetwarnings()  # drop pytest's filters
        warnings.simplefilter("default")  # Python's startup default for most
        warnings.filterwarnings("default", category=DeprecationWarning,
                                module="__main__")
        warnings.filterwarnings("ignore", category=DeprecationWarning)
        train_script.load_config(args)

    assert [w for w in caught if "max_analyst_rounds" in str(w.message)], (
        "the retirement warning did not survive Python's default filters, so a "
        "normal `skillopt-train` run would drop it silently"
    )


def test_a_config_file_that_still_sets_it_warns(monkeypatch, tmp_path) -> None:
    """The path the CLI warning missed. ``flatten_config`` no longer maps the key
    and the trainer no longer reads it, so without this the file is ignored in
    silence."""
    config = _structured_config_setting_the_retired_key(tmp_path)
    monkeypatch.setattr(sys, "argv", _argv(config=config))

    with pytest.warns(FutureWarning, match="the config file"):
        cfg = train_script.load_config(train_script.parse_args())

    assert "max_analyst_rounds" not in cfg


def test_a_legacy_flat_config_that_still_sets_it_warns(monkeypatch, tmp_path) -> None:
    """Legacy flat YAML gets the same treatment: the key is top-level there, so
    the structured lookup would miss it."""
    config = _legacy_flat_config_setting_the_retired_key(tmp_path)
    monkeypatch.setattr(sys, "argv", _argv(config=config))

    with pytest.warns(FutureWarning, match="the config file"):
        cfg = train_script.load_config(train_script.parse_args())

    assert "max_analyst_rounds" not in cfg


@pytest.mark.parametrize(
    "override",
    ["gradient.max_analyst_rounds=3", "max_analyst_rounds=3"],
)
def test_retired_override_preserves_legacy_flat_config(
    monkeypatch, tmp_path, override
) -> None:
    """A retired override must not reclassify a legacy flat file as structured."""
    config = _legacy_flat_config_setting_the_retired_key(tmp_path)
    monkeypatch.setattr(sys, "argv", _argv(config=config))
    with pytest.warns(FutureWarning, match="the config file"):
        expected = train_script.load_config(train_script.parse_args())

    monkeypatch.setattr(
        sys,
        "argv",
        _argv("--cfg-options", override, "batch_size=9", config=config),
    )
    with pytest.warns(FutureWarning, match="cfg-options"):
        cfg = train_script.load_config(train_script.parse_args())

    # ``load_config`` synthesizes a timestamped output directory on each call.
    expected.pop("out_root", None)
    cfg.pop("out_root", None)
    expected["batch_size"] = 9
    assert cfg == expected


@pytest.mark.parametrize(
    "override",
    ["gradient.max_analyst_rounds=3", "max_analyst_rounds=3"],
)
def test_cfg_options_that_still_set_it_warn(monkeypatch, tmp_path, override) -> None:
    """Both spellings, because a user migrating a launch script reaches for the
    structured key and a user migrating a flag reaches for the flat one."""
    monkeypatch.setattr(sys, "argv", _argv("--cfg-options", override))

    with pytest.warns(FutureWarning, match="cfg-options"):
        train_script.load_config(train_script.parse_args())


def test_an_override_is_not_reported_twice(monkeypatch) -> None:
    """``--cfg-options`` is merged into the config before this check runs, so the
    naive version names both the flag and the file for one mistake."""
    monkeypatch.setattr(
        sys, "argv", _argv("--cfg-options", "gradient.max_analyst_rounds=3")
    )

    with warnings.catch_warnings(record=True) as caught:
        warnings.simplefilter("always")
        train_script.load_config(train_script.parse_args())

    messages = [str(w.message) for w in caught if "max_analyst_rounds" in str(w.message)]
    assert len(messages) == 1, messages
    assert "the config file" not in messages[0], messages[0]


def test_no_warning_when_the_option_is_absent(monkeypatch) -> None:
    monkeypatch.setattr(sys, "argv", _argv())

    with warnings.catch_warnings(record=True) as caught:
        warnings.simplefilter("always")
        train_script.load_config(train_script.parse_args())

    assert [w for w in caught if "max_analyst_rounds" in str(w.message)] == []
