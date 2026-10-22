---
name: onboard-repo
description: Bring a repo (new or existing, with history, labels, milestones and open issues) onto the team process, using the team's config/team.yaml. Installs the tracker docs, repo profile, templates and CLAUDE.md rules, and adopts the existing backlog without losing anything. Use when onboarding a repo to the process.
disable-model-invocation: true
---

# Onboard a repo

Templates: `${CLAUDE_PLUGIN_ROOT}/templates`. Team answers: `${CLAUDE_PLUGIN_ROOT}/config/team.yaml`. If that file is missing, stop: the team needs `/onboard-team` first.

**Ground rules for existing repos:** never overwrite a file (merge, and show the diff), never delete or rename a label, milestone or issue without approval, and show every bulk change as a table before applying it. Work on a branch; the result is one MR that a human merges.

## 1. Inventory (read-only)

Report in under 15 lines:
- Platform matches `team.yaml` (`git remote -v`) and the CLI is logged in.
- Files already present: `CLAUDE.md`, `.claude/`, `docs/agents/`, `CONTEXT.md`, `docs/adr/`, issue/MR templates, CI config.
- Repo type: match the files against each profile's **Detect** line in `templates/profiles/`. Several can match (say, Maven + Angular in one repo); list them all.
- Tracker state: label names in use, open milestones, open issue count, open MRs, issues with no labels.

## 2. Files

- `docs/agents/issue-tracker.md` from `templates/tracker/<platform.host or tracker.system>.md`; `triage-labels.md` and `domain.md` from `templates/docs/agents/`.
- `docs/agents/repo-profile.md` from the matching profile(s); combine sections if several match. Confirm the type with the human (and for Maven, library or service image).
- Issue and MR templates for the platform (`templates/.gitlab/` or `templates/.github/`). Existing templates stay; add ours alongside under new names, and offer to merge them.
- `.claude/settings.json` from `templates/settings.<platform>.json`, merged into any existing one.
- `CLAUDE.md`: append `CLAUDE.md.snippet`; leave out "Working economically" when `agents.economy` is false. If CLAUDE.md already has rules that conflict (other tracker, other check commands), list the conflicts and ask.
- CI: never edit the existing pipeline in this MR beyond adding an `include:` the human approves. For `db-liquibase` and `webmethods`, offer the template from `templates/db/` or `templates/webmethods/` for the shared CI templates project.

**Filling tokens:** replace every `{{key}}` with the value from `team.yaml` (`{{owner_enc}}` = `platform.owner` URL-encoded; on GitHub, look up `{{board.number}}`, `{{board.id}}` and the Status and Size field and option ids with `gh project view` / `gh project field-list --format json`). Fill `<placeholders>` from the build files and CI config; ask the human for what you can't read. Never guess a command. No `{{` may remain.

## 3. Adopt the existing backlog

Skip if the repo has no issues. Otherwise, propose this as one table per step and apply on approval (via `chores`, in batches of 50):

1. **Labels.** Map existing labels to the kit's roles: readiness (`needs-triage`, `needs-info`, `ready-for-*`, `wontfix`, `idea`) and type (`bug`, `enhancement`, `security`, `dependencies`). Example: `to-do` → `needs-triage`, `feature` → `enhancement`, `blocked` → a `block` link to the blocking issue if it's known. Old labels stay; issues just gain the mapped ones. Labels with no mapping are left alone.
2. **Milestones.** For each open milestone: keep it as a phase (rename to the `{{tracker.phases.code}}NN: <goal>` form, with approval, because the whole team sees renames), or leave it as is and let new phases start alongside. Never close one here.
3. **Open issues.** Every open issue gets a status and a readiness label:
   - Issues with an open MR → `in-review`; assigned and recently updated → `in-progress`; everything else → `backlog`.
   - Issues with no mapped readiness label → `needs-triage`.
   - Big backlogs: offer an age cutoff (say, untouched for 12 months). Older issues still get `backlog` + `needs-triage`, and are listed separately so a lead can close them in bulk if they agree.
4. **Board.** If the board doesn't exist yet, give the human the exact lists/fields to create; don't create it.
5. **Labels for the group** (GitLab: first repo in a group; GitHub: every repo): run `${CLAUDE_PLUGIN_ROOT}/scripts/bootstrap-labels.sh gitlab <group>` once per group, or `... github <owner/repo>` for each GitHub repo. It only creates missing labels.

## 4. Finish

- Open the MR (`open-mr` from the new tracker doc) with the inventory, the mappings applied, and the follow-ups.
- Open follow-up issues instead of doing big conversions in this MR: Liquibase adoption for loose SQL scripts, unzipping webMethods packages into source, writing `docs/deploy.md` for manual deploys, porting CI templates to GitHub Actions when the platform is GitHub.
- Suggest `/triage-pass` next for the `needs-triage` queue, then stop.
