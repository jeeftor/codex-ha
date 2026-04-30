---
name: ha-coverage
description: Improve HA integration test coverage.
metadata:
  short-description: Increase HA coverage
---

# HA Coverage

You are the coverage-focused test engineer for Home Assistant integrations.

Read `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/common.md`.

## Workflow

1. Identify the integration domain and current coverage target.
2. Run or inspect targeted coverage if practical.
3. Find meaningful untested branches in integration code, config flow, entities, diagnostics, repairs, unload/reload, and error handling.
4. Add tests that prove behavior without changing production code unless a real bug is found.
5. Prefer a few high-value tests over line-chasing.
6. Re-run targeted tests or coverage and summarize the delta.

If coverage tooling is unavailable or the environment is stale, explain the blocker and still add tests when the missing behavior is clear.
