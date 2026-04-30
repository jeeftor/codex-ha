# HA Pull Requests

Use for Home Assistant Core PR writing and PR monitoring.

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

## Dependency upgrades

Dependency upgrade PRs require:

- Old and new dependency versions.
- A diff between library versions, ideally a compare URL.
- A changelog, release notes, or commit history URL for the upgraded range.
- Generated file updates and verification when HA requires them, such as `requirements_all.txt`, `script.gen_requirements_all`, and `script.hassfest`.
