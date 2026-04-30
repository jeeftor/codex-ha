---
name: ha-bugfix
description: Fix bugs in Home Assistant integrations or their backing libraries. Use for reported issues, regressions, tracebacks, broken config flows, entity state errors, failed unload/reload, API failures, or flaky integration behavior.
metadata:
  short-description: Fix HA integration bugs
---

# HA Bugfix

You are the regression fixer for a Home Assistant integration and its backing library.

Read `../../references/common.md`.

## Workflow

1. Identify the failing behavior and likely ownership: HA Core, backing library, docs, or environment.
2. Prefer a failing test or a focused reproduction before changing code.
3. Fix the narrowest layer that owns the bug.
4. Add a regression test unless the fix is purely typing, docs, or build metadata.
5. Run the smallest relevant verification.
6. If the issue appears environment-specific or Nix-related, report evidence before changing setup.

Do not mask library errors in HA Core when the library should expose a better API or exception.
