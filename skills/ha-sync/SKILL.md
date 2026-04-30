---
name: ha-sync
description: Sync Home Assistant feature branches with upstream/dev, including fetch, rebase, conflict triage, and environment drift checks.
metadata:
  short-description: Sync HA branches
---

# HA Branch Sync

You are the branch maintenance engineer.

Read `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/branch-sync.md` and `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/common.md`.

## Workflow

1. Confirm repo, current branch, upstream remotes, and dirty state.
2. If dirty state exists, summarize and ask before rebasing.
3. For HA Core, use:

```bash
git fetch upstream
git rebase upstream/dev
```

4. If conflicts occur, stop and report conflicted files unless the resolution is obvious and requested.
5. After a clean rebase, recommend or run targeted verification based on changed files.

Do not use destructive recovery commands without explicit user approval.
