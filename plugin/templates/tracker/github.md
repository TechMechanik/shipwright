# Issue tracker: GitHub

Issues, pull requests, the project board and milestones live on GitHub (`{{platform.owner}}`). Use the `gh` CLI; it infers the repo from `git remote -v`. Board commands need the `project` token scope (`gh auth refresh -s project`).

## Operations

Agents and skills ask for these by name. Each is the one way to do that thing in this repo.

| Operation | Command |
|---|---|
| create-issue | `gh issue create --title "..." --body "..."` (heredoc for multi-line); then add it to the board: `gh project item-add {{board.number}} --owner {{platform.owner}} --url <issue-url>` |
| read-issue | `gh issue view <n> --comments` (`--json` for fields) |
| list-issues | `gh issue list --json number,title,labels,milestone,assignees` with `--label`, `--milestone`, `--assignee`, `--search` |
| comment | `gh issue comment <n> --body "..."` |
| label / unlabel | `gh issue edit <n> --add-label "..."` / `--remove-label "..."` |
| close-issue | `gh issue close <n> --comment "<reason>"` |
| claim | `gh issue edit <n> --add-assignee @me`, then `set-status <n> In progress` |
| set-status | Find the item id (`gh project item-list {{board.number}} --owner {{platform.owner}} --format json`, match the issue URL), then `gh project item-edit --project-id {{board.id}} --id <item> --field-id {{board.status_field}} --single-select-option-id <option>`. Options: {{board.status_options}} |
| reorder | GraphQL `updateProjectV2ItemPosition` (`gh api graphql`) with `afterId` |
| set-size | `gh project item-edit` on the Size field {{board.size_field}} ({{board.size_options}}) |
| set-milestone | `gh issue edit <n> --milestone "<title>"` |
| link-epic | Make it a sub-issue of the epic: `gh api -X POST repos/{owner}/{repo}/issues/<epic>/sub_issues -F sub_issue_id=<child database id>` (database id: `gh api repos/{owner}/{repo}/issues/<n> --jq .id`) |
| block | `gh api -X POST repos/{owner}/{repo}/issues/<n>/dependencies/blocked_by -F issue_id=<blocker database id>` |
| blockers | `gh api repos/{owner}/{repo}/issues/<n> --jq .issue_dependencies_summary.blocked_by` (open blockers) |
| open-mr | `gh pr create --title "..." --body "..." --label ... --milestone ...` with `Closes #<n>` |
| list-merged-mrs | `gh pr list --state merged --search "milestone:\"<title>\"" --json number,title,labels` |
| watch-ci | `gh pr checks <pr> --watch --fail-fast` |
| failed-ci-logs | `gh run view <run-id> --log-failed` |
| create-milestone | `gh api -X POST repos/{owner}/{repo}/milestones -f title="..." -f due_on=YYYY-MM-DDT00:00:00Z -f description="<goal, exit criteria>"` (org scope: in every repo of the product, same title) |
| update-milestone | `gh api -X PATCH repos/{owner}/{repo}/milestones/<number> -f title=... -f due_on=...` |
| close-milestone | `gh api -X PATCH repos/{owner}/{repo}/milestones/<number> -f state=closed` |
| release | Draft: `gh release create vX.Y.Z --draft --target main --generate-notes`. Publishing (`--draft=false`) is human only |

"MR" in the skills means pull request here.

## Pull requests as a triage surface

**PRs as a request surface: {{tracker.mrs_as_requests}}.** When yes, keep only PRs whose `authorAssociation` is `CONTRIBUTOR`, `FIRST_TIME_CONTRIBUTOR` or `NONE`, and run them through the same labels and states. Issues and PRs share one number space: resolve `#42` with `gh pr view 42`, falling back to `gh issue view 42`.

## When a skill says "publish to the issue tracker" / "fetch the relevant ticket"

`create-issue` / `read-issue`.

## Wayfinding operations

Used by `/wayfinder`. The **map** is one issue labelled `wayfinder:map`; **child** tickets are its sub-issues (`link-epic`) labelled `wayfinder:<research|prototype|grilling|task>`. Blocking uses `block`. The frontier is the map's open children with no open blockers and no assignee, in map order. Claim with `claim`; resolve with `comment`, `close-issue`, and a gist + link in the map's Decisions-so-far.

## Planning board and phases

The roadmap is the GitHub Project **{{tracker.board.name}}** ({{tracker.board.url}}).

- **Status** says *when*: `Backlog` → `Next` (ordered; top first) → `In progress` → `In review` (PR open, waiting for a human) → `Done`.
- **Labels** say *how ready* (`triage-labels.md`). Only `ready-for-agent` and `ready-for-human` items are started. Only {{tracker.ready_for_agent_by}} apply `ready-for-agent`.
- **Phases** are milestones coded `{{tracker.phases.code}}01: <goal>`, `{{tracker.phases.code}}02: <goal>` …, each with a rough due date and its goal and exit criteria in the description. A new phase takes a top-level code where it belongs; later codes and dates shift. Every open issue has one. **Never close a milestone to tidy up** (it starts a release); rename it instead.
- **Order:** `<{{tracker.phases.code}}01 → {{tracker.phases.code}}02 → …>`. `Next` holds the current phase's ready issues in build order; when it empties, pull in the next phase.
- **Epics** are parent issues with sub-issues. **Size** is the Size field (XS–XL).
- Starting an item is `claim`; opening its PR is `set-status In review`.

### Tidying the board

- Open issues with no milestone (except bot-managed), not on the board, or with no Status.
- `Next` empty, or holding more than one milestone.
- `In progress`/`In review` with no open PR or no assignee; closed issues not in `Done`.
- `ready-for-agent` without a Size.
- Milestones whose issues are all closed → `/close-milestone`.

## Releases

Tags `vMAJOR.MINOR.PATCH`, each with a GitHub release; cadence: {{releases.cadence}}. Closing a phase drafts the next release (`release`, draft) with notes grouped by type label (categories in `.github/release.yml`; `skip-changelog` hides one). A human edits and publishes it, which creates the tag; the tag workflow publishes to {{registry.name}} as `docs/agents/repo-profile.md` describes. Agents never publish.
