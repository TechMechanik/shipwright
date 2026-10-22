---
name: process-setup
description: Install the team's agentic process into the current GitLab repo (tracker docs, triage labels, issue/MR templates, CLAUDE.md rules, label bootstrap). Use when onboarding a repo to the process.
disable-model-invocation: true
---

# Process setup

Install the process into the current repo. Templates are in `${CLAUDE_PLUGIN_ROOT}/templates`.

1. Confirm `git remote -v` points at GitLab and `glab auth status` works. Find the product's GitLab group (the board, milestones and labels live there).
2. Copy, without overwriting existing files (show a diff and ask if one exists):
   - `docs/agents/issue-tracker.md`, `triage-labels.md`, `domain.md`
   - `.gitlab/issue_templates/*`, `.gitlab/merge_request_templates/Default.md`
   - `.claude/settings.json` (merge into an existing one rather than replacing it)
3. **Repo profile.** Detect the type from the files (each profile in `templates/profiles/` has a Detect line): `angular`, `gradle`, `maven`, `cpp-image`, `db-liquibase`, `webmethods`. Confirm it with the human (and, for Maven, library or service image). For Gradle, read the image task from `build.gradle`. Copy it to `docs/agents/repo-profile.md` and fill its `<placeholders>` from the build files and `.gitlab-ci.yml`; ask for what you can't read. Don't guess commands.
   - `db-liquibase`: also copy `templates/db/db.changelog-master.yaml` to `changelog/` and offer `templates/db/liquibase.gitlab-ci.yml` for the group's shared ci-templates project. If the repo is loose scripts, open an issue for the adoption steps in the profile rather than converting it in this MR.
   - `webmethods`: offer `templates/webmethods/webmethods.gitlab-ci.yml` for the shared ci-templates project, and open a `ready-for-human` issue to write `docs/deploy.md` (the manual install runbook) with whoever deploys today.
4. Append `CLAUDE.md.snippet` to `CLAUDE.md` (create it if missing) and fill the secrets source.
5. Fill `issue-tracker.md` placeholders: group path, board name and URL, milestone order.
6. First repo in a group only: run `${CLAUDE_PLUGIN_ROOT}/scripts/bootstrap-labels.sh <group path>`, then tell the human to create the group board with lists `status::backlog`, `status::next`, `status::in-progress`, `status::in-review` (a settings change, so a human does it).
7. Open an MR with the changes; don't merge it.
