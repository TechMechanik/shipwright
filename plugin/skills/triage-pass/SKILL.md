---
name: triage-pass
description: Work through the needs-triage queue in batches: categorise, check each issue is agent-ready or say what's missing, assign a milestone, weight and status. Use when asked to triage the backlog or the inbox.
---

# Triage pass

Conventions: `docs/agents/triage-labels.md` and `docs/agents/issue-tracker.md`. For one issue in depth, use `/triage` (mattpocock-skills) instead; this skill is the batch sweep.

1. List the queue: `glab issue list --label needs-triage -O json`, oldest first. Batch up to 10.
2. For each issue, decide one outcome and a one-line reason:
   - **ready-for-agent**: outcome, acceptance criteria, area and verification are all present, and no product or design call remains. Add a weight.
   - **ready-for-human**: well specified but needs judgement, access or skills an agent lacks.
   - **needs-info**: write a note listing exactly what's missing, as questions the reporter can answer.
   - **idea**: worth keeping, not yet shaped.
   - **wontfix** or duplicate: note why (link the duplicate).
   Also: type label, and the milestone it fits (per the phase descriptions; don't create milestones here). Search for duplicates first (`glab issue list --search "<key words>"`).
3. **Show the batch as a table** (issue, outcome, milestone, weight, reason) and wait for the human's OK. Triage is a judgement call; don't apply it unreviewed.
4. On approval, hand the table to the `chores` agent to apply labels, milestones, weights, `status::backlog` and the needs-info notes.
5. Report the counts and anything that looked like it needs a new milestone (use `/plan-milestone`).
