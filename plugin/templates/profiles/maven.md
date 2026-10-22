# Repo profile: Java (Maven)

Detect: `pom.xml` (use `./mvnw` if present).

## Checks

- Setup: Maven resolves through {{registry.name}} via the user's `~/.m2/settings.xml`, never a committed one with credentials.
- Compile: `./mvnw -B -q test-compile`
- Lint/format, if configured: `./mvnw -B checkstyle:check` or `spotless:check`
- One test class: `./mvnw -B test -Dtest=<ClassTest> -Dsurefire.failIfNoSpecifiedTests=false` (multi-module: add `-pl <module> -am`)
- `./mvnw verify` is the full suite; CI runs it.

## Artifacts

Two kinds of repo; say which this is: <library | service image>.

- **Library**: tag pipeline runs `mvn deploy` to the {{registry.name}} release repo (from `distributionManagement`). Services that need the change are separate issues, **blocked by** this one, and bump the dependency after the release.
- **Service image**: tag pipeline builds the image and pushes to the {{registry.name}} Docker registry as `{{registry.docker}}/<name>:<version>`.

## Agent limits

- Don't change parent POMs, plugin versions or dependency versions as a side effect; that's its own issue.
- Never use `SNAPSHOT` dependencies on the default branch.
