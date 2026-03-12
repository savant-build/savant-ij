---
name: update-groovydoc
description: Updates the groovydoc for the plugins and copies it to the website project. Use when the user asks to "update the groovydoc".
---

When updating the groovydoc for a plugin of Savant, follow these steps:

1. Run `sb doc` in the plugin directory (i.e. `database-plugin`)
2. Copy the groovydoc from `build/doc` to the corresponding directory in the website project (i.e. `docs/plugins/database/docs` for the `database-plugin` plugin)
3. Ensure all new files are added to git and files that no longer exist are removed from git
