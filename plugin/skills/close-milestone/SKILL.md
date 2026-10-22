---
name: close-milestone
description: Close a finished milestone and draft its release notes as a CHANGELOG MR, without creating the release. Use when every issue in a milestone is closed and merged.
---

# Close a milestone

1. Confirm it's finished: no open issues (`glab issue list --milestone "<title>" --state opened`) and no open MRs in it. If anything is open, stop and list it.
2. Close it via `chores` (`state_event=close`).
3. Draft notes from the MRs merged in the milestone (`glab mr list --milestone "<title>" --merged -O json`), grouped by type label: Features (`enhancement`), Fixes (`bug`), Security, Dependencies, Other. Leave out `skip-changelog`. One plain line per MR, written for the people who use the product, with `!<iid>`.
4. Pick the version: next minor since the last tag (`git describe --tags --abbrev=0`). If a draft CHANGELOG MR for that version is already open, add this milestone to it instead.
5. Open a draft MR adding the section to `CHANGELOG.md`. **Don't create the release or tag.** Tell the human the release command from the Releases section, to run after they've edited and merged the notes.
6. Suggest pulling the next milestone onto `status::next` (`/plan-milestone`), then stop for a fresh session.
