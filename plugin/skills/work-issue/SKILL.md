---
name: work-issue
description: Orchestrate one issue end to end: claim it, shape a plan, delegate implementation to the implementer agent, verify with checks, open the MR, and hand off. Use when asked to work an issue, or to "take the next one" from the board.
---

# Work one issue

One issue per conversation. Commands: the **Operations** table in `docs/agents/issue-tracker.md`; check, build and agent limits: `docs/agents/repo-profile.md`.

1. **Pick.** If no issue is named, take the top unassigned, unblocked issue (`blockers`) in the Next list. It must be `ready-for-agent` (or `ready-for-human` with the human driving). Otherwise stop and say why.
2. **Claim.** `claim` (first write). Branch from the default branch, named per the CLAUDE.md conventions.
3. **Shape.** Read the issue and notes, `CONTEXT.md`, and ADRs touching the area. Read only the code you need. Write a plan: files, functions, behaviour, tests to add, checks to run. If a real product or design question appears, ask it now rather than guessing; if it's big, set `needs-info` with the question and stop.
4. **Build.** Small edits: inline. Otherwise hand the plan to the `implementer` agent. Review its diff yourself against the issue's acceptance criteria.
5. **Verify.** The profile's checks and the covering tests, gated on exit codes (inline, or via `checks` if the output is noisy).
6. **MR.** Within the autonomy CLAUDE.md allows: commit, push, `open-mr` using the repo's MR/PR template with `Closes #<n>` and the issue's labels and milestone, then `set-status` in review. If agents may only push branches or work locally, stop at that point and hand the human the MR text.
7. **CI once.** Have `checks` run `watch-ci`. Fix real failures; report flaky ones rather than retrying in a loop.
8. **Hand off** in two or three lines: the MR, what's left for the reviewer, and what's next on the board. Then stop.
