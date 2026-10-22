# Issue tracker: GitLab

Issues, merge requests, the board and milestones live on GitLab ({{platform.url}}). Use the [`glab`](https://gitlab.com/gitlab-org/cli) CLI; it infers the project from `git remote -v`. In `glab api` paths, `:id` is the current project and `{{owner_enc}}` is the URL-encoded group path `{{platform.owner}}`.

## Operations

Agents and skills ask for these by name. Each is the one way to do that thing in this repo.

| Operation | Command |
|---|---|
| create-issue | `glab issue create --title "..." --description "..."` (heredoc for multi-line) |
| read-issue | `glab issue view <n> --comments` (`-F json` for fields) |
| list-issues | `glab issue list -O json` with `--label`, `--milestone`, `--assignee`, `--search` |
| comment | `glab issue note <n> --message "..."` |
| label / unlabel | `glab issue update <n> --label "..."` / `--unlabel "..."` |
| close-issue | `comment` with the reason, then `glab issue close <n>` |
| claim | `glab issue update <n> --assignee @me`, then `set-status <n> in-progress` |
| set-status | `glab issue update <n> --label "status::<backlog\|next\|in-progress\|in-review>"` (scoped: replaces the old one) |
| reorder | `glab api -X PUT "projects/:id/issues/<iid>/reorder" -f move_after_id=<global id>` (global `id` from `read-issue -F json`) |
| set-size | `glab issue update <n> --weight <1\|2\|3\|5\|8>` |
| set-milestone | `glab issue update <n> --milestone "<title>"` |
| link-epic | `glab issue note <n> --message "/epic &<epic>"` |
| block | `glab issue note <n> --message "/blocked_by #<blocker>"` (other repo: `group/project#<n>`) |
| blockers | `glab api "projects/:id/issues/<iid>/links"` (open `is_blocked_by` links) |
| open-mr | `glab mr create --title "..." --description "..." --label ... --milestone ...` with `Closes #<n>` |
| list-merged-mrs | `glab mr list --milestone "<title>" --merged -O json` |
| watch-ci | `glab ci status --live --branch <branch>` |
| failed-ci-logs | `glab ci get --branch <branch> -F json` for failed jobs, then `glab ci trace <job-id>` |
| create-milestone | `glab api -X POST "groups/{{owner_enc}}/milestones" -f title="..." -f due_date=YYYY-MM-DD -f description="<goal, exit criteria>"` |
| update-milestone | `glab api -X PUT "groups/{{owner_enc}}/milestones/<id>" -f title=... -f due_date=...` |
| close-milestone | `glab api -X PUT "groups/{{owner_enc}}/milestones/<id>" -f state_event=close` |
| release | Human only: `glab release create vX.Y.Z --ref main --milestone "<title>" --notes-file <file>` |

(Per-repo scope: replace `groups/{{owner_enc}}` with `projects/:id`.)

## Merge requests as a triage surface

**MRs as a request surface: {{tracker.mrs_as_requests}}.** When yes, outside contributors' MRs run through the same labels and states as issues (`glab mr view|diff|note|update|close`). Issues and MRs are numbered separately: `#42` is an issue, `!42` an MR.

## When a skill says "publish to the issue tracker" / "fetch the relevant ticket"

`create-issue` / `read-issue`.

## Wayfinding operations

Used by `/wayfinder`. The **map** is one issue labelled `wayfinder:map`; **child** tickets carry `Part of #<map>` and `wayfinder:<research|prototype|grilling|task>`. Blocking uses `block`. The frontier is the map's open children with no open blockers and no assignee, in map order. Claim with `claim`; resolve with `comment`, `close-issue`, and a gist + link in the map's Decisions-so-far.

## Planning board and phases

The roadmap is the board **{{tracker.board.name}}** ({{tracker.board.url}}). Lists are the `status::` labels; labels and milestones belong to the group, so one board covers every repo.

- **Status** says *when*: `backlog` → `next` (ordered; top first) → `in-progress` → `in-review` (MR open, waiting for a human) → closed.
- **Labels** say *how ready* (`triage-labels.md`). Only `ready-for-agent` and `ready-for-human` items are started. Only {{tracker.ready_for_agent_by}} apply `ready-for-agent`.
- **Phases** are milestones coded `{{tracker.phases.code}}01: <goal>`, `{{tracker.phases.code}}02: <goal>` …, each with a rough due date (a sequence, not a promise) and its goal and exit criteria in the description. A new phase takes a top-level code where it belongs; later codes and dates shift. Every open issue has one. **Never close a milestone to tidy up** (it starts a release); rename it instead.
- **Order:** `<{{tracker.phases.code}}01 → {{tracker.phases.code}}02 → …>`. `status::next` holds the current phase's ready issues in build order; when it empties, pull in the next phase.
- **Epics** hold work spanning milestones or repos (`link-epic`). **Size** is weight 1/2/3/5/8.
- Starting an item is `claim`; opening its MR is `set-status in-review`.

### Tidying the board

- Open issues with no milestone (except bot-managed), or no `status::` label.
- `status::next` empty, or holding more than one milestone.
- `in-progress`/`in-review` with no open MR or no assignee.
- `ready-for-agent` without a weight; `Part of` issues without an epic.
- Milestones whose issues are all closed → `/close-milestone`.

## Releases

Tags `vMAJOR.MINOR.PATCH`, each with a GitLab release; cadence: {{releases.cadence}}. Closing a phase drafts its notes as a CHANGELOG MR (GitLab has no draft releases), grouped by type label (`enhancement`, `bug`, `security`, `dependencies`; `skip-changelog` hides one). A human merges the notes and runs `release`; the tag pipeline publishes to {{registry.name}} as `docs/agents/repo-profile.md` describes. Agents never release or publish.
