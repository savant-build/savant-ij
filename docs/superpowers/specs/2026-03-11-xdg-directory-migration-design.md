# XDG Base Directory Migration

## Overview

Migrate Savant from using `~/.savant/` for all configuration and caching to standard XDG Base Directory locations. This is a minor version bump (not major) because auto-migration preserves backward compatibility.

## Current State

All Savant data lives under `~/.savant/` with three categories:

- **Cache** (`~/.savant/cache/`) — downloaded dependency artifacts
- **Plugin config** (`~/.savant/plugins/`) — per-plugin `.properties` files (e.g., JDK paths)
- **Global config** (`~/.savant/config.properties`) — repository credentials, test settings

Paths are hardcoded via `System.getProperty("user.home") + "/.savant/..."` in:

- `WorkflowDelegate.java` (savant-core) — `defaultSavantDir` static field
- `Project.java` (savant-core) — `pluginConfigurationDirectory` field
- `GlobalConfiguration.java` (savant-core) — config file path in constructor

There are no existing environment variable overrides.

## XDG Directory Mapping

| Data | XDG Variable | Default | Savant Path |
|------|-------------|---------|-------------|
| Dependency cache | `XDG_CACHE_HOME` | `~/.cache` | `$XDG_CACHE_HOME/savant/` |
| Plugin config + global config | `XDG_CONFIG_HOME` | `~/.config` | `$XDG_CONFIG_HOME/savant/` |
| Savant installation | `XDG_DATA_HOME` | `~/.local/share` | `$XDG_DATA_HOME/savant/` |

XDG conventions are used on all platforms (including macOS) — no platform-native directory mapping.

No Savant-specific environment variables. Only the standard XDG variables are supported.

## New Class: `SavantPaths`

**Location:** `savant-utils` — `org.savantbuild.util.SavantPaths`

This is the single source of truth for all Savant directory paths. It handles XDG variable resolution and migration from `~/.savant/`.

### Path Resolution

```java
public static Path cacheDir()  // → env("XDG_CACHE_HOME", "~/.cache") + "/savant"
public static Path configDir() // → env("XDG_CONFIG_HOME", "~/.config") + "/savant"
public static Path dataDir()   // → env("XDG_DATA_HOME", "~/.local/share") + "/savant"
```

Each method reads the corresponding XDG environment variable via `System.getenv()`. If the variable is unset or empty, the XDG default is used.

### Migration Logic

Migration runs once per JVM, guarded by a static flag. It is triggered by an explicit `SavantPaths.migrate(Output output)` call early in the Savant boot sequence, before any path resolution occurs.

**Algorithm:**

1. Check if XDG directories already exist (any of cache, config)
2. **XDG dirs exist AND `~/.savant` exists** → print warning: `"WARNING: ~/.savant directory found but XDG directories already exist. ~/.savant is being ignored and can be safely removed."` — do not touch `~/.savant`
3. **XDG dirs don't exist AND `~/.savant` exists** → move contents:
   - `~/.savant/cache/` → `cacheDir()`
   - `~/.savant/plugins/` → `configDir()/plugins/`
   - `~/.savant/config.properties` → `configDir()/config.properties`
   - Only delete `~/.savant/` after **all** moves succeed
   - If any move fails mid-migration, print an error with the specific item that failed and leave remaining items in `~/.savant/`. On next run, the XDG dirs that were already created will trigger the warning path (step 2), which is acceptable — the warning message tells the user `~/.savant` can be safely removed, and they can manually move any remaining files.
   - Print: `"Migrated ~/.savant to XDG directories"`
4. **Neither exists** → no-op (fresh install)

### Testability

The class accepts an overridable home directory for testing (package-private constructor or static method accepting a base path), so tests can operate on a temp directory rather than the real home.

## Changes to Existing Classes

### `WorkflowDelegate` (savant-core)

