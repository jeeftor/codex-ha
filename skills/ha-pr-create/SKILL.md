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
- Use `$ha-pr-update` instead when the current branch already has an open PR.
- Do not create a PR from `dev`, `master`, `main`, or another default branch.
- Do not commit, rename, push, or create the PR if tests, lint, or hooks are failing unless the user explicitly accepts that status.

## Workflow

1. Inspect current branch, remotes, staged files, unstaged files, untracked files, and upstream status.
2. Check whether the current branch already has an open PR with `gh pr view` or equivalent. If one exists, stop and use `$ha-pr-update`; do not create another PR.
3. Verify the branch follows the Gitflow naming rules in `common.md`; if not, propose the preferred name and ask before renaming.
4. Confirm the staged files are the intended PR contents. If relevant unstaged or untracked files exist, ask whether to include them before staging.
5. Verify the PR title/body is available from the current conversation, a user-provided file, or a generated temp file. If not, stop and use `$ha-pr-writer` first.
6. Before creating the PR, compare the body against the current HA Core PR template when practical. If original template sections, comments, checklists, placeholders, or unchecked boxes are missing, restore them while keeping user-authored PR content.
7. Normalize only filled-in or user-added verification text by replacing local wrapper commands or machine-specific aliases such as `rtk` with repo-native commands reviewers can run.
8. Run or confirm the narrowest practical tests, lint, and hook checks. Stop on failures and make cleanup the next step.
9. If HA Core files changed, ask the user whether to run `$ha-copilot-review` before pushing. If they agree, review changes against the generated `.github/copilot-instructions.md` and any applicable `.github/instructions/*.instructions.md`; fix obvious issues or document remaining likely Copilot concerns.
10. Commit staged changes with a concise HA-style message. Ask for the commit message if the summary is ambiguous.
11. Push the branch to the user's fork, usually `origin`, setting upstream when needed.
12. Create the PR as a draft with `gh pr create --draft`, targeting Home Assistant Core `dev` unless the user specifies another base. Do not mark it ready for review; the user will manually move it out of draft.
13. Verify the PR URL and draft state with `gh pr view` or equivalent before saying the PR exists. If verification fails or times out, report the push status and say that PR existence was not confirmed.
14. End with `What to do next`: use `$ha-pr-watcher` to monitor CI, review comments, and branch freshness.

Prefer `gh pr create --body-file <file>` over `--fill` so the HA template text from `$ha-pr-writer` is preserved intact.
