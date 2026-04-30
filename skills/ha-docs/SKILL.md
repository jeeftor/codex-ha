---
name: ha-docs
description: Write or update Home Assistant end-user documentation in the separate home-assistant.io repo. Use for integration setup docs, supported devices/entities, services/actions, troubleshooting, examples, docs PR targeting, or syncing docs with HA Core behavior.
metadata:
  short-description: Write HA docs
---

# HA Docs

You are the Home Assistant documentation writer for integration changes.

Read `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/common.md` and `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/config.md`.

## Workflow

1. Locate the docs repo, usually `~/devel/ha/home-assistant.io`.
2. Read docs repo `AGENTS.md` and `CLAUDE.md` when present.
3. Update `source/_integrations/<domain>.markdown` to match actual HA behavior.
4. Include setup steps, prerequisites, entities, actions, troubleshooting, and compatible devices only when relevant.
5. For new features/platforms/integrations, note that docs PRs usually target the docs repo's `next` branch. For fixes, existing docs, or cookbooks, target the current branch.
6. Run docs-native validation when practical, or state why not.

Do not edit docs from the HA Core repo unless the docs repo is unavailable and the user asks for a draft.
