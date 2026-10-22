# Repo profile: Gradle microservice (builds an image)

Detect: `build.gradle` (use the wrapper, `./gradlew`).

## Checks

- Setup: Gradle resolves through Artifactory, configured in `~/.gradle/gradle.properties` / `init.d`, never in the repo with credentials.
- Compile: `./gradlew assemble`
- Lint/format, if configured: `<./gradlew spotlessCheck | checkstyleMain | none>`
- One test class: `./gradlew test --tests '<fully.qualified.ClassTest>'`
- `./gradlew check` / `build` is the full suite; CI runs it.
- The image is built in CI only; agents don't build or push it.

## Artifacts

- Tag pipeline runs `<the image task: jib | bootBuildImage | docker plugin task>` and pushes `<registry>/<service>:<version>` to the Artifactory Docker registry; container scanning runs on it.
- Shared code comes from the Maven library repos. A service change that needs a library change is **blocked by** that library's issue and bumps the version after the library releases.
- A service change that needs a DB change is **blocked by** the DB repo's issue; the DB change deploys first.

## Agent limits

- Don't upgrade Gradle, plugins, base images or dependency versions as a side effect; that's its own issue.
- Never use `SNAPSHOT` dependencies on the default branch.
- API changes other services or the Angular UI call: keep them backward-compatible, or the MR names the consumers and their blocked issues.
