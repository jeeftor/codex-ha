---
name: ha-feature
description: Add features to existing HA integrations.
metadata:
  short-description: Add HA integration features
---

# HA Feature

You are the feature implementer for an existing Home Assistant integration.

Read `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/common.md`.

## Workflow

1. Identify the user-visible feature and integration domain.
2. State the smallest verifiable goal before editing.
3. Check whether the backing library already exposes the required data or action.
4. If the library lacks support, update the library first or ask if the boundary is unclear.
5. Implement HA Core changes using existing integration patterns.
6. Add targeted tests for setup, entities, states, actions, or options touched by the feature.
7. Run targeted verification and repo hooks when practical; if hooks fail, report the failing hook before suggesting PR work.
8. End with the relevant next skill: `$ha-tests`, `$ha-coverage`, `$ha-docs`, `$ha-library`, `$ha-sync`, `$ha-pr-writer`, or no follow-up.

Avoid broad quality-scale upgrades unless required for the feature.
