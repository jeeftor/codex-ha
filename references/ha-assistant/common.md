# HA Assistant Common Workflow

Use this reference for every HA skill unless the task is only plugin setup.

## Instruction order

Before editing, read local project instructions that apply to the files you will touch:

1. `AGENTS.md`
2. `CLAUDE.md`

Search from the current repo root and the nearest parent directories for the files being edited. Repeat for backing library and docs repos when those repos are touched. Treat local repo instructions as authoritative for that repo.

## Default paths

- Config: `~/.codex/ha-assistant/config.yaml`
- Common repo root: `~/devel/ha`
- HA Core repo: `~/devel/ha/core`
- HA docs repo: `~/devel/ha/home-assistant.io`
- Integration code: `homeassistant/components/<domain>`
- Integration tests: `tests/components/<domain>`
- Integration docs: `source/_integrations/<domain>.markdown`

The config file is a hint, not a requirement. If the current directory or git state gives enough context, proceed.

## Context gathering

Goal: get enough context fast, then act.

- Infer the integration from the current path, user prompt, git diff, or config.
- Read the integration `manifest.json`, changed files, nearby tests, and backing library requirements.
- For backing libraries, inspect `pyproject.toml`, package code, tests, and current git branch.
- Stop gathering once you can name the files to change and the verification command.
- Ask only when ambiguity affects correctness, data loss, security, branch safety, or user-visible behavior.

## Home Assistant sources

- Core repo: https://github.com/home-assistant/core
- Developer docs: https://developers.home-assistant.io/
- Docs repo: https://github.com/home-assistant/home-assistant.io
- Documentation guide: https://developers.home-assistant.io/docs/documenting/
- Integration quality scale: https://developers.home-assistant.io/docs/core/integration-quality-scale/

## Coding constraints

- Keep changes surgical and integration-scoped.
- Match existing integration patterns before inventing new structure.
- Prefer fixing the backing library when the bug belongs there.
- Preserve user changes and unrelated dirty work.
- Do not alter global tooling, global TLS settings, or Nix setup.
- For new integrations, keep the first PR small and Bronze-oriented.

## Git workflow

Use Gitflow-style branch names for new local work branches:

- Feature work: `feature/<issue-or-domain>-<short-slug>`
- Bug fixes and regressions: `bugfix/<issue-or-domain>-<short-slug>`
- Test-only or coverage work: `feature/<domain>-tests` or `feature/<domain>-coverage`
- Documentation-only work: `feature/<domain>-docs`
- Dependency bumps: `feature/<domain>-dependency-<package-or-version>`
- Hotfix branches: `hotfix/<short-slug>` only when the user explicitly asks for a production hotfix.

Keep branch slugs lowercase, hyphen-separated, and concise. Prefer issue numbers when available, for example `feature/153254-weatherflow-cloud-sensor`.

Before creating a branch, inspect the current branch and dirty state. Do not rename, delete, or switch away from a branch with user changes unless the user explicitly asks. If the current branch does not follow Gitflow naming, mention the preferred name and ask before renaming.

## Verification

Prefer repo-native checks. For HA Core, targeted checks are usually better than full-suite checks:

- `pytest tests/components/<domain>`
- `pytest tests/components/<domain>/test_<area>.py`
- `python -m script.hassfest`
- `python -m script.lint --files <changed files>` when available

If the repo uses commit hooks, run the narrowest practical hook check before calling work PR-ready. Prefer `prek` when available, otherwise use the repo's configured `pre-commit` flow. If hooks fail, leave files uncommitted, summarize the failing hook and command, and make hook cleanup the next step.

For backing libraries, use that repo's configured tests, lint, type checks, and hooks. If the environment appears out of sync, report the likely issue and ask before setup-changing commands.

## Completion handoff

End every completed HA task with a `What to do next` section when there is a valid follow-up. Include only relevant next skill suggestions:

- Use `$ha-tests` when behavior changed and tests are missing or incomplete.
- Use `$ha-coverage` when the goal is coverage improvement or untested branches remain.
- Use `$ha-docs` when user-visible setup, entities, actions, options, troubleshooting, or compatibility changed.
- Use `$ha-library` when the backing library still needs a release, version bump, or API follow-up.
- Use `$ha-sync` when the branch is stale or a rebase onto `upstream/dev` is needed.
- Use `$ha-pr-writer` only when tests, lint, and hooks are passing or the remaining failures are explicitly documented.
- Use `$ha-pr-create` after `$ha-pr-writer` when staged changes and PR text are ready to commit, push, and open.
- Use `$ha-pr-watcher` after a PR exists and needs CI, comments, or review follow-up.

For `$ha-pr-writer`, the usual next step is `$ha-pr-create`. After `$ha-pr-create` opens the PR, use `$ha-pr-watcher`.

Do not suggest every skill. Recommend the smallest useful next step. If there is no valid follow-up, write `What to do next: no HA follow-up skill is needed.`
