---
name: triage-pass
description: Triage one issue or the whole needs-triage queue: categorise, check against the ready-for-agent bar or say what's missing, assign milestone, size and status. Use when asked to triage an issue, the backlog or the inbox.
---

# Triage pass

Conventions: `docs/agents/triage-labels.md` and `docs/agents/issue-tracker.md`. Given an issue number, triage just that one, reading its comments and the code it mentions; otherwise sweep the queue.

Commands: the **Operations** table in `docs/agents/issue-tracker.md`.

1. List the queue: `list-issues` with label `needs-triage`, oldest first (plus outside MRs/PRs when the tracker doc says they're triaged). Batch up to 10.
2. For each issue, decide one outcome and a one-line reason:
   - **ready-for-agent**: outcome, acceptance criteria, area and verification are all present, and no product or design call remains. Add a size.
   - **ready-for-human**: well specified but needs judgement, access or skills an agent lacks.
   - **needs-info**: write a note listing exactly what's missing, as questions the reporter can answer.
   - **idea**: worth keeping, not yet shaped (`/shape` later).
   - **wontfix** or duplicate: note why (link the duplicate).
   Also: type label, and the milestone it fits (per the phase descriptions; don't create milestones here). Search for duplicates first (`list-issues` with a search).
3. **Show the batch as a table** (issue, outcome, milestone, size, reason) and wait for the human's OK. Triage is a judgement call; don't apply it unreviewed.
4. On approval, hand the table to the `chores` agent to apply labels, milestones, sizes, the backlog status and the needs-info notes.
5. Report the counts and anything that looked like it needs a new milestone (use `/plan-milestone`).
