# Release

Agents cut releases. A person does not click the tag. The gate is the run,
not the person.

## Before the tag

- The commit's own CI run, or a later run that contains it, finished green.
  A run cancelled by the next push is not a pass. If your own run was
  cancelled, its red shows up on the next commit — that is not a green.
- `git tag` for the next free version first. Releases can be cut from more
  than one place, and two sessions will otherwise take the same number.
- Batch fixes. Do not tag every commit. A change that only adds tests does
  not get a release of its own.
- A platform claim in the notes was checked on that platform. Name the
  machine. A cross-compiled build is not that check.

## The tag

- The tag is on the integration branch, an ancestor of its remote.
- The release has every asset it promises, and is marked latest only when it
  is the highest version.
- Before naming a version to a reporter, check the assets exist. A version
  announced on an issue that was never built is a broken promise, not a
  release.

## After

- If the release publishes a package, check it resolves from the registry
  before listing it anywhere a user will install from.
- Record what was run, at which commit, in the release notes. A check that
  was not run is listed as not run.
