---
name: work-issue
description: Orchestrate one issue end to end: claim it, shape a plan, delegate implementation to the implementer agent, verify with checks, open the MR, and hand off. Use when asked to work an issue, or to "take the next one" from the board.
---

# Work one issue

One issue per conversation. Conventions: `docs/agents/issue-tracker.md`.

1. **Pick.** If no issue is named, take the top unassigned, unblocked issue in `status::next`. It must be `ready-for-agent` (or `ready-for-human` with the human driving). Otherwise stop and say why.
2. **Claim.** Assign yourself and set `status::in-progress` (first write). Branch from the default branch: `<short-name>-<iid>`.
3. **Shape.** Read the issue and notes, `CONTEXT.md`, and ADRs touching the area. Read only the code you need. Write a plan: files, functions, behaviour, tests to add, checks to run. If a real product or design question appears, ask it now rather than guessing; if it's big, set `needs-info` with the question and stop.
4. **Build.** Small edits: inline. Otherwise hand the plan to the `implementer` agent. Review its diff yourself against the issue's acceptance criteria.
5. **Verify.** Typecheck, lint and the covering tests, gated on exit codes (inline, or via `checks` if the output is noisy).
6. **MR.** Commit, push, `glab mr create` using the Default template with `Closes #<iid>` and the issue's labels and milestone. Set `status::in-review`.
7. **CI once.** Have `checks` watch the pipeline. Fix real failures; report flaky ones rather than retrying in a loop.
8. **Hand off** in two or three lines: the MR, what's left for the reviewer, and what's next on the board. Then stop.
