# Codex HA Skills

Codex HA is a standalone skill bundle for maintaining Home Assistant integrations and their backing Python libraries.

It installs plain skill names:

- `$ha-init` - discover local Home Assistant repos and write local config
- `$ha-workflow` - route broad Home Assistant maintainer tasks
- `$ha-integration` - maintain existing integrations
- `$ha-library` - update integration backing libraries
- `$ha-feature` - add integration features
- `$ha-bugfix` - fix integration or library bugs
- `$ha-tests` - write focused integration tests
- `$ha-coverage` - increase integration test coverage
- `$ha-quality` - route quality scale assessment and improvement work
- `$ha-quality-audit` - audit quality scale rules and evidence
- `$ha-quality-improve` - close quality scale gaps with focused implementation, docs, and tests
- `$ha-pr` - route PR work
- `$ha-pr-writer` - draft initial HA PR descriptions and required template fields
- `$ha-copilot-review` - review HA Core changes against generated Copilot instructions before PR creation
- `$ha-pr-create` - commit staged changes, push a branch, and create a GitHub PR
- `$ha-pr-watcher` - inspect open PR comments, checks, and requested changes
- `$ha-sync` - rebase feature branches onto `upstream/dev`
- `$ha-docs` - update `home-assistant.io` integration docs

## Install

Recommended:

```bash
curl -fsSL https://raw.githubusercontent.com/jeeftor/codex-ha/master/scripts/install.sh | sh
```

From a local checkout:

```bash
./scripts/install.sh
```

The installer copies skills to:

```text
~/.codex/skills/
```

and shared HA Assistant references/scripts to:

```text
~/.codex/ha-assistant/
```

Restart Codex after installation.

## Update

Run the installer again to update an existing install:

```bash
curl -fsSL https://raw.githubusercontent.com/jeeftor/codex-ha/master/scripts/install.sh | sh
```

If `ha-*` skills are already installed, the installer shows the existing skill directories and asks before removing them. It then installs the current bundle from scratch and refreshes shared files. This makes updates a clean reinstall.

## First Run

Configure local Home Assistant paths:

```text
$ha-init configure my Home Assistant setup. My GitHub handle is jeeftor and my repos are under ~/devel/ha.
```

The init skill writes personal config to:

```text
~/.codex/ha-assistant/config.yaml
```

That file is intentionally outside this repo.

## Uninstall

Recommended:

```bash
curl -fsSL https://raw.githubusercontent.com/jeeftor/codex-ha/master/scripts/uninstall.sh | sh
```

From a local checkout:

```bash
./scripts/uninstall.sh
```

By default, uninstall preserves:

```text
~/.codex/ha-assistant/config.yaml
```

To remove the generated config too:

```bash
curl -fsSL https://raw.githubusercontent.com/jeeftor/codex-ha/master/scripts/uninstall.sh | REMOVE_CONFIG=1 sh
```

## Alternative Install

Codex includes a `skill-installer` workflow that can install skills from GitHub into `$CODEX_HOME/skills`. That is good for one-off, self-contained skills.

This repo uses an install script because the HA skills share references and helper scripts under `~/.codex/ha-assistant`. Installing only one skill folder from GitHub would not install those shared files.

## Delegation

`$ha-workflow` can route to the specialist skills. When the user explicitly asks for subagents, delegation, or parallel work, it can spawn focused agents and include the target skill in the subagent prompt, such as `Use $ha-tests` or `Use $ha-library`.

## Expected Local Layout

The skills can discover repos, but they work best with a layout like:

```text
~/devel/ha/core
~/devel/ha/home-assistant.io
~/devel/ha/weatherflow4py
```

They map integrations from Home Assistant Core manifests to nearby backing libraries when possible.

## Development

Repository layout:

```text
skills/
  ha-init/
  ha-workflow/
  ha-quality/
  ...
references/ha-assistant/
scripts/
```

Validate before pushing:

```bash
python3 -m py_compile scripts/discover_config.py
~/.codex/codex-python ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py skills/ha-workflow
~/.codex/codex-python ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py skills/ha-quality
~/.codex/codex-python ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py skills/ha-quality-audit
~/.codex/codex-python ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py skills/ha-quality-improve
~/.codex/codex-python ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py skills/ha-copilot-review
```

## Notes

- Home Assistant Core code and docs live in separate repositories.
- The skills read repo-local `AGENTS.md` and `CLAUDE.md` before editing.
- Branch sync for Home Assistant Core uses `git fetch upstream` and `git rebase upstream/dev`, stopping on dirty worktrees or conflicts.
