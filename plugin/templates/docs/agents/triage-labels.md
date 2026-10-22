# Triage Labels

The skills speak in terms of five canonical triage roles. This file maps those roles to the label strings in this project.

| Role (skills)      | Label in our tracker | Meaning                                  |
| ------------------ | -------------------- | ---------------------------------------- |
| `needs-triage`     | `needs-triage`       | A maintainer needs to evaluate this      |
| `needs-info`       | `needs-info`         | Waiting on the reporter for information  |
| `ready-for-agent`  | `ready-for-agent`    | Fully specified, ready for an AFK agent  |
| `ready-for-human`  | `ready-for-human`    | Needs a human to implement               |
| `wontfix`          | `wontfix`            | Will not be actioned                     |
| _(team-specific)_  | `idea`               | Unshaped idea: kept, not yet scoped      |

When a skill mentions a role, use the label from the right-hand column. Edit that column to match your vocabulary.

## How issues move

- **Ideas** (`idea`) may sit. Never build from one directly: shape it first (grill it, or `/to-spec`), write the outcome into the issue, then open ready tickets with `Part of #<idea>` and close or relabel the idea.
- **New work** from the Bug and Task templates arrives as `needs-triage`. Triage swaps that for `ready-for-agent`, `ready-for-human`, `needs-info` (with a note saying exactly what's missing) or `wontfix`.
- **ready-for-agent** means an agent can finish it without asking anything: acceptance criteria, the files or area, and how to verify are all in the issue.
- **Type** labels (`bug`, `enhancement`, `security`) sit alongside; they say what an issue is, not how ready it is.
- Bot-managed labels (dependency and security scanners) belong to their pipelines; don't triage those by hand.
