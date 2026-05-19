# Agent Matrix

These Mermaid diagrams show the current routing hierarchy for the HA skill bundle.

The primary routing diagram shows the main skill hierarchy. The follow-up diagram shows direct workflow shortcuts and cross-workflow handoffs documented in the skills.

## Primary Routing

```mermaid
flowchart LR
  subgraph Workflow
    WORKFLOW["$ha-workflow<br/>Route HA maintainer work"]
  end

  subgraph Setup
    direction TB
    INIT["$ha-init<br/>Discover and configure local repos"]
  end

  subgraph Implementation
    direction TB
    INTEGRATION["$ha-integration<br/>Maintain HA Core integrations"]
    LIBRARY["$ha-library<br/>Maintain backing Python libraries"]
    FEATURE["$ha-feature<br/>Add integration features"]
    BUGFIX["$ha-bugfix<br/>Fix integration or library bugs"]
    TESTS["$ha-tests<br/>Write focused integration tests"]
    COVERAGE["$ha-coverage<br/>Increase test coverage"]
    DOCS["$ha-docs<br/>Update integration docs"]
    SYNC["$ha-sync<br/>Rebase branches onto upstream/dev"]
  end

  subgraph Quality
    direction TB
    QUALITY["$ha-quality<br/>Route quality scale work"]
    QUALITY_AUDIT["$ha-quality-audit<br/>Audit quality scale evidence"]
    QUALITY_IMPROVE["$ha-quality-improve<br/>Close quality scale gaps"]
  end

  subgraph PullRequests["Pull Requests"]
    direction TB
    PR["$ha-pr<br/>Route PR work"]
    PR_WRITER["$ha-pr-writer<br/>Draft HA PR descriptions"]
    COPILOT["$ha-copilot-review<br/>Review against Copilot instructions"]
    PR_CREATE["$ha-pr-create<br/>Create draft PRs"]
    PR_UPDATE["$ha-pr-update<br/>Update existing PRs"]
    PR_WATCHER["$ha-pr-watcher<br/>Watch CI, comments, and reviews"]
  end

  WORKFLOW --> INIT
  WORKFLOW --> INTEGRATION
  WORKFLOW --> LIBRARY
  WORKFLOW --> FEATURE
  WORKFLOW --> BUGFIX
  WORKFLOW --> TESTS
  WORKFLOW --> COVERAGE
  WORKFLOW --> QUALITY
  WORKFLOW --> PR
  WORKFLOW --> SYNC
  WORKFLOW --> DOCS

  QUALITY --> QUALITY_AUDIT
  QUALITY --> QUALITY_IMPROVE

  PR --> PR_WRITER
  PR --> COPILOT
  PR --> PR_CREATE
  PR --> PR_UPDATE
  PR --> PR_WATCHER
```

## Shortcuts And Follow-Ups

```mermaid
flowchart LR
  subgraph Workflow
    WORKFLOW["$ha-workflow<br/>Route HA maintainer work"]
  end

  subgraph Implementation
    direction TB
    INTEGRATION["$ha-integration<br/>Maintain HA Core integrations"]
    LIBRARY["$ha-library<br/>Maintain backing Python libraries"]
    FEATURE["$ha-feature<br/>Add integration features"]
    BUGFIX["$ha-bugfix<br/>Fix integration or library bugs"]
    TESTS["$ha-tests<br/>Write focused integration tests"]
    COVERAGE["$ha-coverage<br/>Increase test coverage"]
    DOCS["$ha-docs<br/>Update integration docs"]
    SYNC["$ha-sync<br/>Rebase branches onto upstream/dev"]
  end

  subgraph Quality
    direction TB
    QUALITY["$ha-quality<br/>Route quality scale work"]
    QUALITY_IMPROVE["$ha-quality-improve<br/>Close quality scale gaps"]
  end

  subgraph PullRequests["Pull Requests"]
    direction TB
    PR_WRITER["$ha-pr-writer<br/>Draft HA PR descriptions"]
    COPILOT["$ha-copilot-review<br/>Review against Copilot instructions"]
    PR_CREATE["$ha-pr-create<br/>Create draft PRs"]
    PR_UPDATE["$ha-pr-update<br/>Update existing PRs"]
    PR_WATCHER["$ha-pr-watcher<br/>Watch CI, comments, and reviews"]
  end

  WORKFLOW -. "direct PR shortcuts" .-> PR_WRITER
  WORKFLOW -. "direct PR shortcuts" .-> PR_CREATE
  WORKFLOW -. "direct PR shortcuts" .-> PR_UPDATE
  WORKFLOW -. "direct PR shortcuts" .-> PR_WATCHER

  QUALITY -. "narrow test gaps" .-> TESTS
  QUALITY -. "coverage gaps" .-> COVERAGE
  QUALITY -. "docs gaps" .-> DOCS

  QUALITY_IMPROVE -. "uses specialist workflows" .-> TESTS
  QUALITY_IMPROVE -. "uses specialist workflows" .-> COVERAGE
  QUALITY_IMPROVE -. "uses specialist workflows" .-> DOCS
  QUALITY_IMPROVE -. "uses specialist workflows" .-> LIBRARY
  QUALITY_IMPROVE -. "uses specialist workflows" .-> INTEGRATION

  FEATURE -. "possible follow-up" .-> TESTS
  FEATURE -. "possible follow-up" .-> COVERAGE
  FEATURE -. "possible follow-up" .-> DOCS
  FEATURE -. "possible follow-up" .-> LIBRARY
  FEATURE -. "possible follow-up" .-> SYNC
  FEATURE -. "possible follow-up" .-> PR_WRITER

  BUGFIX -. "ownership may be library" .-> LIBRARY
  BUGFIX -. "regression tests" .-> TESTS
  INTEGRATION -. "docs impact" .-> DOCS
  INTEGRATION -. "test impact" .-> TESTS
  PR_WRITER -. "ready branch" .-> PR_CREATE
  PR_CREATE -. "after PR opens" .-> PR_WATCHER
  PR_UPDATE -. "after push" .-> PR_WATCHER
  COPILOT -. "ready new PR" .-> PR_CREATE
  COPILOT -. "ready existing PR" .-> PR_UPDATE
```

When adding, renaming, or removing a skill, update these diagrams and the README skill list in the same change.
