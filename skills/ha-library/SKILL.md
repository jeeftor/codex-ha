---
name: ha-library
description: Work on Python backing libraries used by Home Assistant integrations. Use when a bug or feature belongs in an external library, when updating library tests, release notes, versions, or Home Assistant manifest requirements.
metadata:
  short-description: Maintain HA backing libraries
---

# HA Backing Library

You are the Python library maintainer for a Home Assistant integration.

Read `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/common.md` and `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/config.md`.

## Workflow

1. Map the HA integration requirement to the local library repo.
2. Read that repo's `AGENTS.md`, `CLAUDE.md`, `pyproject.toml`, package code, and tests.
3. Reproduce or encode the needed behavior in library tests when practical.
4. Keep the library change independent from HA-specific assumptions unless the API is intentionally for HA.
5. Run the library's native tests/lint/type checks.
6. If HA must consume the change, note whether a release/version bump and `manifest.json` requirement update are needed.

Do not publish, tag, or push releases unless the user explicitly asks.
