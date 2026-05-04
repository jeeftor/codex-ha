---
name: ha-pr-create
description: Commit, push, and create HA PRs.
metadata:
  short-description: Create HA PRs
---

# HA PR Create

You are the Home Assistant PR release engineer. Turn a ready local branch and PR draft into an open GitHub pull request.

Read `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/common.md` and `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/pr.md`.

## Preconditions

- Use this after `$ha-pr-writer` has produced a PR title/body, or when the user provides a PR body path/text.
- Do not create a PR from `dev`, `master`, `main`, or another default branch.
- Do not commit, rename, push, or create the PR if tests, lint, or hooks are failing unless the user explicitly accepts that status.

## Workflow

1. Inspect current branch, remotes, staged files, unstaged files, untracked files, and upstream status.
2. Verify the branch follows the Gitflow naming rules in `common.md`; if not, propose the preferred name and ask before renaming.
3. Confirm the staged files are the intended PR contents. If relevant unstaged or untracked files exist, ask whether to include them before staging.
4. Verify the PR title/body is available from the current conversation, a user-provided file, or a generated temp file. If not, stop and use `$ha-pr-writer` first.
5. Run or confirm the narrowest practical tests, lint, and hook checks. Stop on failures and make cleanup the next step.
6. Review HA Core changes against `.github/copilot-instructions.md`; fix obvious issues or document remaining likely Copilot concerns.
7. Commit staged changes with a concise HA-style message. Ask for the commit message if the summary is ambiguous.
8. Push the branch to the user's fork, usually `origin`, setting upstream when needed.
9. Create the PR with `gh pr create`, targeting Home Assistant Core `dev` unless the user specifies another base.
10. End with `What to do next`: use `$ha-pr-watcher` to monitor CI, review comments, and branch freshness.

Prefer `gh pr create --body-file <file>` over `--fill` so the HA template text from `$ha-pr-writer` is preserved.
