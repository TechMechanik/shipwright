# Onboarding question bank

Ask in rounds of up to four questions with AskUserQuestion. Put the detected or recommended answer first and mark it "(Recommended)". Skip a question when an earlier answer settles it (noted in **Skip if**). Each answer maps to a key in `config/team.yaml`.

Free-text values (URLs, paths, names) are asked in plain chat after the round that needs them, all at once.

## Round 1: Platform

| # | Question | Options | Key | Notes |
|---|---|---|---|---|
| 1 | Where does your code live? | GitLab · GitHub | `platform.host` | Detect from `git remote -v` if run inside a repo. |
| 2 | Which tier? | GitLab: Free · Premium · Ultimate. GitHub: Free · Team · Enterprise | `platform.tier` | Drives epics, scoped labels, weights, protected-environment approvals. |
| 3 | Where do the board, milestones and labels live? | Shared by a group/org (Recommended when a product spans repos) · Per repo | `platform.scope` | GitHub: org-level Project + per-repo milestones (GitHub has no org milestones; the kit mirrors them by title). |
| 4 | Where are issues tracked? | Same platform · Jira | `tracker.system` | Jira: the kit writes a stub tracker doc to fill in; skills still work through it. |

Then ask: instance URL, group/org path, board name and URL (or "create it later").

## Round 2: Planning

| # | Question | Options | Key | Skip if |
|---|---|---|---|---|
| 5 | How do you plan work? | Goal-based phases as milestones (Recommended) · Time-boxed sprints/iterations | `tracker.phases.style` | |
| 6 | How is effort sized? | Weight · Project field · Labels | `tracker.size` | GitLab Premium+ → weight; GitHub → project field. Ask only on GitLab Free. |
| 7 | Who may mark an issue ready-for-agent? | Leads only (Recommended) · Whoever triages | `tracker.ready_for_agent_by` | |
| 8 | Do outside contributors' MRs/PRs count as requests to triage? | No (Recommended) · Yes | `tracker.mrs_as_requests` | |

Then ask: the phase code prefix (default `M`).

## Round 3: Secrets and packages

| # | Question | Options | Key | Skip if |
|---|---|---|---|---|
| 9 | Where do pipelines get secrets? | Platform CI/CD variables · HashiCorp Vault · Cloud secret manager | `secrets.ci` | |
| 10 | Where do developers get secrets locally? | Vault CLI · Password manager CLI · Env files from a secure share | `secrets.local` | |
| 11 | Which artifact registry? | Artifactory · Nexus · Platform package registry · None | `registry.name` | |
| 12 | What does it host? (multi-select) | Docker images · Maven · npm · Generic files | `registry.kinds` | registry is None |

Then ask: Vault URL and path prefix (if Vault), registry URL and Docker host.

## Round 4: Delivery

| # | Question | Options | Key | Skip if |
|---|---|---|---|---|
| 13 | When do you release? | One release per finished phase (Recommended) · Continuously from main · Ad hoc | `releases.cadence` | |
| 14 | Where are release notes drafted? | CHANGELOG merge request · Draft platform release | `releases.notes` | GitLab (no draft releases) → CHANGELOG MR |
| 15 | How do deployments happen? | Pipelines with environments · Manual, tracked in the platform · External CD (Argo, Octopus…) | `deploy.model` | |
| 16 | Does prod need a second person's approval? | Yes (Recommended) · No | `deploy.prod_approval` | |

Then ask: environment names (default dev, test, prod).

## Round 5: Agents

| # | Question | Options | Key | Notes |
|---|---|---|---|---|
| 17 | How far may agents go on their own? | Open MRs/PRs (Recommended) · Push branches only · Local changes only | `agents.autonomy` | Agents never merge, release or deploy, whatever the answer. |
| 18 | Which Claude plan does the team use? | Pro · Max · Team · Enterprise / API | `agents.plan` | Pro/Max → economy rules on, implementer Sonnet. Team/Enterprise → ask 19. |
| 19 | Keep the token-saving rules? | Yes (Recommended) · No | `agents.economy` | One issue per conversation also limits context drift, so default yes. |
| 20 | Which changes must agents propose and wait on? (multi-select) | Infrastructure · CI/CD variables & secrets · Protected branches & settings · Registry repos · DNS/network · Access & permissions | `approvals` | Recommend all. |

Then ask (optional): model per agent, if they want to change the defaults.

## Round 6: Conventions

| # | Question | Options | Key |
|---|---|---|---|
| 21 | Commit message style? | Conventional Commits · Free-form | `conventions.commits` |
| 22 | Branch names? | `{slug}-{issue}` (Recommended) · `{type}/{issue}-{slug}` · Other | `conventions.branch` |
| 23 | Domain glossary: one for everything, or one per bounded context? | Single · Multi | `docs.contexts` |
| 24 | Which repo types do you have? (multi-select, then "Other" for the rest) | Angular · Gradle service · Maven (library or service) · C++ image · DB scripts (Liquibase) · webMethods | `repo_types` |

A repo type with no profile in `templates/profiles/`: note it, and offer to draft a profile with the human after onboarding.
