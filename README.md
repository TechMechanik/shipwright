# team-process: an agentic process kit for GitLab

The triage → milestone → board → work → release loop, packaged as a Claude Code plugin. It was extracted from a solo GitHub project and adapted for a team on GitLab with Artifactory.

## What's in it

| Piece | What it does |
| --- | --- |
| `plugin/agents/implementer` (Sonnet) | Builds from a written plan; runs only the covering checks |
| `plugin/agents/checks` (Haiku) | Runs checks or watches a pipeline; returns pass/fail + failing lines |
| `plugin/agents/chores` (Haiku) | Labels, milestones, weights, board order, release-notes drafts |
| `/process-setup` | Installs the templates into a repo and creates the labels |
| `/triage-pass` | Batch-triages `needs-triage`; human approves the table before it's applied |
| `/plan-milestone` | New phases (with renumbering) and filling a milestone with ordered tickets |
| `/tidy-board` | Drift check: missing milestone/status, stale in-progress, finished milestones |
| `/work-issue` | One issue end to end: claim → plan → implement → verify → MR → handoff |
| `/close-milestone` | Closes a finished milestone and drafts CHANGELOG notes; a human releases |
| `plugin/templates/` | `docs/agents/*` (the tracker contract), issue/MR templates, CLAUDE.md rules, permissions |
| `plugin/templates/profiles/` | One per repo type: Angular, Gradle, Maven, C++ image, DB (Liquibase), webMethods. Installed as `docs/agents/repo-profile.md`: checks, artifacts, agent limits |
| `plugin/templates/db/` | Liquibase changelog skeleton and a GitLab CI template (MR rollback test, SQL preview, dev → test → approved prod) |
| `plugin/templates/webmethods/` | CI template: package checks, zip → Artifactory on tags, manual record jobs so GitLab tracks what's deployed where |

The design idea: **skills and agents hold the process; each repo's `docs/agents/` holds the repo's specifics.** Generic skills (including [mattpocock-skills](https://github.com/mattpocock/skills) `/triage`, `/to-spec`, `/to-tickets`, `/wayfinder`) read `docs/agents/issue-tracker.md` to learn how to talk to the tracker, so the same skills work in every repo.

## Install

1. Push this directory to a GitLab repo, such as `tools/claude-team-process`.
2. Each developer: `/plugin marketplace add https://<gitlab-host>/tools/claude-team-process.git`, then `/plugin install team-process@team-process`. Also install `mattpocock-skills` from the official marketplace.
3. Or roll it out per repo by committing this to the repo's `.claude/settings.json`, so everyone who trusts the repo gets prompted to install it:

   ```json
   {
     "extraKnownMarketplaces": {
       "team-process": { "source": { "source": "git", "url": "https://<gitlab-host>/tools/claude-team-process.git" } }
     },
     "enabledPlugins": { "team-process@team-process": true }
   }
   ```
4. In each repo: run `/process-setup`. The first repo in a group also creates the group labels; a human then creates the **group** board (lists = the four `status::` labels). Milestones are group milestones, so one phase covers the DB, Java, Angular and webMethods repos of a product.

Prerequisites: `glab` authenticated against your instance (`glab auth login --hostname <gitlab-host>`), and package managers already pointed at Artifactory in the user config (`~/.npmrc`, `~/.m2/settings.xml`, `pip.conf`) so agents never need registry tokens.

## The loop

```
idea ──shape (/grilling, /to-spec)──▶ tickets (/to-tickets, /plan-milestone)
needs-triage ──/triage-pass──▶ ready-for-agent | ready-for-human | needs-info | wontfix
milestone M0n ──▶ status::next (ordered) ──/work-issue──▶ in-progress ──MR──▶ in-review ──merge──▶ closed
all closed ──/close-milestone──▶ CHANGELOG MR ──human──▶ glab release create ──CI──▶ Artifactory
                     /tidy-board after merges and before planning
```

## Mapping from the original (GitHub) setup

| GitHub original | GitLab here | Why |
| --- | --- | --- |
| Project board Status field | `status::*` scoped labels → board lists | GitLab boards are label-driven; scoped labels keep exactly one |
| Size field (XS–XL) | Issue weight 1/2/3/5/8 | Native, sums per milestone |
| Sub-issues, native dependencies | Group epics (`/epic &n`); `/blocked_by` links, also across repos | Cross-repo work is common here |
| Draft release from a milestone-close workflow | Draft CHANGELOG MR; human runs `glab release create --milestone` | GitLab has no draft releases or milestone-close CI trigger |
| Release categories from PR labels | Same labels on MRs, grouped by `/close-milestone` | Same notes, without a workflow |
| GHCR image | Artifactory, published by the tag pipeline only | Agents never publish |
| Cloudflare approval rule | Infra/CI-variable/Artifactory approval rule | Same "propose + rollback, then wait" gate |
| Solo "owner merges" | Assignee claims + MR approval rules | Several people and agents share the board |

## Things to decide for your team

- **Who may set `ready-for-agent`**: usually a lead or the person who triages. That label is the gate that lets an agent run AFK.
- **Model tiers**: Sonnet for implementer and Haiku for checks/chores suit a cost-conscious setup. On an enterprise plan you may want the implementer on a larger model; change the `model:` line in its frontmatter.
- **The "one issue per conversation" rule** began as a cost measure; it's also the best defence against context drift, so keep it either way.
