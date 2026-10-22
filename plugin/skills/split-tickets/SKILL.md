---
name: split-tickets
description: Split a shaped spec into small, independently mergeable tickets with acceptance criteria, sizes, blocking links and an epic. Use after /shape when the work is bigger than one MR, or when filling a milestone.
---

# Split a spec into tickets

Input: an issue with a spec (from `/shape` or written by hand). Commands: the **Operations** table in `docs/agents/issue-tracker.md`.

1. **Slice vertically.** Each ticket delivers something observable end to end (a behaviour, an endpoint plus its caller, a migration plus the code that uses it), not a layer ("all the DB work"). Prefer tickets one person or agent can finish in a day or two. Infrastructure that several slices need comes first, as its own ticket.
2. **One repo per ticket.** Work that spans repos becomes one ticket per repo, linked to an epic.
3. **Order by dependency:** DB changes before the services that use them, libraries before the services that bump them, APIs before the UI. Express each as `block`.
4. **Write each ticket** with the Task template: Outcome, Acceptance criteria, Where (repo, module, files if known), How to verify, Out of scope, and `Part of #<spec issue>` at the top.
5. **Show the plan as a table** (title, repo, depends on, size, ready-for-agent or ready-for-human, one-line reason) and wait for the human's OK. Mark a ticket ready-for-agent only if it meets the bar in `triage-labels.md`.
6. **Create** them on approval (via `chores`): `create-issue`, then `link-epic`, `block`, `set-size`, `set-milestone`, readiness label, and backlog status. Add the ticket list to the spec issue.
7. Report the tickets in build order and which ones the human must pick up.
