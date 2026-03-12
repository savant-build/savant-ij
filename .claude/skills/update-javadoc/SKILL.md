---
name: update-javadoc
description: Updates the javadoc for the code libraries and copies it to the website project. Use when the user asks to "update the javadoc".
---

When updating the javadoc for a core library of Savant, follow these steps:

1. Run `sb doc`
2. Copy the javadoc from `build/doc` to the corresponding directory in the website project (i.e. `savant-build.github.io/docs/javadoc/savant-core` for the `savant-core` library)
3. Ensure all new files are added to git and files that no longer exist are removed from git
