---
name: close-milestone
description: Close a finished milestone and draft its release notes (CHANGELOG MR or draft release, per the tracker doc), without publishing the release. Use when every issue in a milestone is closed and merged.
---

# Close a milestone

Commands: the **Operations** table in `docs/agents/issue-tracker.md`.

1. Confirm it's finished: no open issues (`list-issues` for the milestone) and no open MRs/PRs in it. If anything is open, stop and list it.
2. Close it via `chores` (`close-milestone`).
3. Draft notes from the MRs merged in the milestone (`list-merged-mrs`), grouped by type label: Features (`enhancement`), Fixes (`bug`), Security, Dependencies, Other. Leave out `skip-changelog`. One plain line per MR, written for the people who use the product, with its MR/PR reference.
4. Pick the version: next minor since the last tag (`git describe --tags --abbrev=0`). If a draft CHANGELOG MR for that version is already open, add this milestone to it instead.
5. Draft the notes the way the tracker doc's Releases section says: a draft MR adding the section to `CHANGELOG.md` (GitLab), or a draft release (`release`, draft only, on GitHub). **Never publish the release or push a tag.** Tell the human what's left for them.
6. Suggest pulling the next milestone onto the Next list (`/plan-milestone`), then stop for a fresh session.
