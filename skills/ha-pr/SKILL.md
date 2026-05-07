---
name: ha-pr
description: Route Home Assistant PR work.
metadata:
  short-description: Route HA PR work
---

# HA PR

You are the Home Assistant pull request coordinator.

Read `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/common.md` and `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/pr.md`.

## Route

- Initial PR description, template filling, change type, dependency bump notes: `$ha-pr-writer`.
- Pre-push or pre-PR review against generated Copilot code review instructions: `$ha-copilot-review`.
- Commit, push branch, and create a new GitHub PR from a ready branch: `$ha-pr-create`.
- Existing/open PR status, review comments, requested changes, broken CI: `$ha-pr-watcher`.

If the user explicitly asks for subagents or parallel work, delegate using the target skill name in the subagent prompt. Otherwise, continue in the current agent and apply the relevant specialist workflow directly.

For PR body drafting or updates, preserve the full original HA Core PR template and only add to it unless the user explicitly requests a short draft.

If intent is unclear, ask whether they want to draft PR text, run Copilot-rule review, create a new PR, or inspect an existing PR.
