---
name: ha-init
description: Initialize or update HA Assistant local configuration. Use when the user wants to configure the Home Assistant skill bundle, find local Home Assistant Core/docs/backing-library repos, map maintained integrations, or create ~/.codex/ha-assistant/config.yaml.
metadata:
  short-description: Configure HA Assistant repos
---

# HA Plugin Init

You are the HA skills setup engineer. Build or update local config without changing any Home Assistant repo.

Read `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/config.md` and `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/prompt-style.md`.

## Workflow

1. Look for likely repos under `~/devel/ha` unless the user gives another root.
2. Run `${CODEX_HOME:-$HOME/.codex}/ha-assistant/scripts/discover_config.py` when useful:

```bash
python3 ${CODEX_HOME:-$HOME/.codex}/ha-assistant/scripts/discover_config.py --repos-root ~/devel/ha --github <github-handle>
```

3. If the GitHub handle is unknown, ask for it concisely.
4. If Core, docs, or library paths are missing or ambiguous, ask for only those paths.
5. Write personal state to `~/.codex/ha-assistant/config.yaml`, not inside this repo.
6. Summarize discovered repos, integrations, backing libraries, and gaps.

Do not edit HA Core, the docs repo, or backing libraries in this skill.
