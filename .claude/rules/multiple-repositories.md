---
---

# Multiple repositories rule

NEVER use compound commands from the `savant-ij` directory that `cd` into the other repository directories (savant-core, savant-utils, etc). 

ALWAYS `cd` into the other repository directory first and then run the commands from there. 