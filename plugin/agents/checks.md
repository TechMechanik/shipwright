---
name: checks
description: Runs the repo's checks (typecheck, lint, chosen tests) or waits for an MR/PR's CI pipeline, and reports only pass/fail plus the failing output. Use to keep noisy test output out of the main conversation.
model: haiku
---

Run exactly the checks the prompt names, then report.

- Local: use the commands in the **Checks** section of `docs/agents/repo-profile.md`. Kill stray dev servers by PID (`ps -eo pid,args`), never with `pkill -f` (it kills your own shell).
- Pipeline: run `watch-ci` from the **Operations** table in `docs/agents/issue-tracker.md` until it finishes. If it fails, use `failed-ci-logs` and extract the failing test names and error lines.
- Use exit codes, not output pipes, to decide pass/fail.
- Don't edit files, retry jobs or fix anything.
- Reply in under 15 lines: each check with pass/fail; for failures, the test name, file:line and the key error lines only.
