# Triage labels

Every open issue carries one readiness label. It says whether the issue can be started, and by whom.

| Label | Meaning | Next step |
| --- | --- | --- |
| `needs-triage` | New; nobody has looked at it yet | `/triage-pass` |
| `needs-info` | Can't be judged or built yet; a comment says exactly what's missing | The reporter answers, then triage again |
| `idea` | Worth keeping, not yet shaped | `/shape` when it's wanted |
| `ready-for-agent` | Fully specified; an agent can finish it unattended | `/work-issue` |
| `ready-for-human` | Specified, but needs judgement, access or skills an agent lacks | A developer picks it up |
| `wontfix` | Won't be done; a comment says why | Close it |

## The ready-for-agent bar

All of these are in the issue, and nothing is left to decide:

- the outcome, and what's out of scope
- acceptance criteria someone can check
- where the change goes (repo, module, files if known)
- how to verify it (tests to add or run, or exact manual steps)
- no open product, design, security or data-ownership question

If any is missing, it's `needs-info` (say what's missing) or `ready-for-human`.

## How issues move

- New issues from the Bug and Task templates arrive as `needs-triage`.
- Ideas are never built directly: `/shape` writes the spec, `/split-tickets` makes ready tickets that say `Part of #<idea>`, then the idea is closed.
- **Type** labels (`bug`, `enhancement`, `security`, `dependencies`) sit alongside readiness and drive release-note sections.
- Issues opened by scanners and bots keep the labels their pipelines manage; triage them only to set readiness.
