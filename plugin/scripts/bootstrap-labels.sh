#!/usr/bin/env bash
# Create the process labels as group labels, so every repo in the group shares them.
# Usage: bootstrap-labels.sh <group path>
# Safe to re-run: labels that already exist are skipped.
set -euo pipefail

sep="::"
group="${1:?usage: bootstrap-labels.sh <group path>}"
group_enc="${group//\//%2F}"

create() {
  if glab api -X POST "groups/$group_enc/labels" -f name="$1" -f color="$2" -f description="$3" >/dev/null 2>&1; then
    echo "created  $1"
  else
    echo "skipped  $1 (exists or failed)"
  fi
}

# Readiness (triage roles)
create needs-triage    "#e4e669" "A maintainer needs to evaluate this"
create needs-info      "#d876e3" "Waiting on the reporter for information"
create ready-for-agent "#0e8a16" "Fully specified, ready for an AFK agent"
create ready-for-human "#1d76db" "Needs a human to implement"
create wontfix         "#7f8c8d" "Will not be actioned"
create idea            "#c5def5" "Unshaped idea: kept, not yet scoped"

# Status (board lists)
create "status${sep}backlog"     "#bfbfbf" "Board: not scheduled"
create "status${sep}next"        "#fbca04" "Board: ready and ordered for the current milestone"
create "status${sep}in-progress" "#f9a03f" "Board: someone is working on it"
create "status${sep}in-review"   "#5319e7" "Board: MR open, waiting for a human"

# Type (release-note categories)
create bug            "#d73a4a" "Something is broken"
create enhancement    "#a2eeef" "New or improved behaviour"
create security       "#b60205" "Security fix or hardening"
create dependencies   "#0366d6" "Dependency updates"
create skip-changelog "#ededed" "Leave out of release notes"
