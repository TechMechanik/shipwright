# Issue tracker: GitLab

Issues and specs for this repo live as GitLab issues. Use the [`glab`](https://gitlab.com/gitlab-org/cli) CLI for all operations; `glab` infers the project from `git remote -v` inside a clone. In `glab api` paths, `:id` expands to the current project.

## Conventions

- **Create an issue**: `glab issue create --title "..." --description "..."`. Use a heredoc for multi-line descriptions.
- **Read an issue**: `glab issue view <n> --comments`. Use `-F json` for machine-readable output.
- **List issues**: `glab issue list -O json` with `--label`, `--milestone`, `--assignee` filters.
- **Comment**: `glab issue note <n> --message "..."`. GitLab calls comments "notes".
- **Labels**: `glab issue update <n> --label "..."` / `--unlabel "..."`.
- **Close**: post the reason with `glab issue note` first, then `glab issue close <n>` (close takes no comment).
- **Merge requests**: `glab mr create|view|diff|note|update`, the same shape as `gh pr` with `note`/`--message` for comments. Issues and MRs are numbered separately: `#42` is an issue, `!42` an MR.

## Merge requests as a triage surface

**MRs as a request surface: no.** _(Set to `yes` if this repo treats external MRs as feature requests; `/triage` reads this flag.)_

## When a skill says "publish to the issue tracker"

Create a GitLab issue.

## When a skill says "fetch the relevant ticket"

Run `glab issue view <n> --comments`.

## Wayfinding operations

Used by `/wayfinder`. The **map** is one issue labelled `wayfinder:map` with **child** issues as tickets.

- **Child ticket**: `Part of #<map>` at the top of its description; labels `wayfinder:<type>` (`research`/`prototype`/`grilling`/`task`).
- **Blocking**: native blocking links via the quick action `glab issue note <child> --message "/blocked_by #<blocker>"` (cross-project: `/blocked_by group/project#<n>`). A ticket is unblocked when every blocker is closed.
- **Frontier query**: the map's open children, minus any with an open blocker (`glab api "projects/:id/issues/<iid>/links"`) or an assignee; first in map order wins.
- **Claim**: `glab issue update <n> --assignee @me`, the session's first write.
- **Resolve**: note the answer, close, then append a gist + link to the map's Decisions-so-far.

## Planning board and milestones

The roadmap is the **group** issue board **<BOARD NAME>** (<BOARD URL>) of group `<GROUP PATH>`, so one board and one set of milestones cover every repo of the product. Its lists are labels; labels are group labels too.

- **Status** says *when*, as scoped labels (one at a time): `status::backlog` → `status::next` (ordered; top is most important) → `status::in-progress` → `status::in-review` (MR open, waiting for a human) → closed.
- **Labels** say *how ready* (see `triage-labels.md`). Don't start an item until it is `ready-for-agent` or `ready-for-human`.
- **Milestones** are phases, named with a zero-padded code so they sort in build order (`M01: <goal>`, `M02: <goal>` …), each with a rough due date (a sequence, not a promise). A new phase takes the next top-level code in its place, never a letter suffix; shift later codes and dates. Every open issue has a milestone. Work bigger than one milestone, or spread across several repos, is a group **epic**; link its issues with the quick action `/epic &<n>`. A new idea joins the phase it fits.
  - Create: `glab api -X POST "groups/<GROUP PATH url-encoded>/milestones" -f title="M03: ..." -f due_date=YYYY-MM-DD -f description="<goal, exit criteria>"`.
  - Rename or re-date: `glab api -X PUT "groups/<GROUP PATH url-encoded>/milestones/<milestone id>" -f title=... -f due_date=...`.
  - **Never close a milestone to tidy up.** Closing one starts a release (see Releases). Rename it when its purpose changes.
- **Order:** `<M01 → M02 → …; note anything that may run in parallel>`. `status::next` holds the current phase's ready issues in build order. When it empties, pull in the next phase.
- **Size** is the issue **weight** (1 XS, 2 S, 3 M, 5 L, 8 XL), a rough effort guess.
- **Claiming**: starting an item means assigning yourself and setting `status::in-progress`; opening its MR sets `status::in-review`. Put `Closes #<n>` in the MR description so the merge closes the issue.

### Tidying the board

Run this check whenever you work on the board (planning, after merges, or when asked), and fix what it finds or ask:

- Open issues with no milestone, other than bot-managed ones: `glab issue list --milestone none -O json`, then drop those labels.
- Open issues with no `status::*` label.
- `status::next` is empty or holds issues from more than one milestone.
- `status::in-progress`/`in-review` issues with no open MR, or with no assignee.
- `ready-for-agent` issues with no weight.
- Issues that say `Part of` something larger but have no epic.
- Milestones whose issues are all closed: close them (see Releases).

## Releases

Versions are tags `vMAJOR.MINOR.PATCH`, each with a GitLab release. Build artifacts and images are published to Artifactory by CI on the tag pipeline, as described in `docs/agents/repo-profile.md`; agents never publish to Artifactory.

- **Minor**: one per release, covering every milestone finished since the last. When a milestone closes, draft notes from the MRs merged in it, grouped by type label (`enhancement`, `bug`, `security`, `dependencies`; `skip-changelog` hides one), and leave them as a draft MR updating `CHANGELOG.md`. GitLab has no draft releases, so the draft lives in that MR.
- A human reviews the notes, merges, and creates the release: `glab release create vX.Y.0 --ref main --milestone "<title>" --notes-file <notes>`. That creates the tag and runs the publish pipeline.
- **Patch**: a fix shipped on its own, same flow, by a human.
- Label MRs like their issues so the notes sort correctly.