Remove the `static final` field `defaultSavantDir` and replace all usages with inline calls to `SavantPaths.cacheDir().toString()`. This avoids the class-load-time freezing problem where a `static final` field would evaluate `SavantPaths.cacheDir()` once at class load and ignore any test overrides.

Call sites to update: `standard()`, `cache(Map)`, and `mavenCache(Map)` methods in the inner `ProcessDelegate` class.

No DSL changes. `cache()`, `standard()`, and all workflow methods continue to work identically.

### `Project` (savant-core)

Replace:
```java
public Path pluginConfigurationDirectory = Paths.get(System.getProperty("user.home") + "/.savant/plugins");
```
With:
```java
public Path pluginConfigurationDirectory = SavantPaths.configDir().resolve("plugins");
```

### `GlobalConfiguration` (savant-core)

Replace:
```java
Path configFile = Paths.get(System.getProperty("user.home"), ".savant/config.properties");
```
With:
```java
Path configFile = SavantPaths.configDir().resolve("config.properties");
```

Update both error messages (IOException catch block and `getProperty` failure) to use the dynamically resolved path from `SavantPaths.configDir().resolve("config.properties")` rather than a hardcoded string, so messages remain correct when `XDG_CONFIG_HOME` is set to a custom value.

### Migration Trigger

`SavantPaths.migrate(output)` is called early in the Savant boot sequence (main runtime entry point), before any build file parsing or path resolution occurs.

### Shell scripts

The `release-int.sh` scripts in `savant-core`, `savant-utils`, and `savant-dependency-management` (`src/main/shell/release-int.sh`) hardcode `~/.savant/cache`. These are obsolete (they reference version `0.2.0`) and should be deleted.

## Classes That Don't Change

- **`BaseGroovyPlugin` (savant-core)** — reads from `project.pluginConfigurationDirectory`, which already gets the new path from `Project`
- **`CacheProcess` (savant-dependency-management)** — receives cache directory as a constructor parameter from `WorkflowDelegate`
- **All plugins** — receive paths via the runtime, no hardcoded `.savant` references

## Version Bumps and Dependency Chain

All core libraries get a **minor version bump** with the same branch name.

**Repos requiring code changes:**
- `savant-utils` — new `SavantPaths` class
- `savant-core` — updated path references + migration trigger

**Repos requiring only version bump:**
- `savant-version`
- `savant-io`
- `savant-dependency-management`

**Build order (each step: bump version, update deps, `sb int`):**
1. `savant-version`
2. `savant-utils` (add `SavantPaths`)
3. `savant-io`
4. `savant-dependency-management`
5. `savant-core` (path changes + migration trigger)

**Plugins:** No changes needed.

## Documentation Updates

- Delete the obsolete `savant-docs.md` file.
- Update `CLAUDE.md` to reference the new XDG paths instead of `~/.savant/cache` and `~/.savant/plugins/`.
- The Savant website (`savant-build.github.io`) should be updated separately to document XDG directory usage.

## Testing

### `SavantPaths` unit tests (savant-utils)

- **XDG env var resolution:** when `XDG_CACHE_HOME` is set, `cacheDir()` uses it; when unset, falls back to `~/.cache/savant`. Same for `XDG_CONFIG_HOME` and `XDG_DATA_HOME`.
- **Migration — move scenario:** create fake `~/.savant/` in temp dir, run migration, verify files moved to XDG locations and old dir removed.
- **Migration — warning scenario:** create both XDG dirs and `~/.savant/` in temp dir, verify warning output and `~/.savant/` left alone.
- **Migration — fresh install:** neither exists, no errors.

### `GroovyBuildFileParserTest` (savant-core)

This test has assertions comparing `CacheProcess.savantDir` and `CacheProcess.integrationDir` against `System.getProperty("user.home") + "/.savant/cache"`. These assertions must be updated to expect `SavantPaths.cacheDir().toString()` instead.

### Other existing tests (savant-core, savant-dependency-management)

Tests that use custom test cache directories (e.g., `build/test/cache`) passed via constructor parameters should continue to pass without changes.
