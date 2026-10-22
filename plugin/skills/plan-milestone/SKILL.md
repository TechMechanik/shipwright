---
name: plan-milestone
description: Create, reorder or re-plan milestones (phases) and fill a milestone with ordered ready tickets. Use when the human wants a new phase, a re-plan, or the next milestone pulled onto the board.
---

# Plan a milestone

Conventions: the "Planning board and milestones" section of `docs/agents/issue-tracker.md`.

## A new phase

1. Agree the goal and exit criteria with the human in two or three sentences. If the scope is fuzzy, grill it first (`/grilling` or `/to-spec`).
2. Place it in the sequence: it takes a top-level code where it belongs; later milestones shift code and due date one slot. List the renames and new dates and get approval before changing anything.
3. Create it as a group milestone (command in the tracker doc) with the goal and exit criteria in the description. Apply renames via `chores`.
4. Update the **Order** line in `docs/agents/issue-tracker.md` in the same change, so the docs stay the source of truth.

## Filling a milestone

1. Break the goal into tickets with `/to-tickets` (vertical slices, each independently mergeable). Each ticket uses the Task template and says `Part of #<epic or idea>` when it has one.
2. Mark dependencies as blocking links (`/blocked_by`), including across repos. Work that spans repos (say, a DB change plus the Java service and Angular UI that use it) gets a group epic, and one issue per repo linked to it.
3. Label each `ready-for-agent`, `ready-for-human` or `needs-info`; weight the ready ones.
4. When this milestone is current, put its ready, unblocked issues in `status::next` in build order (blockers first, then highest value), via `chores`.
5. Report the milestone, its tickets in order, and which are blocked or need info.
