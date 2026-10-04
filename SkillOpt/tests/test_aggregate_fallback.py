from unittest.mock import patch

import pytest

from skillopt.gradient.aggregate import _merge_batch, merge_patches


def test_merge_batch_fallback_on_runtime_error():
    """Test that _merge_batch falls back to concatenation when optimizer raises RuntimeError."""
    patches = [
        {"reasoning": "r1", "edits": [{"id": "1", "content": "one"}]},
        {"reasoning": "r2", "edits": [{"id": "2", "content": "two"}]},
    ]

    with patch("skillopt.gradient.aggregate.chat_optimizer", side_effect=RuntimeError("API is down")):
        with pytest.warns(UserWarning, match="Optimizer call or parsing failed during batch merge"):
            result = _merge_batch(
                skill_content="skill content",
                patches=patches,
                system_prompt="merge this",
                update_mode="patch",
                level=2,
            )

    assert result["reasoning"] == "fallback concatenation"
    assert "edits" in result
    assert len(result["edits"]) == 2
    assert result["edits"][0]["id"] == "1"
    assert result["edits"][0]["merge_level"] == 2
    assert result["edits"][1]["id"] == "2"
    assert result["edits"][1]["merge_level"] == 2


def test_merge_batch_fallback_on_malformed_json():
    """A real non-JSON optimizer response is observable and falls back."""
    patches = [{"reasoning": "r1", "edits": [{"id": "1", "content": "one"}]}]

    with patch("skillopt.gradient.aggregate.chat_optimizer", return_value=("not json", None)):
        with pytest.warns(UserWarning, match="unusable output during batch merge"):
            result = _merge_batch(
                skill_content="skill content",
                patches=patches,
                system_prompt="merge this",
                update_mode="patch",
                level=1,
            )

    assert result["reasoning"] == "fallback concatenation"
    assert len(result["edits"]) == 1


def test_merge_batch_warning_does_not_expose_exception_text():
    """Provider response bodies and credentials must not be copied to logs."""
    secret = "Authorization: Bearer sk-secret-example"
    patches = [{"reasoning": "r1", "edits": [{"id": "1", "content": "one"}]}]

    with patch("skillopt.gradient.aggregate.chat_optimizer", side_effect=RuntimeError(secret)):
        with pytest.warns(UserWarning) as caught:
            result = _merge_batch(
                skill_content="skill content",
                patches=patches,
                system_prompt="merge this",
                update_mode="patch",
                level=1,
            )

    assert result["reasoning"] == "fallback concatenation"
    assert secret not in "\n".join(str(item.message) for item in caught)


def test_merge_patches_fallback_on_runtime_error():
    """Test that merge_patches falls back during the final merge if the optimizer fails."""
    failure_patches = [{"reasoning": "f1", "edits": [{"id": "1", "content": "f_one"}]}]
    success_patches = [{"reasoning": "s1", "edits": [{"id": "2", "content": "s_two"}]}]

    # We patch _hierarchical_merge to just return the single patches to skip the batch merges,
    # and then patch chat_optimizer to fail on the final merge.
    def mock_hierarchical(skill_content, patches, *args, **kwargs):
        return patches[0]

    with patch("skillopt.gradient.aggregate._hierarchical_merge", side_effect=mock_hierarchical):
        with patch("skillopt.gradient.aggregate.chat_optimizer", side_effect=RuntimeError("Timeout")):
            with pytest.warns(UserWarning, match="Optimizer call or parsing failed during final merge"):
                result = merge_patches(
                    skill_content="content",
                    failure_patches=failure_patches,
                    success_patches=success_patches,
                    batch_size=2,
                    verbose=False,
                )

    assert result["reasoning"] == "fallback: failure first, then success"
    assert len(result["edits"]) == 2
    assert result["edits"][0]["id"] == "1"
    assert result["edits"][1]["id"] == "2"


def test_merge_patches_warns_on_unusable_output():
    """A non-JSON final response is observable and uses the safe fallback."""
    failure_patches = [{"reasoning": "f1", "edits": [{"id": "1", "content": "f_one"}]}]
    success_patches = [{"reasoning": "s1", "edits": [{"id": "2", "content": "s_two"}]}]

    def first_patch(_skill_content, patches, *args, **kwargs):
        return patches[0]

    with patch("skillopt.gradient.aggregate._hierarchical_merge", side_effect=first_patch):
        with patch("skillopt.gradient.aggregate.chat_optimizer", return_value=("not json", None)):
            with pytest.warns(UserWarning, match="unusable output during final merge"):
                result = merge_patches(
                    skill_content="content",
                    failure_patches=failure_patches,
                    success_patches=success_patches,
                    batch_size=2,
                    verbose=False,
                )

    assert result["reasoning"] == "fallback: failure first, then success"
    assert [edit["id"] for edit in result["edits"]] == ["1", "2"]


@pytest.mark.parametrize(
    "response",
    ['{"edits": null}', '{"edits": ["not an object"]}'],
)
def test_merge_patches_rejects_invalid_payload_shape(response):
    """A present but invalid payload must not bypass fallback in quiet mode."""
    failure_patches = [{"reasoning": "f1", "edits": [{"id": "1"}]}]
    success_patches = [{"reasoning": "s1", "edits": [{"id": "2"}]}]

    def first_patch(_skill_content, patches, *args, **kwargs):
        return patches[0]

    with patch("skillopt.gradient.aggregate._hierarchical_merge", side_effect=first_patch):
        with patch("skillopt.gradient.aggregate.chat_optimizer", return_value=(response, None)):
            with pytest.warns(UserWarning, match="unusable output during final merge"):
                result = merge_patches(
                    skill_content="content",
                    failure_patches=failure_patches,
                    success_patches=success_patches,
                    verbose=False,
                )

    assert result["reasoning"] == "fallback: failure first, then success"
    assert [edit["id"] for edit in result["edits"]] == ["1", "2"]
