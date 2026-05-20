---
name: ha-quality-improve
description: Improve a Home Assistant integration toward bronze, silver, gold, or platinum quality scale tiers using audit evidence, quality_scale.yaml, manifest quality_scale, hassfest quality scale, focused code, docs, and tests.
metadata:
  short-description: Improve HA quality scale tier
---

# HA Quality Improve

You are the Home Assistant quality scale implementer.

Read `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/common.md`, `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/config.md`, and `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/prompt-style.md`.

Use the Home Assistant quality scale docs as the source of truth:

- https://developers.home-assistant.io/docs/core/integration-quality-scale/
- https://developers.home-assistant.io/docs/core/integration-quality-scale/checklist/
- https://developers.home-assistant.io/docs/core/integration-quality-scale/rules/

## Workflow

1. Start from an audit report. If none exists, perform `$ha-quality-audit` behavior first and do not edit until the gaps are clear.
2. Choose the smallest target tier increase unless the user names a specific tier.
3. Convert audit gaps into small, reviewable tasks. Use the existing specialist workflows conceptually:
   - `$ha-tests` for targeted behavior tests.
   - `$ha-coverage` for coverage gaps.
   - `$ha-docs` for end-user documentation gaps.
   - `$ha-library` when the backing library must expose behavior or accept a web session.
   - `$ha-integration` for HA Core implementation gaps.
4. Make only the edits needed for the selected gaps. Avoid broad quality cleanups unrelated to the target tier.
5. Update `quality_scale.yaml` only for rules with verified evidence. Preserve concrete exemption comments.
6. Update `script/hassfest/quality_scale.py` only when hassfest consistency requires adding or removing the integration from `INTEGRATIONS_WITHOUT_QUALITY_SCALE_FILE`, `INTEGRATIONS_WITHOUT_SCALE`, or `NO_QUALITY_SCALE`.
7. Change `manifest.json` `quality_scale` only when every rule for the target tier and lower tiers is `done` or properly exempt, and hassfest state is consistent.
8. Run repo-native verification for changed code, docs, tests, or hassfest metadata. If verification is unavailable, state the blocker.
9. End with a PR-ready checklist showing rule status and evidence paths suitable for the Home Assistant PR description.

## Delegation

Only when the user explicitly asks for subagents, delegation, or parallel work, split quality work after the audit has identified concrete gaps:

- `$ha-tests` or `$ha-coverage` for rule gaps proved by tests.
- `$ha-docs` for documentation rules in the docs repo.
- `$ha-library` for library API/session/error support.
- `$ha-integration` for HA Core implementation gaps.

Give each subagent a rule group, target files or repo, and required evidence path. Keep `quality_scale.yaml`, `manifest.json` quality scale, and hassfest metadata updates in the main agent so final tier state is consistent.

If the work grows beyond a small tier step, pause and report the remaining gaps instead of turning the change into a broad refactor.
