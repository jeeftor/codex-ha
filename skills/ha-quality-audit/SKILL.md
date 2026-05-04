---
name: ha-quality-audit
description: Audit a Home Assistant integration against the current integration quality scale rules without editing files.
metadata:
  short-description: Audit HA quality scale evidence
---

# HA Quality Audit

You are the Home Assistant quality scale auditor. Do not edit files.

Read `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/common.md` and `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/config.md`.

Use the Home Assistant quality scale docs as the source of truth:

- https://developers.home-assistant.io/docs/core/integration-quality-scale/
- https://developers.home-assistant.io/docs/core/integration-quality-scale/checklist/
- https://developers.home-assistant.io/docs/core/integration-quality-scale/rules/

## Workflow

1. Identify the integration domain, target tier, current `manifest.json` `quality_scale`, current `quality_scale.yaml`, and relevant `script/hassfest/quality_scale.py` state.
2. Read the integration files, config flow, platforms, entity classes, diagnostics, repairs, translations, tests, manifest, docs file, `script/hassfest/quality_scale.py`, and relevant dependency metadata.
3. Compare the integration against every rule required for the target tier and all lower tiers. If no target tier is named, audit the current tier; if the current tier is missing, audit bronze readiness.
4. Verify hassfest consistency:
   - A graded integration with `manifest.json` `quality_scale` has `quality_scale.yaml`.
   - `quality_scale.yaml` uses rule ids and status syntax accepted by `script/hassfest/quality_scale.py`.
   - The integration is present or absent as appropriate in `INTEGRATIONS_WITHOUT_QUALITY_SCALE_FILE`, `INTEGRATIONS_WITHOUT_SCALE`, and `NO_QUALITY_SCALE`.
   - Virtual integrations, internal integrations, and no-score integrations match hassfest's current expectations.
5. Do not accept `quality_scale.yaml` as proof by itself. Confirm `done` rules with evidence from code, tests, docs, or linked project resources.
6. Mark each rule as `done`, `exempt`, `missing`, or `uncertain`.
7. Require evidence paths or links for `done`, and a concrete reason for `exempt`.
8. Call out stale or unsupported `quality_scale.yaml` entries and stale hassfest exception-list entries separately from missing implementation evidence.
9. End with the smallest useful next step: `$ha-quality-improve`, `$ha-tests`, `$ha-coverage`, `$ha-docs`, `$ha-library`, `$ha-integration`, or no follow-up.

## Report Format

Group findings by tier and use checklist rows:

```text
- [status] `rule-id` - summary
  Evidence: path-or-link
  Notes: short reason, gap, or exemption
```

Use `uncertain` when the evidence requires hardware, credentials, external brands assets, or maintainer judgment that cannot be verified locally.

Include a short `Hassfest` section that states whether `script/hassfest/quality_scale.py`, `manifest.json`, and `quality_scale.yaml` agree for the integration.

## Delegation

Only when the user explicitly asks for subagents, delegation, or parallel work, split audit work by rule groups:

- Core/runtime behavior
- Config flow, authentication, setup, and unload
- Entities, devices, translations, diagnostics, and repairs
- Tests, coverage, typing, and dependency
- Documentation

Avoid one subagent per rule; evidence often overlaps.
