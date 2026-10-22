#!/usr/bin/env bash
# Create the process labels. Only creates missing ones; never edits or deletes existing labels.
# Usage:
#   bootstrap-labels.sh gitlab <group path>   group labels, shared by every repo in the group
#   bootstrap-labels.sh github <owner/repo>   repo labels (run once per repo; status lives in the Project's Status field)
set -euo pipefail

host="${1:?usage: bootstrap-labels.sh <gitlab|github> <group path | owner/repo>}"
target="${2:?usage: bootstrap-labels.sh <gitlab|github> <group path | owner/repo>}"

create() {
  local ok=""
  case "$host" in
    gitlab) glab api -X POST "groups/${target//\//%2F}/labels" -f name="$1" -f color="$2" -f description="$3" >/dev/null 2>&1 && ok=1 ;;
    github) gh label create "$1" --repo "$target" --color "${2#\#}" --description "$3" >/dev/null 2>&1 && ok=1 ;;
    *) echo "unknown host: $host" >&2; exit 2 ;;
  esac
  if [[ -n "$ok" ]]; then echo "created  $1"; else echo "skipped  $1 (exists or failed)"; fi
}

# Readiness (triage roles)
create needs-triage    "#e4e669" "A maintainer needs to evaluate this"
create needs-info      "#d876e3" "Waiting on the reporter for information"
create ready-for-agent "#0e8a16" "Fully specified, ready for an AFK agent"
create ready-for-human "#1d76db" "Needs a human to implement"
create wontfix         "#7f8c8d" "Will not be actioned"
create idea            "#c5def5" "Unshaped idea: kept, not yet scoped"

# Status (board lists): GitLab only; GitHub uses the Project's Status field
if [[ "$host" == gitlab ]]; then
  create "status::backlog"     "#bfbfbf" "Board: not scheduled"
  create "status::next"        "#fbca04" "Board: ready and ordered for the current milestone"
  create "status::in-progress" "#f9a03f" "Board: someone is working on it"
  create "status::in-review"   "#5319e7" "Board: MR open, waiting for a human"
fi

# Type (release-note categories)
create bug            "#d73a4a" "Something is broken"
create enhancement    "#a2eeef" "New or improved behaviour"
create security       "#b60205" "Security fix or hardening"
create dependencies   "#0366d6" "Dependency updates"
create skip-changelog "#ededed" "Leave out of release notes"
