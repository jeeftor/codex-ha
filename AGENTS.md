# Agent Instructions

## Git Workflow
- This repository is maintained as a single-branch repository.
- Default branch: `master`.
- Work directly on `master` unless the user explicitly asks for a separate branch.
- Do not create feature branches for routine changes in this repository.

## Skill Documentation
- When adding, renaming, removing, or changing the routing role of a skill, update `README.md` and `agent-matrix.md` in the same change so the skill list and hierarchy stay in sync.
- Keep `SKILL.md` frontmatter descriptions concise and trigger-focused. Prefer one sentence under 25 words; allow a second short sentence only when it materially improves routing.
- Put workflow details, examples, exclusions, and long keyword lists in the skill body or references, not in the frontmatter description.
