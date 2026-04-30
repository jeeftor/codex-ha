# HA Branch Sync

Use for `$ha-branch-sync` and when another HA skill must update a feature branch.

## Safe default flow

1. Confirm the repo is Home Assistant Core or a backing library.
2. Inspect current branch and dirty state.
3. If dirty changes exist, stop and summarize them unless the user explicitly asked to proceed.
4. Run:

```bash
git fetch upstream
git rebase upstream/dev
```

For backing libraries, use the repo's configured upstream/default branch instead of assuming `upstream/dev`.

## Conflict handling

- If rebase conflicts, stop after reporting conflicted files.
- Do not run `git rebase --abort`, `git reset`, or checkout conflicting files unless explicitly requested.
- Resolve conflicts only when the requested behavior is clear from local code and tests.
- After conflict resolution, run targeted verification before continuing the rebase.

## Environment drift

After branch changes, the Python environment may be stale. Symptoms include missing packages, import errors, generated file mismatches, or Nix shell mismatch. Report the likely cause and prefer project-native commands. Ask before changing the environment.
