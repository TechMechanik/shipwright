# Shipwright

A Claude Code plugin that runs a team's delivery process with people and AI agents working side by side: onboarding interview, triage, shaping, ticket splitting, milestone planning, issue orchestration and release drafting. Works on GitLab or GitHub, with profiles for each repo type and approval gates on anything risky.

It works with any artifact registry and secrets source, and has a Jira stub. A team answers an onboarding interview once; every repo, new or existing, is then onboarded from those answers.

## How it fits together

```
Team's copy of this kit                         Each product repo
───────────────────────                         ─────────────────
/onboard-team  ─► plugin/config/team.yaml ─►  /onboard-repo ─► docs/agents/issue-tracker.md  (Operations for this platform)
(interview, once)                                               docs/agents/repo-profile.md   (checks, artifacts, agent limits)
                                                                docs/agents/triage-labels.md, domain.md
                                                                CLAUDE.md rules, issue/MR templates, permissions
                                                                existing labels, milestones and issues adopted
```

Agents and skills never hard-code a platform. They call named **operations** (`claim`, `set-status`, `open-mr`, `watch-ci`, `close-milestone` …), and each repo's `docs/agents/issue-tracker.md` maps those names to `glab` or `gh` commands.

## What's in it

| Piece | What it does |
| --- | --- |
| `/onboard-team` | Six-round interview (platform, planning, secrets and packages, delivery, agents, conventions) → `config/team.yaml`; sets agent models |
| `/onboard-repo` | Installs docs, profile, templates and rules into a repo, filling tokens from the team config; adopts the existing backlog (label mapping, milestones, status for open issues) through approved tables |
| `/triage-pass` | Triages one issue or the `needs-triage` queue against the ready-for-agent bar; a human approves before it's applied |
| `/shape` | Interviews the human one question at a time and writes a buildable spec into the issue |
| `/split-tickets` | Splits a spec into vertical-slice tickets, one repo each, with blocking links, sizes and an epic |
| `/domain-docs` | Keeps the glossary (`CONTEXT.md`) and decision records (`docs/adr/`) current |
| `/plan-milestone` | New phases (with renumbering) and filling a phase with ordered, linked tickets |
| `/tidy-board` | Drift check: missing milestone/status, stale in-progress, finished milestones |
| `/work-issue` | One issue end to end: claim → plan → implement → verify → MR/PR → handoff |
| `/close-milestone` | Closes a finished phase and drafts release notes; a human publishes |
| `implementer` (Sonnet), `checks` (Haiku), `chores` (Haiku) | Cost-tiered subagents: build from a plan; run checks or watch CI; tracker bookkeeping |
| `templates/tracker/` | GitLab, GitHub and Jira (stub) tracker docs with the Operations table |
| `templates/profiles/` | Angular, Gradle microservice, Maven, C++ image, DB (Liquibase), webMethods |
| `templates/db/`, `templates/webmethods/` | GitLab CI templates: Liquibase (Oracle/Postgres, rollback-tested, approved prod) and webMethods (checks, publish, recorded manual deploys) |
| `config/team.example.yaml`, `templates/TOKENS.md` | The config schema and how its values fill the templates |

## Adopting it

1. **Copy the kit** into a repo your team owns (fork or import), such as `tools/shipwright`.
2. **Onboard the team**: in that repo, run `/onboard-team` and commit the resulting `plugin/config/team.yaml`.
3. **Install** for each developer: `/plugin marketplace add <url of your copy>` and `/plugin install shipwright@shipwright`. Or commit this to each product repo's `.claude/settings.json` so trusting the repo prompts the install:

   ```json
   {
     "extraKnownMarketplaces": {
       "shipwright": { "source": { "source": "git", "url": "<url of your copy>.git" } }
     },
     "enabledPlugins": { "shipwright@shipwright": true }
   }
   ```
4. **Onboard repos**: run `/onboard-repo` in each. Existing repos are the normal case: it never overwrites files or deletes labels, maps what's there, and opens one MR plus follow-up issues for bigger conversions (Liquibase adoption, unzipping webMethods packages, deploy runbooks).
5. **Run the loop**: `/triage-pass` → `/shape` → `/split-tickets` → `/plan-milestone` → `/work-issue` → `/tidy-board` → `/close-milestone`.

Prerequisites: `glab` or `gh` logged in to your instance, and package managers pointed at your registry in user-level config, so agents never handle registry tokens.

## Limits

- The CI templates are GitLab CI. On GitHub, `/onboard-repo` opens an issue to port them to Actions.
- Jira gets a stub tracker doc with the operation names to fill in.
- Agents never merge, release, publish or deploy, whatever the autonomy setting.
