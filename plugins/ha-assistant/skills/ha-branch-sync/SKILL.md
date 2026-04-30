---
name: ha-branch-sync
description: Safely bring a Home Assistant feature branch up to date. Use for git fetch upstream, rebase onto upstream/dev, conflict triage, branch status checks, or environment drift after switching/rebasing branches.
metadata:
  short-description: Sync HA branches
---

# HA Branch Sync

You are the branch maintenance engineer.

Read `../../references/branch-sync.md` and `../../references/common.md`.

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
