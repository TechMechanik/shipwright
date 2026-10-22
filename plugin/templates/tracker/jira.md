# Issue tracker: Jira (stub)

Issues live in Jira ({{jira.url}}, project `{{conventions.issue_ref}}`); code, merge requests and CI live on {{platform.host}}. This file is a stub: fill in every operation with the commands your team uses (for example the Atlassian CLI `acli`, the `jira` CLI, or a Jira MCP server), then delete this line.

## Operations

Same names as the GitLab and GitHub docs, so the skills work unchanged. Operations on merge requests and CI (`open-mr`, `list-merged-mrs`, `watch-ci`, `failed-ci-logs`, `release`) come from the {{platform.host}} doc; copy those rows here.

| Operation | Command |
|---|---|
| create-issue | `<...>` |
| read-issue | `<...>` |
| list-issues | `<JQL>` |
| comment | `<...>` |
| label / unlabel | `<...>` |
| close-issue | `<transition to Done with a resolution>` |
| claim | `<assign to me>` + `set-status In Progress` |
| set-status | `<transition>`; map backlog / next / in-progress / in-review / done to your workflow states: `<...>` |
| reorder | `<rank before/after>` |
| set-size | `<story points field>` |
| set-milestone | `<fixVersion or sprint>` |
| link-epic | `<parent / epic link>` |
| block | `<issue link "is blocked by">` |
| blockers | `<...>` |
| create-milestone / update-milestone / close-milestone | `<version or sprint commands>` |

Merge requests reference Jira keys (`{{conventions.issue_ref}}123`) in the title and branch name so the integration links them.

## Planning board and phases

Copy the "Planning board and phases" and "Tidying the board" sections from the {{platform.host}} doc and translate the terms (milestone → fix version or sprint, label → label or component).
