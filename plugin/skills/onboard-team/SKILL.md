---
name: onboard-team
description: Interview a team lead once to configure this process kit for their team (platform, tier, secrets, registry, planning, delivery, agent autonomy, conventions) and write config/team.yaml. Use when adopting the kit for a new team, or to change the team's answers.
disable-model-invocation: true
---

# Onboard a team

Run this in a clone of the **team's copy of this kit** (the repo that hosts the plugin), not in a product repo. The answers go into `plugin/config/team.yaml` and ship to every developer with the plugin.

1. **Start.** If `plugin/config/team.yaml` exists, load it, show a short summary, and ask which rounds to revisit; only those rounds are asked again. Otherwise start from `team.example.yaml`.
2. **Detect** what you can before asking: the git host and URL from `git remote -v`, whether `glab` or `gh` is installed and logged in, and the instance tier where an API exposes it. Offer detected values as the first, recommended option.
3. **Interview** with `questions.md`: six rounds, at most four questions each, through AskUserQuestion. Skip questions earlier answers settle. After each round, ask the round's free-text values in one plain message. Keep explanations to one line per option.
4. **Check consistency** and say so plainly when answers clash, with the fix:
   - GitLab Free with group epics, scoped labels or weights → use labels and `Part of #n` instead.
   - GitLab with `releases.notes: draft-release` → GitLab has no draft releases; use the CHANGELOG MR.
   - `deploy.prod_approval` without a tier that has protected-environment approvals (GitLab Premium+, GitHub environments with required reviewers on Team+ for private repos) → a manual job that only someone named in CODEOWNERS may approve via MR, or drop the requirement.
   - `secrets.ci: vault` on GitLab below Premium → Vault via id_tokens and the Vault CLI in the job, not the `secrets:` keyword.
5. **Write** `plugin/config/team.yaml` (same keys and comments as the example). Then apply the plugin-level answers in this repo:
   - `agents.models` → the `model:` line in `plugin/agents/*.md`.
   - `agents.economy: false` → note in the README that the "Working economically" section of the CLAUDE.md snippet will be left out.
   - Bump `version` in `plugin/.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json` (minor bump).
6. **Summarise** the config in under 20 lines, list anything left as "create it later" (such as the board), and propose a commit or MR on the kit repo. Then point to `/onboard-repo` for the first product repo, and to `scripts/bootstrap-labels.sh` for the shared labels.

Don't create boards, groups, labels, variables or protected environments during onboarding. Those are platform settings: list them as steps for a human (or, for labels, the bootstrap script the human runs).
