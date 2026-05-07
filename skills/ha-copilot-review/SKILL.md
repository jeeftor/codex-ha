---
name: ha-copilot-review
description: Review Home Assistant Core changes against generated Copilot code review instructions before committing, pushing, or opening a PR.
metadata:
  short-description: Review HA Copilot rules
---

# HA Copilot Review

You are the Home Assistant pre-PR reviewer. Use the generated Copilot instruction files as a local review checklist before a branch is committed, pushed, or opened as a PR.

Read `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/common.md`.

## Scope

This skill checks HA Core work. It does not call GitHub Copilot and does not regenerate Copilot instruction files. It reads the generated instruction files committed in the HA Core checkout and applies them as a local review rubric for the current diff or inferred integration.

## Workflow

1. Identify the HA Core root. Run commands from that root, not from an integration subdirectory.
2. Inspect the current branch, dirty state, staged changes, and unstaged changes.
3. Read `.github/copilot-instructions.md`.
4. For changes under `homeassistant/components/**` or `tests/components/**`, also read `.github/instructions/integrations.instructions.md`.
5. If either generated instruction file is missing, report that as a review blocker and mention `python -m script.gen_copilot_instructions` as the repo command that generates them. Do not run it unless the user asks.
6. Determine the review target from staged changes, unstaged changes, branch diff, PR diff, or user prompt.
7. If the changed-file target cannot be determined reliably, infer the integration domain from the current path, prompt, `manifest.json`, or HA Assistant config. If exactly one domain is clear, review all files under `homeassistant/components/<domain>` and `tests/components/<domain>` instead of guessing a smaller target. If several domains are plausible, ask which integration to review.
8. Review the target files against the generated Copilot instructions, repo-local instructions, and the current high-value checks in `common.md`.
9. Fix only obvious issues when the user asked for PR creation or explicitly asked you to fix findings. Otherwise, report findings without editing.
10. Run focused verification for any fixes you make, or state that this was review-only.

## Output

Lead with findings, ordered by severity, using file and line references. If there are no findings, say that clearly and mention any remaining test risk.

For each finding include:

- Rule or instruction violated.
- Changed file and line.
- Why it matters for HA review.
- Smallest suggested fix.

End with one of:

- What to do next: fix the listed Copilot review findings before `$ha-pr-create`.
- What to do next: use `$ha-pr-create` after tests, hooks, and PR text are ready.
- What to do next: no HA follow-up skill is needed.
