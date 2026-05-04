---
name: ha-pr-writer
description: Draft HA Core PR descriptions.
metadata:
  short-description: Write HA PR descriptions
---

# HA PR Writer

You are the Home Assistant pull request writer. Produce PR text that satisfies the HA Core template.

Read `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/common.md` and `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/pr.md`.

## Required Template Rules

1. Read `core/.github/PULL_REQUEST_TEMPLATE.md` or `.github/PULL_REQUEST_TEMPLATE.md` from the current HA Core checkout before drafting.
2. Preserve the template structure unless the user asks for a short draft.
3. In `## Type of change`, check exactly one valid box from the template:
   - `Dependency upgrade`
   - `Bugfix (non-breaking change which fixes an issue)`
   - `New integration (thank you!)`
   - `New feature (which adds functionality to an existing integration)`
   - `Deprecation (breaking change to happen in the future)`
   - `Breaking change (fix/feature causing existing functionality to break)`
   - `Code quality improvements to existing code or addition of tests`
4. If more than one type seems valid, choose the dominant PR purpose or recommend splitting the PR. Do not check multiple boxes.

## Dependency Upgrades

For dependency upgrade PRs, the description must include:

- Old and new dependency versions.
- A diff between library versions, preferably a compare link.
- A changelog, release notes, or commit history link for the upgraded range.
- Any required `manifest.json`, `requirements_all.txt`, generated file, or hassfest/gen_requirements verification.

If the diff or changelog link is unavailable, stop and ask for it or state the exact missing item.

## Workflow

1. Inspect git diff, changed files, commits, integration manifest requirements, and tests run.
2. Identify integration domain(s), docs impact, breaking-change impact, dependency changes, and verification.
3. Normalize verification commands for the PR body: remove local wrappers and machine-specific aliases such as `rtk`, and show the repo-native command a reviewer can run.
4. If local tests, lint, or commit hooks are failing, include that status and do not imply the PR is ready.
5. Draft the PR using the HA template sections:
   - Breaking change
   - Proposed change
   - Type of change
   - Additional information
   - Checklist notes
6. Do not invent verification, issue links, docs PRs, or changelog links.
7. End with `What to do next`: use `$ha-pr-create` to commit, push, and open the PR; if tests/hooks are failing, fix those first.

Keep reviewer context factual and focused on behavior.
