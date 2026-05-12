# HA Pull Requests

Use for Home Assistant Core PR writing and PR monitoring.

## Template preservation

Treat `.github/PULL_REQUEST_TEMPLATE.md` as the source template for PR bodies. Preserve every original section, checklist item, unchecked checkbox, comment, placeholder, and blank section unless the user explicitly asks for a short draft.

Add PR-specific content under the matching template headings or append notes inside the relevant section. Do not delete template text, collapse the body to a summary-only draft, or replace the template with generated prose.

When updating an existing PR body, compare against the current HA Core template if practical. If the body is missing original template content, restore the missing template structure and keep any existing user-authored PR content.

## Type of change

Home Assistant Core PRs must select exactly one valid item from `.github/PULL_REQUEST_TEMPLATE.md` under `## Type of change`:

- `Dependency upgrade`
- `Bugfix (non-breaking change which fixes an issue)`
- `New integration (thank you!)`
- `New feature (which adds functionality to an existing integration)`
- `Deprecation (breaking change to happen in the future)`
- `Breaking change (fix/feature causing existing functionality to break)`
- `Code quality improvements to existing code or addition of tests`

If multiple types appear valid, choose the dominant PR purpose or recommend splitting the PR.

## Verification handling

Use verification results to decide whether the PR is ready, but do not add a `Verification` section or list exact local commands in the PR body unless the user explicitly asks for it or the upstream template requires it.

If verification must be mentioned, keep it outcome-focused and avoid machine-specific setup details. When a check was run through a local wrapper, refer to the repo-native command instead of the local wrapper:

- `rtk uv run pytest -q tests/components/openaq` -> `uv run pytest -q tests/components/openaq`
- `rtk uv run python -m script.hassfest --integration-path homeassistant/components/openaq` -> `uv run python -m script.hassfest --integration-path homeassistant/components/openaq`
- `rtk prek run --hook-stage pre-commit` -> `prek run --hook-stage pre-commit`

## Dependency upgrades

Dependency upgrade PRs require:

- Old and new dependency versions.
- A diff between library versions, ideally a compare URL.
- A changelog, release notes, or commit history URL for the upgraded range.
- Generated file updates and verification when HA requires them, such as `requirements_all.txt`, `script.gen_requirements_all`, and `script.hassfest`.
