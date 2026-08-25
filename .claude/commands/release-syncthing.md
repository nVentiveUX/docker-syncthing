---
description: Prepare a release bumping the bundled Syncthing version, up through opening the PR
argument-hint: [version]
---

Prepare a new release for syncthing $ARGUMENTS (if no version was given, bump to the latest upstream Syncthing release).

Follow the release flow documented in CLAUDE.md, up through opening the PR — stop there,
do not merge, run `task bump`, tag, or push tags without explicit go-ahead.

Before starting:
- If the working tree is dirty (including untracked files unrelated to the bump), report what's
  there and ask how to handle it before running the bump scripts, which refuse a dirty tree.
- Confirm what GitHub's `releases/latest` API currently returns for syncthing/syncthing, since
  scripts/bump-syncthing.sh always targets "latest" with no explicit-version argument — if it
  doesn't match the requested version, stop and report instead of proceeding.
- Compare the upstream `CurrentVersion` constant in lib/config/config.go at the target tag against
  the `version` attribute in rootfs/etc/syncthing/config.xml. If they differ, bump the config.xml
  schema version too (README.md documents this as a manual step) and note it in the PR. If they
  match, note explicitly that no schema change was needed.

Then:
1. `git switch -c release/next`
2. `task bump:syncthing`
3. Verify the resulting diff touches only Dockerfile and README.md as expected
4. Push the branch
5. Run `task preview-changelog`, take the generated `## <next version>...` block as the PR body,
   and open the PR with `gh pr create` (title: `feat(syncthing): bump to <version>`)
