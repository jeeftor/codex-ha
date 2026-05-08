---
name: ha-library
description: Maintain Python libraries behind HA integrations.
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

## API Modeling

- Prefer library-owned domain types on public APIs and tests. If the library defines `Location`, `Device`, `Reading`, or a similar model, use that type instead of `object`, `Any`, raw JSON dictionaries, or a parallel HA-only abstraction.
- Parse provider JSON at the library boundary into existing typed models, or add the smallest library-owned model when the concept belongs in the backing library.
- Keep HA Core consuming the library's typed API directly; do not duplicate library models in the integration unless HA owns a distinct entity or config concept.

Do not publish, tag, or push releases unless the user explicitly asks.
