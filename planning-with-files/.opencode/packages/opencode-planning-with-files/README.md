# opencode-planning-with-files

Native [OpenCode](https://opencode.ai) plugin for [planning-with-files](https://github.com/OthmanAdi/planning-with-files): persistent file-based planning for AI coding agents. The plan lives on disk in `task_plan.md`, `findings.md` and `progress.md`; this plugin keeps it in the model's context on every turn and can hold the session open until the plan reports complete.

## Install

Add the plugin to `opencode.json` (project) or `~/.config/opencode/opencode.json` (global):

```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": ["opencode-planning-with-files"]
}
```

OpenCode installs the package on the next start. Install the skill text as well so the agent knows the workflow:

```bash
npx skills add OthmanAdi/planning-with-files --skill planning-with-files -g
```

That command lands in `~/.agents/skills/planning-with-files/`, one of the paths OpenCode reads natively.

## What the plugin does

| Hook | Behavior |
|---|---|
| `chat.message` | Appends the active plan to every user message: the framed head of `task_plan.md`, the normalized tail of `progress.md`, a pointer to `findings.md`. Resolves `PLAN_ID`, then `.planning/.active_plan`, then the newest `.planning/<slug>/task_plan.md`, then the legacy root file |
| `tool.execute.after` | Appends a progress reminder to the output of `write`, `edit`, `patch` and `multiedit` while a plan exists |
| `experimental.session.compacting` | Keeps the plan pointer and its attestation hash in the compaction summary |
| `event` (`session.idle`) | Completion gate in gated mode: while an `in_progress` phase remains, the plugin re-prompts the session with the gate reason. Block cap `PWF_GATE_CAP` (default 20) and ledger stall detection release the session; child sessions are never re-prompted |
| tools | `pwf_init` (root or `.planning/<date>-<slug>/`, `mode: autonomous` or `gated` with attestation), `pwf_status`, `pwf_check` |

Autonomous and gated plans inject only when `.attestation` (slug) or `.plan-attestation` (root) matches the SHA-256 of `task_plan.md`. `PLANNING_DISABLED=1` silences every hook; `PWF_PLAN_ROOT=<absolute path>` pins the project root and fails closed when it does not resolve. A live plan in a direct child project makes a cwd guess ambiguous and nothing is injected, with a one-line notice.

## Commands

Copy `pwf.md` and `pwf-status.md` from the repository's `.opencode/commands/` into `~/.config/opencode/commands/` (or your project's `.opencode/commands/`) to get `/pwf [--gated] [plan name]` and `/pwf-status`.

Full guide: [docs/opencode.md](https://github.com/OthmanAdi/planning-with-files/blob/master/docs/opencode.md).

## License

MIT
