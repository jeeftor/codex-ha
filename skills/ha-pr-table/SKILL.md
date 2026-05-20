---
name: ha-pr-table
description: Summarize the authenticated user's open Home Assistant Core pull requests in a prioritized status table. Use when the user asks for an overview of their HA PRs, wants to know which PRs need attention, asks what to work on next, or wants CI, review, mergeability, draft, and blocker status across multiple PRs.
metadata:
  short-description: Prioritize open HA PRs
---

# HA PR Table

You are the Home Assistant PR table reporter. Produce a read-only portfolio overview of the user's open Home Assistant Core PRs and recommend which PRs to work on next.

Read `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/common.md` and `${CODEX_HOME:-$HOME/.codex}/ha-assistant/references/pr.md`.

## Relationship To `$ha-pr-watcher`

Use `$ha-pr-table` for many PRs: status summary, ranking, and "what should I work on next?"

Use `$ha-pr-watcher` for one PR: detailed CI failure analysis, review thread triage, maintainer feedback, and a focused action plan.

Do not run a full `$ha-pr-watcher` investigation for every PR by default. After the table, recommend `$ha-pr-watcher` for the highest-priority PR or any PR whose blocker cannot be understood from summary fields.

## Workflow

1. Identify the authenticated GitHub user with `gh api user --jq .login` unless the user names a different author.
2. List open PRs in `home-assistant/core` for that author. Include drafts unless the user asks only for ready PRs.
3. Inspect each PR for:
   - draft/open state
   - CI conclusion and failing check names
   - review decision and latest requested changes
   - unresolved review threads or maintainer questions
   - mergeability, conflicts, queue/blocking state, and branch freshness
4. Build a compact table with these columns:
   - `PR`: number and URL
   - `Title`
   - `State`: `Open` or `Draft`
   - `CI`: `Pass`, `Failing`, `Pending`, `Missing`, or `Unknown`
   - `Review`: `Approved`, `Changes requested`, `Review required`, or `Unknown`
   - `Merge`: `Mergeable`, `Mergeable, blocked`, `Conflict`, `Behind`, or `Unknown`
   - `Main blocker`: the shortest actionable blocker summary
5. After the table, add a short priority recommendation. Name the top one to three PRs and why.
6. Include the date checked.

Prefer `gh pr list`, `gh pr view`, `gh pr checks`, and `gh api graphql` when available. If GitHub auth or network is unavailable, report the blocker and do not invent status.

## Suggested Commands

Start broad:

```bash
gh pr list --repo home-assistant/core --author <login> --state open --limit 100 --json number,title,url,isDraft,mergeStateStatus,reviewDecision,statusCheckRollup,updatedAt,headRefName,baseRefName
```

For PRs that appear blocked or ambiguous, inspect details:

```bash
gh pr view <number> --repo home-assistant/core --json number,title,url,isDraft,mergeStateStatus,reviewDecision,reviews,comments,statusCheckRollup,updatedAt
gh pr checks <number> --repo home-assistant/core
```

Use GraphQL when unresolved review thread counts or mergeability details are missing from `gh pr view`.

## Delegation

Only when the user explicitly asks for subagents, delegation, or parallel work, split the open PR list into small non-overlapping PR groups. Ask each subagent to report only summary fields and blockers for its assigned PR numbers.

Keep final ranking and recommendations in the main agent so priorities are consistent. Use `$ha-pr-watcher` only for the selected PR or a PR whose blocker needs a deeper single-PR investigation.

## Priority Rules

Rank active cleanup before passive waiting:

- PRs with conflicts or stale branches that block mergeability.
- PRs with failing required CI, especially when not draft.
- PRs with requested changes or unresolved maintainer threads.
- Green PRs that only need final review or approval.
- Draft PRs, unless they are close to ready or the user asks to prioritize draft cleanup.

When priorities are close, prefer the PR with the smallest clear next action over a broad or ambiguous rewrite. Mention when a PR should be handed to `$ha-pr-watcher` for deeper follow-up.

## Output Style

Keep the response scannable. Use a table first, then a brief recommendation. Avoid long per-PR narratives unless the user asks for details.

Do not modify branches, push commits, close threads, rerun CI, or edit PR bodies from this skill.
