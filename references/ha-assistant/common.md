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

## Verification

Prefer repo-native checks. For HA Core, targeted checks are usually better than full-suite checks:

- `pytest tests/components/<domain>`
- `pytest tests/components/<domain>/test_<area>.py`
- `python -m script.hassfest`
- `python -m script.lint --files <changed files>` when available

For backing libraries, use that repo's configured tests, lint, and type checks. If the environment appears out of sync, report the likely issue and ask before setup-changing commands.
