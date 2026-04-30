# Codex HA Assistant

Codex HA Assistant is a Codex plugin for maintaining Home Assistant integrations and their backing Python libraries.

It packages a focused set of skills for common Home Assistant maintainer workflows:

- `$ha-plugin-init` - discover local Home Assistant repos and write local config
- `$ha-workflow` - route broad Home Assistant maintainer tasks
- `$ha-integration-maintainer` - maintain existing integrations
- `$ha-backing-library` - update integration backing libraries
- `$ha-feature` - add integration features
- `$ha-bugfix` - fix integration or library bugs
- `$ha-tests` - write focused integration tests
- `$ha-coverage` - increase integration test coverage
- `$ha-pr` - draft pull request text
- `$ha-branch-sync` - rebase feature branches onto `upstream/dev`
- `$ha-docs` - update `home-assistant.io` integration docs

## Install

Install the marketplace:

```bash
codex plugin marketplace add jeeftor/codex-ha
```

If the plugin is not enabled automatically, add this to `~/.codex/config.toml`:

```toml
[plugins."ha-assistant@codex-ha"]
enabled = true
```

Restart Codex after installing or changing plugin config.

## First Run

Configure local Home Assistant paths:

```text
$ha-plugin-init configure my Home Assistant setup. My GitHub handle is jeeftor and my repos are under ~/devel/ha.
```

The init skill writes personal config to:

```text
~/.codex/ha-assistant/config.yaml
```

That file is intentionally outside this repo.

## Expected Local Layout

The plugin can discover repos, but it works best with a layout like:

```text
~/devel/ha/core
~/devel/ha/home-assistant.io
~/devel/ha/weatherflow4py
```

It maps integrations from Home Assistant Core manifests to nearby backing libraries when possible.

## Development

Repository layout:

```text
.agents/plugins/marketplace.json
plugins/ha-assistant/
  .codex-plugin/plugin.json
  agents/openai.yaml
  references/
  scripts/
  skills/
```

Validate the plugin before pushing:

```bash
python3 -m json.tool .agents/plugins/marketplace.json
python3 -m json.tool plugins/ha-assistant/.codex-plugin/plugin.json
python3 -m py_compile plugins/ha-assistant/scripts/discover_config.py
```

Skill files can be validated with Codex's skill validator when available:

```bash
~/.codex/codex-python ~/.codex/skills/.system/skill-creator/scripts/quick_validate.py plugins/ha-assistant/skills/ha-workflow
```

## Notes

- Home Assistant Core code and docs live in separate repositories.
- The plugin reads repo-local `AGENTS.md` and `CLAUDE.md` before editing.
- Branch sync for Home Assistant Core uses `git fetch upstream` and `git rebase upstream/dev`, stopping on dirty worktrees or conflicts.
