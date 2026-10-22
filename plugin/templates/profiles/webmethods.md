# Repo profile: webMethods Integration Server packages

Detect: `*.zip` packages with a `manifest.v3` inside, or unzipped package folders (`manifest.v3`, `ns/`, `code/`).

## Source layout

Zips in git hide every change from review: an MR shows "binary file changed". Move toward committing the **unzipped** package (`<Package>/manifest.v3`, `ns/`, `code/source/`, `config/`) and let CI build the zip. Until then, the `checks` steps below unzip into a temp folder so agents and reviewers can still read the contents.

- `ns/**/flow.xml` and `node.ndf` are written by Designer. Read them for review; **never hand-edit them**.
- Java services live in `code/source/`; those are ordinary Java and agents may edit them.
- Environment-specific values (hosts, ports, credentials, endpoint aliases) belong in Deployer variable substitution or global variables, never in the package.

## Checks

- Unpack to review: `mkdir -p /tmp/wm/<Package> && unzip -q -o <Package>.zip -d /tmp/wm/<Package>`
- Package sanity: `manifest.v3` at the zip root; its version is higher than the last released one; requirements list matches the packages it calls.
- Secrets/env scan: `grep -rniE "password|jdbc:|https?://[a-z0-9.-]+:[0-9]+" /tmp/wm/<Package>/ns /tmp/wm/<Package>/config` should find nothing environment-specific.
- Java services, if any: compile against the IS jars the build image provides (<command>).
- Tests: <WmTestSuite / ABE test command, if you use them>; otherwise CI runs them.

## Artifacts

- Tag pipeline builds the zip and uploads it to the Artifactory generic repo as `<repo>/<Package>/<version>/<Package>.zip`. That versioned zip is the only thing anyone installs.

## Deployment (manual today)

Deployment stays manual, but it gets tracked:

1. A person installs the Artifactory zip for the tag on the Integration Server, following `docs/deploy.md` (the runbook: which servers, install order across packages, post-install checks, how to roll back to the previous version).
2. They then run the pipeline's manual **record-<env>** job for that tag. It does nothing but mark the deployment on a GitLab **environment**, so the Environments page shows which version is on dev, test and prod. Protected environments with approval make prod need a second person's sign-off.
3. A package that depends on a DB change or a Java service release has its issue **blocked by** those, and the runbook names the order.

Later, the same pipeline can call Deployer or the IS admin API instead of a person; the runbook and record jobs stay.

## Agent limits

- Flow-service changes are `ready-for-human` by default: an agent can write the spec, review the unpacked diff and update docs, but a developer makes the change in Designer.
- Agents may: edit Java services, bump `manifest.v3` versions, write release notes and the deploy runbook, update CI.
- Never deploy, and never connect to an Integration Server.
