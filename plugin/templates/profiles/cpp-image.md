# Repo profile: C++ (builds an image)

Detect: `CMakeLists.txt` (adjust the commands below if the build is Make, Bazel or something else).

## Checks

- Setup: no package manager. Dependencies are <vendored in the repo | installed in the builder image>. Adding or upgrading one is its own `ready-for-human` issue, never a side effect.
- Configure + build: `cmake --preset <dev>` (or `cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug`), then `cmake --build build -j`
- Format: `clang-format --dry-run -Werror <changed files>`
- Static analysis, if configured: `clang-tidy -p build <changed files>`
- One test: `ctest --test-dir build -R <test name> --output-on-failure`
- The image itself is built in CI; agents don't need Docker locally. If the build only works inside the builder image, run the checks there: `docker run --rm -v "$PWD":/src -w /src {{registry.docker}}/<builder image> <command>`.

## Artifacts

- Tag pipeline builds the multi-stage image and pushes it to the {{registry.name}} Docker registry as `{{registry.docker}}/<name>:<version>`; container scanning runs on it.

## Agent limits

- Don't change compiler flags, toolchain or base images as a side effect; that's its own issue.
- Memory/ownership and threading changes get a `ready-for-human` review note in the MR even when an agent wrote them.
