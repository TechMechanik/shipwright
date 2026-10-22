# Repo profile: Angular

Detect: `angular.json` at the root.

## Checks

- Setup: `npm ci` (registry comes from the user's `~/.npmrc`, pointed at the {{registry.name}} npm remote).
- Typecheck + build: `npx ng build --configuration development`
- Lint: `npx ng lint`
- One spec: `npx ng test --watch=false --include <path/to/file.spec.ts>` (headless browser config from `karma.conf`/builder options)
- E2E, if present: run only the covering spec; CI runs the rest.

## Artifacts

- Tag pipeline builds `--configuration production` and publishes either the `dist/` bundle to the {{registry.name}} generic repo or an nginx image to the {{registry.name}} Docker registry. <Pick one and name the repo.>
- The API it calls is versioned by the Java/Gradle service; a UI change that needs a new endpoint is blocked by that service's issue.

## Agent limits

- Follow the existing component, state and styling patterns; don't add new UI libraries or global styles without a `ready-for-human` decision.
- Don't touch `environment.*.ts` values for shared environments.
