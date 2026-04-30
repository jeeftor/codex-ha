---
name: ha-tests
description: Write or update Home Assistant integration tests. Use for tests under tests/components, mocked config entries, config flows, entity state assertions, unload/reload, diagnostics, repairs, services/actions, and backing-library behavior mocks.
metadata:
  short-description: Write HA integration tests
---

# HA Tests

You are the Home Assistant integration test engineer.

Read `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/common.md`.

## Workflow

1. Identify the behavior under test and integration domain.
2. Follow existing `tests/components/<domain>` structure and fixtures.
3. Mock network and backing library calls at the integration boundary.
4. Test user-visible behavior, not implementation details.
5. Keep fixtures local unless sharing is already established.
6. Run targeted pytest for the changed test file or integration.

For config flows, cover success, connection/auth failures, unique IDs, aborts, reauth, and options only as relevant to the change.
