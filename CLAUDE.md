# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the **primary working directory** for developing the Savant Build System. It is an IntelliJ IDEA multi-module workspace (`savant.ipr`) that aggregates all Savant sub-projects. Features and bug fixes often span multiple sub-projects, so Claude Code should be run from this directory (`savant-ij`) to enable cross-repo work.

All sub-projects are cloned as sibling directories under `/Users/bpontarelli/dev/os/savant/`. Source code lives in those sibling repos, not in this repo.

## Build System

Savant is its own build system. The CLI command is `sb`, and each sub-project has a `build.savant` file (Groovy DSL).

```bash
sb compile          # Compile sources
sb test             # Run all tests (depends on jar)
sb test --test=SomeTestClass  # Run a single test class
sb jar              # Build JAR (depends on compile)
sb clean            # Clean build output
sb int              # Publish integration build to local cache (depends on test)
sb release          # Full release (depends on clean + test)
sb idea             # Regenerate IntelliJ .iml module file
```

To build a sub-project, `cd` into its directory first (e.g., `cd ../savant-core && sb test`).

Java 17 is required. Test framework is TestNG.

## Sub-Project Layout

**Core libraries** and **plugins** are versioned and released independently. The core Savant runtime can be updated without releasing all plugins, and vice versa.

**Core libraries** (Java, use `java` plugin) — all share the same version number and are branched/released together:
- `savant-version` — Semantic version parsing (no deps on other Savant libs)
- `savant-utils` — Shared utilities
- `savant-io` — I/O utilities
- `savant-dependency-management` — Dependency resolution engine
- `savant-core` — Build runtime, Groovy script engine

**Plugins** (Groovy, use `groovy` plugin — source in `src/main/groovy`) — each versioned and released independently:
- `dependency-plugin`, `file-plugin`, `java-plugin`, `groovy-plugin`, `java-testng-plugin`, `groovy-testng-plugin`, `idea-plugin`, `release-git-plugin`, `database-plugin`, `deb-plugin`, `tomcat-plugin`, `webapp-plugin`, `pom-plugin`, `linter-plugin`, `kotlin-plugin`, `license-plugin`, `jarjar-plugin`

## Branching and Versioning Workflow

**Core libraries** must use the **same branch name** across all core repos for a given bug fix or feature, and all core project versions must match.

When starting work:
- **Bug fix:** Assume the next **patch** version (e.g., `2.0.2` → `2.0.3`). Bump the version in `build.savant` across all core projects.
- **New feature:** Assume the next **minor** version (e.g., `2.0.2` → `2.1.0`). Bump the version in `build.savant` across all core projects.

Create the same branch name in every core repo that needs changes, bump all versions to match, then use `sb int` up the dependency chain to propagate.

## Dependency Chain

Changes to lower-level libraries require integration builds (`sb int`) before downstream projects can pick them up:

```
savant-version (leaf)
    ↓
savant-utils
    ↓
savant-io, savant-dependency-management
    ↓
savant-core
    ↓
plugins (dependency-plugin, file-plugin, java-plugin, etc.)
```

After modifying a library, bump its version in `build.savant`, run `sb int`, then update the dependency version in downstream `build.savant` files (use `{integration}` suffix, e.g., `2.1.0-{integration}`). Also update `idea.settings.moduleMap` entries if present.

## Key Savant Concepts

- **Plugins** are Groovy objects loaded via `loadPlugin()` — they expose methods you call inside targets, they do not define targets themselves
- **Semantic versioning** is enforced for all projects, plugins, and dependencies — every version must conform to semver (http://semver.org). Savant will reject non-semantic versions. Integration builds append `{integration}` suffix (e.g., `1.0.8-{integration}`). When bumping versions: patch for bug fixes, minor for new features, major for breaking API changes
- **Local cache:** `~/.savant/cache`
- **Plugin config:** `~/.savant/plugins/` (e.g., Java JDK paths in `org.savantbuild.plugin.java.properties`)
- **Standard project layout:** `src/main/java` (or `src/main/groovy`), `src/test/java`, `build/classes/`, `build/jars/`

## Code Style

Never delete existing comments when modifying code. If method signatures change, update comment parameters accordingly rather than removing comments.

## Files in This Repo

- `savant.ipr` — IntelliJ project file (all modules, compiler settings, code style)
- `savant.yaml` — Declares all sub-projects with Git clone URLs
- `setup.sh` — Clones all sub-project repos (run once for initial setup)
- `update.sh` — Runs `git pull` on all sub-project directories
- `release-int.sh` / `release-final.sh` — Batch integration/final release scripts
