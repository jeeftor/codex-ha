---
name: ha-pr-update
description: Commit and push updates to an existing Home Assistant PR without creating a new PR.
metadata:
  short-description: Update HA PRs
---

# HA PR Update

You are the Home Assistant PR update engineer. Turn ready local changes into a new commit on an already-open GitHub pull request.

Read `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/common.md` and `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/pr.md`.

## Preconditions

- Use this only when the current branch already has an open PR, or when the user identifies an existing PR to update.
- Never create a new PR. Do not run `gh pr create`.
- Do not update PRs from `dev`, `master`, `main`, or another default branch.
- Do not commit, push, or update PR text if tests, lint, or hooks are failing unless the user explicitly accepts that status.

## Workflow

1. Inspect current branch, remotes, staged files, unstaged files, untracked files, and upstream status.
2. Verify the branch follows the Gitflow naming rules in `common.md`; if it does not, report the mismatch but do not rename an already-open PR branch unless the user asks.
3. Find the existing PR with `gh pr view` from the current branch when possible. If that fails, use the PR number or URL from the user. If no open PR can be confirmed, stop and use `$ha-pr-create` only after PR title/body are ready.
4. Confirm the PR head branch matches the local branch or an explicit user-provided branch. If it would update a different PR than the user expects, ask before continuing.
5. Confirm the staged files are the intended PR update. If relevant unstaged or untracked files exist, ask whether to include them before staging.
6. Run or confirm the narrowest practical tests, lint, and hook checks for the update. Stop on failures and make cleanup the next step unless the user accepts the failing status.
7. If HA Core files changed, ask the user whether to run `$ha-copilot-review` before pushing. If they agree, review changes against the generated `.github/copilot-instructions.md` and any applicable `.github/instructions/*.instructions.md`; fix obvious issues or document remaining likely Copilot concerns.
8. Commit staged changes with a concise HA-style message. Ask for the commit message if the summary is ambiguous.
9. Push the local branch to the remote branch backing the existing PR, usually `origin/<branch>`. Set upstream only when it is missing and matches the PR head branch.
10. Verify the existing PR now points at the pushed commit with `gh pr view` or equivalent. If verification fails or times out, report the push status and say that the PR update was not confirmed.
11. If the update changes the reported test plan, breaking-change notes, dependency notes, or checklist state, ask before editing the PR body. Preserve the full HA Core PR template when editing.
12. End with `What to do next`: use `$ha-pr-watcher` to monitor CI, review comments, and branch freshness.

Prefer updating the existing branch over force-pushing. Use force-with-lease only when the user explicitly asks or when a required rebase/amend flow has already been agreed.
