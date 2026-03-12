---
name: release-runtime
description: Releases the Savant Runtime to GitHub. Use when the user asks to "release the runtime".
allowed-tools: grep, curl, git, gh, jq, cd
---

When releasing the runtime for Savant Build, always run this set of checks to verify that the project is ready to be released.

1. Ensure the "Core libraries" are all on the `main` branch and up to date.
2. Ensure there are no uncommitted changes.
3. Ensure the "Core libraries" all have the same version numbers in the `build.savant` files. The version number is defined in the `project()` definition and has the format `version: "2.1.0"`. This file is Groovy, so you can use the `grep` command to find the version number.
4. Ensure no "Core libraries" have dependencies that are `integration` versions.

If #1, #2, or #3 fail, inform the user that the project is not ready to be released, and exit the skill.

If #4 fails, remove the `integration` version from all dependencies, commit, and push the changes to `main`.

Once all the checks pass, create a release by following these steps:

1. Release each project in order by running the `sb release` command and ensure it succeeds. This creates a tag in Git, so you don't need to do this manually. The tags are the same as the version number in the build files.
2. Create the bundle by running `sb clean bundle` in the `savant-core` project.
3. Create a description for the release by summarizing the changes between the last released version and the current version.
4. Display the description to the user and allow them to edit it.
5Upload the `tar.gz` and `zip` bundles in the `savant-core` project in the `build/distributions/` directory to GitHub Releases using the same version numbers as the project and the description from above.

If any of these steps fail, inform the user that the release failed.
