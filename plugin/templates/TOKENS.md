# Template tokens

`/onboard-repo` fills `{{...}}` tokens from `config/team.yaml`. Plain keys (`{{registry.name}}`, `{{platform.url}}`) are copied as they are. The tokens below are derived. `<...>` placeholders are per repo and come from the build files or the human, never from the team config.

| Token | Built from | Value |
|---|---|---|
| `{{owner_enc}}` | `platform.owner` | URL-encoded (`acme/integration` → `acme%2Fintegration`) |
| `{{tracker.name}}` | `tracker.system`, `platform.host` | "GitLab issues", "GitHub issues" or "Jira" |
| `{{tracker.ready_for_agent_by}}` | same key | `leads` → "leads"; `triager` → "whoever triages" |
| `{{tracker.mrs_as_requests}}` | same key | "yes" / "no" |
| `{{docs.contexts_line}}` | `docs.contexts` | single: "`CONTEXT.md` (glossary) and `docs/adr/` at the repo root." multi: "`CONTEXT-MAP.md` at the root points to one `CONTEXT.md` per context; system-wide ADRs in `docs/adr/`." |
| `{{conventions.commits_line}}` | `conventions.commits` | conventional: "Conventional Commits (`feat:`, `fix:` …)"; free: "free-form, imperative subject line" |
| `{{agents.autonomy_line}}` | `agents.autonomy` | open-mr: "commit, push branches and open MRs/PRs"; push-branch: "commit and push branches; a human opens the MR/PR"; local-only: "change and commit locally; a human pushes" |
| `{{approvals_line}}` | `approvals` | the list joined in words, e.g. "infrastructure, CI/CD variables and secrets, protected branches and settings, {{registry.name}} repositories, DNS and network, access and permissions" |
| `{{secrets.ci_line}}` | `secrets.ci`, `secrets.vault` | platform-variables: "masked, environment-scoped CI/CD variables"; vault: "Vault at <url> under <path_prefix>, through the pipeline's OIDC/JWT token"; cloud: "the cloud secret manager" |
| `{{deploy.model_line}}` | `deploy.model`, `deploy.prod_approval` | pipelines: "pipelines: merges deploy to the first environment, later ones are manual jobs" + (", prod needs a second person's approval"); manual: "the manual runbook in `docs/deploy.md`, recorded in the platform's environments"; external-cd: "the external CD tool; agents only change the deployment manifests" |
| `{{board.*}}` (GitHub) | looked up | `gh project view` / `gh project field-list`: project number and id, Status and Size field ids and option ids |

When `agents.economy` is false, drop everything from `<!-- economy:start` to `<!-- economy:end -->`; otherwise drop just the two marker lines.
