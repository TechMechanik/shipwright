---
name: tidy-board
description: Check the board and milestones for drift (missing milestones or status, stale in-progress items, mixed Next list, unweighted ready issues, finished milestones) and fix it. Use after merges, before planning, or when asked to tidy up.
---

# Tidy the board

Run every check in "Tidying the board" in `docs/agents/issue-tracker.md`. Delegate the queries and the fixes to `chores`; ask it for a compact list of findings, not raw JSON.

- Mechanical fixes (status after a merge, a missing status label, an issue in review whose MR merged): apply them.
- Judgement fixes (which milestone an issue belongs to, a stale `in-progress` item someone may still own, a weight): list them for the human with a proposed answer.
- A milestone whose issues are all closed: run `/close-milestone`.

Reply with what was fixed and what needs a decision, in under 15 lines.
