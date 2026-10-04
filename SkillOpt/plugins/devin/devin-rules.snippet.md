# SkillOpt-Sleep (Devin)

You have access to a nightly self-evolution cycle via the `skillopt-sleep` MCP
server. Use these tools to improve your long-term skills over time:

- **`sleep_status`** — refresh the converted local cache, then show how many
  nights have run and the latest staged proposal
- **`sleep_dry_run`** — refresh the converted local cache and preview a cycle
  without engine staging/adoption; a real backend still makes provider calls
- **`sleep_run`** — run a full cycle; stages a proposal by default, while an
  explicit `auto_adopt` may also update live files
- **`sleep_adopt`** — apply a reviewed legacy or per-skill staged proposal;
  the core engine applies the selected target and creates its backup
- **`sleep_harvest`** — debug: list the recurring tasks mined from recent sessions
- **`sleep_schedule`** / **`sleep_unschedule`** — low-level shared-engine cron
  controls; the current scheduled command does not run Devin's conversion step,
  so do not use it as an unattended Devin-harvest workflow

When a user asks about the sleep cycle or skill evolution, prefer calling these
tools over explaining the concept.

Always pass the absolute Devin workspace as `project`, especially for
`sleep_adopt`. Default backend is `mock` (no provider calls). The `claude`,
`codex`, and `copilot` backend values use the corresponding installed and
authenticated CLI; they do not require this plugin to implement a separate
API-key flow. The `handoff` backend runs the cycle with no model subprocess
or API key — the engine writes pending model calls to
`.skillopt-sleep-handoff/` and exits; answer each prompt in a fresh context
and re-run `sleep_run` to resume (typically 3–6 rounds).

The Devin conversion and mock workflow stay local. A real backend sends
truncated transcript excerpts and derived tasks to the selected provider for
mining, replay, judging, and reflection; conversion is not a guarantee that
outbound prompts contain no secrets. Review local sources and provider policy
before selecting a real backend.

For a reviewed task file, pass `tasks_file`; before using it with a real backend,
inspect/redact it and ensure its metadata contains `"reviewed": true`.

Before `sleep_adopt`, inspect `sleep_status` and the staging manifest. Pass
`staging` for the exact reviewed staging directory, plus exactly one selection
mode: `skills` (an array of reviewed skill names), `all_skills` (every staged
per-skill proposal), or `legacy` (the managed `SKILL.md`/`CLAUDE.md` pair). Do
not combine selection modes. A bare call is only for legacy-only staging
compatibility; fan-out staging requires explicit selection. Pass names as MCP
array values, not as an invented shell command.

The adapter performs no post-adoption copy. To operate on a specific Devin
skill, pass its `SKILL.md` as `target_skill_path`; the core engine is solely
responsible for applying the reviewed proposal and maintaining its backup.

Place this file at `.devin/rules/skillopt-sleep.md` in your workspace.
