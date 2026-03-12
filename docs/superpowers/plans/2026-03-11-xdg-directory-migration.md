# XDG Base Directory Migration Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Migrate Savant from `~/.savant/` to XDG Base Directory locations with automatic migration.

**Architecture:** A new `SavantPaths` class in `savant-utils` centralizes XDG path resolution and migration logic. `savant-core` consumers replace hardcoded `~/.savant` paths with calls to `SavantPaths`. Migration runs automatically on first Savant invocation.

**Tech Stack:** Java 17, TestNG, Savant build system (`sb`)

---

## Chunk 1: Branch Setup and Version Bumps

### Task 1: Create branches and bump versions across all core repos

All core repos must use the same branch name and version `2.2.0`.

**Files:**
- Modify: `/Users/bpontarelli/dev/os/savant/savant-version/build.savant:16` — version `2.1.0` → `2.2.0`
- Modify: `/Users/bpontarelli/dev/os/savant/savant-utils/build.savant:16` — version `2.1.0` → `2.2.0`
- Modify: `/Users/bpontarelli/dev/os/savant/savant-io/build.savant:16` — version `2.1.0` → `2.2.0`
- Modify: `/Users/bpontarelli/dev/os/savant/savant-dependency-management/build.savant:16-17` — `savantVersion` and project version `2.1.0` → `2.2.0`
- Modify: `/Users/bpontarelli/dev/os/savant/savant-core/build.savant:16-17` — `savantVersion` and project version `2.1.0` → `2.2.0`

- [ ] **Step 1: Create branch `features/xdg-directories` in all 5 core repos**

```bash
for repo in savant-version savant-utils savant-io savant-dependency-management savant-core; do
  cd /Users/bpontarelli/dev/os/savant/$repo && git checkout -b features/xdg-directories
done
```

- [ ] **Step 2: Bump version to 2.2.0 in savant-version**

In `/Users/bpontarelli/dev/os/savant/savant-version/build.savant`, change line 16:
```groovy
# before
project(group: "org.savantbuild", name: "savant-version", version: "2.1.0", licenses: ["Apache-2.0"]) {
# after
project(group: "org.savantbuild", name: "savant-version", version: "2.2.0", licenses: ["Apache-2.0"]) {
```

- [ ] **Step 3: Build and integration-publish savant-version**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-version && sb int
```
Expected: BUILD SUCCESSFUL

- [ ] **Step 4: Commit savant-version**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-version
git add build.savant
git commit -m "Bump version to 2.2.0 for XDG directories feature"
```

- [ ] **Step 5: Bump version to 2.2.0 in savant-utils**

In `/Users/bpontarelli/dev/os/savant/savant-utils/build.savant`, change line 16:
```groovy
# before
project(group: "org.savantbuild", name: "savant-utils", version: "2.1.0", licenses: ["Apache-2.0"]) {
# after
project(group: "org.savantbuild", name: "savant-utils", version: "2.2.0", licenses: ["Apache-2.0"]) {
```

- [ ] **Step 6: Build and integration-publish savant-utils**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-utils && sb int
```
Expected: BUILD SUCCESSFUL

- [ ] **Step 7: Commit savant-utils**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-utils
git add build.savant
git commit -m "Bump version to 2.2.0 for XDG directories feature"
```

- [ ] **Step 8: Bump version to 2.2.0 in savant-io**

In `/Users/bpontarelli/dev/os/savant/savant-io/build.savant`, change line 16:
```groovy
# before
project(group: "org.savantbuild", name: "savant-io", version: "2.1.0", licenses: ["Apache-2.0"]) {
# after
project(group: "org.savantbuild", name: "savant-io", version: "2.2.0", licenses: ["Apache-2.0"]) {
```

- [ ] **Step 9: Build and integration-publish savant-io**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-io && sb int
```
Expected: BUILD SUCCESSFUL

- [ ] **Step 10: Commit savant-io**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-io
git add build.savant
git commit -m "Bump version to 2.2.0 for XDG directories feature"
```

- [ ] **Step 11: Bump version to 2.2.0 in savant-dependency-management**

In `/Users/bpontarelli/dev/os/savant/savant-dependency-management/build.savant`, change lines 16-17:
```groovy
# before
savantVersion = "2.1.0"
project(group: "org.savantbuild", name: "savant-dependency-management", version: "2.1.0", licenses: ["Apache-2.0"]) {
# after
savantVersion = "2.2.0-{integration}"
project(group: "org.savantbuild", name: "savant-dependency-management", version: "2.2.0", licenses: ["Apache-2.0"]) {
```

Note: `savantVersion` uses `{integration}` suffix because savant-utils and savant-version are not yet released — they're integration builds.

- [ ] **Step 12: Build and integration-publish savant-dependency-management**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-dependency-management && sb int
```
Expected: BUILD SUCCESSFUL

- [ ] **Step 13: Commit savant-dependency-management**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-dependency-management
git add build.savant
git commit -m "Bump version to 2.2.0 for XDG directories feature"
```

- [ ] **Step 14: Bump version to 2.2.0 in savant-core**

In `/Users/bpontarelli/dev/os/savant/savant-core/build.savant`, change lines 16-17:
```groovy
# before
savantVersion = "2.1.0"
project(group: "org.savantbuild", name: "savant-core", version: "2.1.0", licenses: ["Apache-2.0"]) {
# after
savantVersion = "2.2.0-{integration}"
project(group: "org.savantbuild", name: "savant-core", version: "2.2.0", licenses: ["Apache-2.0"]) {
```

- [ ] **Step 15: Build savant-core (compile only, tests will break later)**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-core && sb compile
```
Expected: BUILD SUCCESSFUL

- [ ] **Step 16: Commit savant-core**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-core
git add build.savant
git commit -m "Bump version to 2.2.0 for XDG directories feature"
```

---

## Chunk 2: Implement SavantPaths in savant-utils

### Task 2: Write SavantPaths tests

**Files:**
- Create: `/Users/bpontarelli/dev/os/savant/savant-utils/src/test/java/org/savantbuild/util/SavantPathsTest.java`

- [ ] **Step 1: Write the test class**

Create `/Users/bpontarelli/dev/os/savant/savant-utils/src/test/java/org/savantbuild/util/SavantPathsTest.java`:

```java
/*
 * Copyright (c) 2026, Inversoft Inc., All Rights Reserved
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific
 * language governing permissions and limitations under the License.
 */
package org.savantbuild.util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Map;

import org.savantbuild.BaseUnitTest;
import org.savantbuild.output.SystemOutOutput;
import org.testng.annotations.Test;

import static org.testng.Assert.assertEquals;
import static org.testng.Assert.assertFalse;
import static org.testng.Assert.assertTrue;

/**
 * Tests for SavantPaths XDG directory resolution and migration.
 */
public class SavantPathsTest extends BaseUnitTest {

  @Test
  public void defaultPaths() {
    Path home = Path.of("/fakehome");
    SavantPaths paths = new SavantPaths(home, Map.of());
    assertEquals(paths.cacheDir(), home.resolve(".cache/savant"));
    assertEquals(paths.configDir(), home.resolve(".config/savant"));
    assertEquals(paths.dataDir(), home.resolve(".local/share/savant"));
  }

  @Test
  public void xdgEnvironmentOverrides() {
    Path home = Path.of("/fakehome");
    Map<String, String> env = Map.of(
        "XDG_CACHE_HOME", "/custom/cache",
        "XDG_CONFIG_HOME", "/custom/config",
        "XDG_DATA_HOME", "/custom/data"
    );
    SavantPaths paths = new SavantPaths(home, env);
    assertEquals(paths.cacheDir(), Path.of("/custom/cache/savant"));
    assertEquals(paths.configDir(), Path.of("/custom/config/savant"));
    assertEquals(paths.dataDir(), Path.of("/custom/data/savant"));
  }

  @Test
  public void xdgPartialOverrides() {
    Path home = Path.of("/fakehome");
    Map<String, String> env = Map.of("XDG_CACHE_HOME", "/custom/cache");
    SavantPaths paths = new SavantPaths(home, env);
    assertEquals(paths.cacheDir(), Path.of("/custom/cache/savant"));
    assertEquals(paths.configDir(), home.resolve(".config/savant"));
    assertEquals(paths.dataDir(), home.resolve(".local/share/savant"));
  }

  @Test
  public void migrateFromDotSavant() throws IOException {
    Path tempDir = Files.createTempDirectory("savant-paths-test");
    try {
      // Set up ~/.savant structure
      Path dotSavant = tempDir.resolve(".savant");
      Files.createDirectories(dotSavant.resolve("cache/org/example"));
      Files.writeString(dotSavant.resolve("cache/org/example/artifact.jar"), "cached-artifact");
      Files.createDirectories(dotSavant.resolve("plugins"));
      Files.writeString(dotSavant.resolve("plugins/org.savantbuild.plugin.java.properties"), "javaHome=/usr/lib/jvm");
      Files.writeString(dotSavant.resolve("config.properties"), "svn.username=user");

      SavantPaths paths = new SavantPaths(tempDir, Map.of());
      SystemOutOutput output = new SystemOutOutput(false);
      paths.migrate(output);

      // Verify files moved to XDG locations
      assertTrue(Files.exists(paths.cacheDir().resolve("org/example/artifact.jar")));
      assertEquals(Files.readString(paths.cacheDir().resolve("org/example/artifact.jar")), "cached-artifact");
      assertTrue(Files.exists(paths.configDir().resolve("plugins/org.savantbuild.plugin.java.properties")));
      assertEquals(Files.readString(paths.configDir().resolve("plugins/org.savantbuild.plugin.java.properties")), "javaHome=/usr/lib/jvm");
      assertTrue(Files.exists(paths.configDir().resolve("config.properties")));
      assertEquals(Files.readString(paths.configDir().resolve("config.properties")), "svn.username=user");

      // Verify old directory is gone
      assertFalse(Files.exists(dotSavant));
    } finally {
      deleteRecursive(tempDir);
    }
  }

  @Test
  public void migrateWarningWhenBothExist() throws IOException {
    Path tempDir = Files.createTempDirectory("savant-paths-test");
    try {
      // Set up ~/.savant
      Path dotSavant = tempDir.resolve(".savant");
      Files.createDirectories(dotSavant.resolve("cache"));
      Files.writeString(dotSavant.resolve("config.properties"), "old=value");

      // Set up XDG dirs (already exist)
      SavantPaths paths = new SavantPaths(tempDir, Map.of());
      Files.createDirectories(paths.cacheDir());

      SystemOutOutput output = new SystemOutOutput(false);
      paths.migrate(output);

      // Verify ~/.savant is NOT deleted (left alone with warning)
      assertTrue(Files.exists(dotSavant));
      // Verify old config was NOT moved
      assertTrue(Files.exists(dotSavant.resolve("config.properties")));
    } finally {
      deleteRecursive(tempDir);
    }
  }

  @Test
  public void migrateFreshInstall() throws IOException {
    Path tempDir = Files.createTempDirectory("savant-paths-test");
    try {
      // Neither ~/.savant nor XDG dirs exist
      SavantPaths paths = new SavantPaths(tempDir, Map.of());
      SystemOutOutput output = new SystemOutOutput(false);
      paths.migrate(output);

      // No errors, no directories created by migration itself
      assertFalse(Files.exists(tempDir.resolve(".savant")));
    } finally {
      deleteRecursive(tempDir);
    }
  }

  @Test
  public void migratePartialDotSavant() throws IOException {
    Path tempDir = Files.createTempDirectory("savant-paths-test");
    try {
      // Set up ~/.savant with only cache (no plugins or config.properties)
      Path dotSavant = tempDir.resolve(".savant");
      Files.createDirectories(dotSavant.resolve("cache/org/example"));
      Files.writeString(dotSavant.resolve("cache/org/example/artifact.jar"), "cached");

      SavantPaths paths = new SavantPaths(tempDir, Map.of());
      SystemOutOutput output = new SystemOutOutput(false);
      paths.migrate(output);

      // Verify cache moved
      assertTrue(Files.exists(paths.cacheDir().resolve("org/example/artifact.jar")));
      // Verify old directory is gone
      assertFalse(Files.exists(dotSavant));
    } finally {
      deleteRecursive(tempDir);
    }
  }

  private void deleteRecursive(Path path) throws IOException {
    if (Files.isDirectory(path)) {
      try (var entries = Files.list(path)) {
        for (Path entry : entries.toList()) {
          deleteRecursive(entry);
        }
      }
    }
    Files.deleteIfExists(path);
  }
}
```

- [ ] **Step 2: Run the test to verify it fails**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-utils && sb test
```
Expected: FAIL — `SavantPaths` class does not exist yet

### Task 3: Implement SavantPaths

**Files:**
- Create: `/Users/bpontarelli/dev/os/savant/savant-utils/src/main/java/org/savantbuild/util/SavantPaths.java`

- [ ] **Step 1: Write the SavantPaths class**

Create `/Users/bpontarelli/dev/os/savant/savant-utils/src/main/java/org/savantbuild/util/SavantPaths.java`:

```java
/*
 * Copyright (c) 2026, Inversoft Inc., All Rights Reserved
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 * either express or implied. See the License for the specific
 * language governing permissions and limitations under the License.
 */
package org.savantbuild.util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Map;
import java.util.function.Function;

import org.savantbuild.output.Output;

/**
 * Resolves Savant directory paths using XDG Base Directory conventions and handles
 * migration from the legacy ~/.savant/ directory layout.
 *
 * <p>XDG mapping:</p>
 * <ul>
 *   <li>Cache → $XDG_CACHE_HOME/savant (default ~/.cache/savant)</li>
 *   <li>Config → $XDG_CONFIG_HOME/savant (default ~/.config/savant)</li>
 *   <li>Data → $XDG_DATA_HOME/savant (default ~/.local/share/savant)</li>
 * </ul>
 *
 * @author Brian Pontarelli
 */
public class SavantPaths {
  private static final SavantPaths defaultInstance = new SavantPaths(
      Path.of(System.getProperty("user.home")),
      System::getenv
  );

  private final Path homeDir;

  private final Function<String, String> envLookup;

  private boolean migrated;

  /**
   * Creates a SavantPaths using the real home directory and environment.
   */
  public SavantPaths() {
    this(Path.of(System.getProperty("user.home")), System::getenv);
  }

  /**
   * Creates a SavantPaths with an overridable home directory and environment map. Used for testing.
   *
   * @param homeDir The home directory to use instead of user.home.
   * @param env     A map of environment variables to use instead of System.getenv().
   */
  SavantPaths(Path homeDir, Map<String, String> env) {
    this(homeDir, env::get);
  }

  private SavantPaths(Path homeDir, Function<String, String> envLookup) {
    this.homeDir = homeDir;
    this.envLookup = envLookup;
  }

  /**
   * Returns the default singleton instance that uses the real home directory and environment.
   *
   * @return The default SavantPaths instance.
   */
  public static SavantPaths get() {
    return defaultInstance;
  }

  /**
   * @return The Savant cache directory: $XDG_CACHE_HOME/savant or ~/.cache/savant
   */
  public Path cacheDir() {
    return resolveXDG("XDG_CACHE_HOME", ".cache").resolve("savant");
  }

  /**
   * @return The Savant config directory: $XDG_CONFIG_HOME/savant or ~/.config/savant
   */
  public Path configDir() {
    return resolveXDG("XDG_CONFIG_HOME", ".config").resolve("savant");
  }

  /**
   * @return The Savant data directory: $XDG_DATA_HOME/savant or ~/.local/share/savant
   */
  public Path dataDir() {
    return resolveXDG("XDG_DATA_HOME", ".local/share").resolve("savant");
  }

  /**
   * Migrates from the legacy ~/.savant/ directory to XDG locations. This method is idempotent —
   * it only runs once per instance.
   *
   * <p>Migration rules:</p>
   * <ul>
   *   <li>If XDG dirs exist AND ~/.savant exists → warn that ~/.savant is being ignored</li>
   *   <li>If XDG dirs don't exist AND ~/.savant exists → move contents to XDG locations</li>
   *   <li>If neither exists → no-op (fresh install)</li>
   * </ul>
   *
   * @param output The output for printing migration messages.
   */
  public void migrate(Output output) {
    if (migrated) {
      return;
    }
    migrated = true;

    Path dotSavant = homeDir.resolve(".savant");
    if (!Files.exists(dotSavant)) {
      return;
    }

    boolean xdgExists = Files.exists(cacheDir()) || Files.exists(configDir());
    if (xdgExists) {
      output.warningln("~/.savant directory found but XDG directories already exist. ~/.savant is being ignored and can be safely removed.");
      return;
    }

    // Migrate contents to XDG locations
    try {
      Path dotSavantCache = dotSavant.resolve("cache");
      if (Files.exists(dotSavantCache)) {
        Files.createDirectories(cacheDir().getParent());
        Files.move(dotSavantCache, cacheDir());
      }

      Path dotSavantPlugins = dotSavant.resolve("plugins");
      if (Files.exists(dotSavantPlugins)) {
        Files.createDirectories(configDir());
        Files.move(dotSavantPlugins, configDir().resolve("plugins"));
      }

      Path dotSavantConfig = dotSavant.resolve("config.properties");
      if (Files.exists(dotSavantConfig)) {
        Files.createDirectories(configDir());
        Files.move(dotSavantConfig, configDir().resolve("config.properties"));
      }

      // Delete ~/.savant if empty (or has only empty dirs)
      deleteIfEmpty(dotSavant);

      output.infoln("Migrated ~/.savant to XDG directories");
    } catch (IOException e) {
      output.errorln("Failed to fully migrate ~/.savant to XDG directories: %s", e.getMessage());
      output.errorln("Partial migration may have occurred. Move remaining files manually and delete ~/.savant.");
    }
  }

  private void deleteIfEmpty(Path dir) throws IOException {
    if (!Files.isDirectory(dir)) {
      return;
    }
    try (var entries = Files.list(dir)) {
      for (Path entry : entries.toList()) {
        if (Files.isDirectory(entry)) {
          deleteIfEmpty(entry);
          if (Files.exists(entry)) {
            return; // Subdirectory was not empty, so neither is this one
          }
        } else {
          return; // Has a file, not empty
        }
      }
    }
    Files.delete(dir);
  }

  private Path resolveXDG(String envVar, String defaultRelative) {
    String envValue = envLookup.apply(envVar);
    if (envValue != null && !envValue.isEmpty()) {
      return Path.of(envValue);
    }
    return homeDir.resolve(defaultRelative);
  }
}
```

- [ ] **Step 2: Run the tests**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-utils && sb test
```
Expected: ALL TESTS PASS

- [ ] **Step 3: Integration-publish savant-utils**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-utils && sb int
```
Expected: BUILD SUCCESSFUL

- [ ] **Step 4: Commit**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-utils
git add src/main/java/org/savantbuild/util/SavantPaths.java src/test/java/org/savantbuild/util/SavantPathsTest.java
git commit -m "Add SavantPaths class for XDG Base Directory support"
```

---

## Chunk 3: Propagate integration builds to downstream repos

### Task 4: Rebuild downstream repos with new savant-utils

Since savant-io, savant-dependency-management, and savant-core depend on savant-utils (transitively or directly), they need to pick up the new integration build.

**Files:**
- No file changes needed — just rebuilds

- [ ] **Step 1: Rebuild and integration-publish savant-io**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-io && sb int
```
Expected: BUILD SUCCESSFUL

- [ ] **Step 2: Rebuild and integration-publish savant-dependency-management**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-dependency-management && sb int
```
Expected: BUILD SUCCESSFUL

---

## Chunk 4: Update savant-core to use SavantPaths

### Task 5: Update WorkflowDelegate

**Files:**
- Modify: `/Users/bpontarelli/dev/os/savant/savant-core/src/main/java/org/savantbuild/parser/groovy/WorkflowDelegate.java`

- [ ] **Step 1: Replace defaultSavantDir with inline SavantPaths calls**

In `/Users/bpontarelli/dev/os/savant/savant-core/src/main/java/org/savantbuild/parser/groovy/WorkflowDelegate.java`:

Add import:
```java
import org.savantbuild.util.SavantPaths;
```

Remove line 43:
```java
public static final String defaultSavantDir = System.getProperty("user.home") + "/.savant/cache";
```

Replace line 45 (the Maven default stays as-is):
```java
public static final String defaultMavenDir = System.getProperty("user.home") + "/.m2/repository";
```

In the `standard()` method (around line 116), replace `defaultSavantDir` with `SavantPaths.get().cacheDir().toString()`:
```java
public void standard() {
    String savantCache = SavantPaths.get().cacheDir().toString();
    workflow.fetchWorkflow.processes.add(new CacheProcess(output, savantCache, savantCache, defaultMavenDir));
    workflow.fetchWorkflow.processes.add(new URLProcess(output, "https://repository.savantbuild.org", null, null));
    workflow.fetchWorkflow.processes.add(new MavenProcess(output, "https://repo1.maven.org/maven2", null, null));
    workflow.publishWorkflow.processes.add(new CacheProcess(output, savantCache, savantCache, defaultMavenDir));
}
```

In the `ProcessDelegate.cache()` method (around line 144), replace `defaultSavantDir`:
```java
public void cache(Map<String, Object> attributes) {
    String dir = GroovyTools.toString(attributes, "dir");
    String intDir = GroovyTools.toString(attributes, "integrationDir");
    String mavenDir = GroovyTools.toString(attributes, "mavenDir");
    String savantCache = SavantPaths.get().cacheDir().toString();
    processes.add(new CacheProcess(output,
        dir != null ? dir : savantCache,
        intDir != null ? intDir : savantCache,
        mavenDir != null ? mavenDir : defaultMavenDir));
}
```

In the `ProcessDelegate.mavenCache()` method (around line 174), replace `defaultSavantDir`:
```java
public void mavenCache(Map<String, Object> attributes) {
    String dir = GroovyTools.toString(attributes, "dir");
    String intDir = GroovyTools.toString(attributes, "integrationDir");
    String savantCache = SavantPaths.get().cacheDir().toString();
    processes.add(new CacheProcess(output,
        null,
        intDir != null ? intDir : savantCache,
        dir != null ? dir : defaultMavenDir));
}
```

- [ ] **Step 2: Verify it compiles**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-core && sb compile
```
Expected: BUILD SUCCESSFUL

### Task 6: Update Project

**Files:**
- Modify: `/Users/bpontarelli/dev/os/savant/savant-core/src/main/java/org/savantbuild/domain/Project.java`

- [ ] **Step 1: Replace hardcoded plugin config path**

Add import:
```java
import org.savantbuild.util.SavantPaths;
```

Replace line 64:
```java
// before
public Path pluginConfigurationDirectory = Paths.get(System.getProperty("user.home") + "/.savant/plugins");
// after
public Path pluginConfigurationDirectory = SavantPaths.get().configDir().resolve("plugins");
```

- [ ] **Step 2: Verify it compiles**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-core && sb compile
```
Expected: BUILD SUCCESSFUL

### Task 7: Update GlobalConfiguration

**Files:**
- Modify: `/Users/bpontarelli/dev/os/savant/savant-core/src/main/java/org/savantbuild/parser/groovy/GlobalConfiguration.java`

- [ ] **Step 1: Replace hardcoded config file path and error messages**

Add import:
```java
import org.savantbuild.util.SavantPaths;
```

Replace the constructor (lines 39-48):
```java
public GlobalConfiguration() {
    Path configFile = SavantPaths.get().configDir().resolve("config.properties");
    if (Files.isRegularFile(configFile)) {
      try (InputStream is = Files.newInputStream(configFile)) {
        properties.load(is);
      } catch (IOException e) {
        throw new BuildFailureException("Unable to load global configuration file " + configFile, e);
      }
    }
}
```

Replace the `getProperty` method error message (lines 51-58):
```java
@Override
public Object getProperty(String property) {
    String value = properties.getProperty(property);
    if (value == null) {
      Path configFile = SavantPaths.get().configDir().resolve("config.properties");
      throw new BuildFailureException("Missing global configuration property [" + property + "]. You must define this " +
          "property in the global configuration file " + configFile);
    }
    return value;
}
```

- [ ] **Step 2: Verify it compiles**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-core && sb compile
```
Expected: BUILD SUCCESSFUL

### Task 8: Add migration trigger to Main.java

**Files:**
- Modify: `/Users/bpontarelli/dev/os/savant/savant-core/src/main/java/org/savantbuild/runtime/Main.java`

- [ ] **Step 1: Add migrate call after Output creation**

Add import:
```java
import org.savantbuild.util.SavantPaths;
```

After line 63 (after the debug enable check), add:
```java
SavantPaths.get().migrate(output);
```

So lines 57-65 become:
```java
public static void main(String... args) {
    RuntimeConfigurationParser runtimeConfigurationParser = new DefaultRuntimeConfigurationParser();
    RuntimeConfiguration runtimeConfiguration = runtimeConfigurationParser.parse(args);
    Output output = new SystemOutOutput(runtimeConfiguration.colorizeOutput);
    if (runtimeConfiguration.debug) {
      output.enableDebug();
    }

    SavantPaths.get().migrate(output);

    Path buildFile = projectDir.resolve("build.savant");
```

- [ ] **Step 2: Verify it compiles**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-core && sb compile
```
Expected: BUILD SUCCESSFUL

- [ ] **Step 3: Commit all savant-core source changes**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-core
git add src/main/java/org/savantbuild/parser/groovy/WorkflowDelegate.java \
        src/main/java/org/savantbuild/domain/Project.java \
        src/main/java/org/savantbuild/parser/groovy/GlobalConfiguration.java \
        src/main/java/org/savantbuild/runtime/Main.java
git commit -m "Use SavantPaths for XDG directory resolution in all path references"
```

### Task 9: Update GroovyBuildFileParserTest

**Files:**
- Modify: `/Users/bpontarelli/dev/os/savant/savant-core/src/test/java/org/savantbuild/parser/groovy/GroovyBuildFileParserTest.java`

- [ ] **Step 1: Update test assertions**

Add import:
```java
import org.savantbuild.util.SavantPaths;
```

Replace every occurrence of `System.getProperty("user.home") + "/.savant/cache"` in assertions with `SavantPaths.get().cacheDir().toString()`. The affected lines are 101, 102, 106, 114, 115, 118.

Line 101:
```java
// before
assertEquals(((CacheProcess) project.workflow.fetchWorkflow.processes.get(0)).savantDir, System.getProperty("user.home") + "/.savant/cache");
// after
assertEquals(((CacheProcess) project.workflow.fetchWorkflow.processes.get(0)).savantDir, SavantPaths.get().cacheDir().toString());
```

Line 102:
```java
// before
assertEquals(((CacheProcess) project.workflow.fetchWorkflow.processes.get(0)).integrationDir, System.getProperty("user.home") + "/.savant/cache");
// after
assertEquals(((CacheProcess) project.workflow.fetchWorkflow.processes.get(0)).integrationDir, SavantPaths.get().cacheDir().toString());
```

Line 106:
```java
// before
assertEquals(((CacheProcess) project.workflow.fetchWorkflow.processes.get(1)).integrationDir, System.getProperty("user.home") + "/.savant/cache");
// after
assertEquals(((CacheProcess) project.workflow.fetchWorkflow.processes.get(1)).integrationDir, SavantPaths.get().cacheDir().toString());
```

Line 114:
```java
// before
assertEquals(((CacheProcess) project.workflow.publishWorkflow.processes.get(0)).savantDir, System.getProperty("user.home") + "/.savant/cache");
// after
assertEquals(((CacheProcess) project.workflow.publishWorkflow.processes.get(0)).savantDir, SavantPaths.get().cacheDir().toString());
```

Line 115:
```java
// before
assertEquals(((CacheProcess) project.workflow.publishWorkflow.processes.get(0)).integrationDir, System.getProperty("user.home") + "/.savant/cache");
// after
assertEquals(((CacheProcess) project.workflow.publishWorkflow.processes.get(0)).integrationDir, SavantPaths.get().cacheDir().toString());
```

Line 118:
```java
// before
assertEquals(((CacheProcess) project.workflow.publishWorkflow.processes.get(1)).integrationDir, System.getProperty("user.home") + "/.savant/cache");
// after
assertEquals(((CacheProcess) project.workflow.publishWorkflow.processes.get(1)).integrationDir, SavantPaths.get().cacheDir().toString());
```

- [ ] **Step 2: Run all tests**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-core && sb test
```
Expected: ALL TESTS PASS

- [ ] **Step 3: Integration-publish savant-core**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-core && sb int
```
Expected: BUILD SUCCESSFUL

- [ ] **Step 4: Commit**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-core
git add src/test/java/org/savantbuild/parser/groovy/GroovyBuildFileParserTest.java
git commit -m "Update test assertions for XDG cache directory paths"
```

---

## Chunk 5: Cleanup and Documentation

### Task 10: Delete obsolete shell scripts

**Files:**
- Delete: `/Users/bpontarelli/dev/os/savant/savant-core/src/main/shell/release-int.sh`
- Delete: `/Users/bpontarelli/dev/os/savant/savant-utils/src/main/shell/release-int.sh`
- Delete: `/Users/bpontarelli/dev/os/savant/savant-dependency-management/src/main/shell/release-int.sh`

- [ ] **Step 1: Delete the scripts (if they exist) and commit in each repo**

These scripts may have already been removed. Only commit if `git rm` succeeds.

```bash
for repo in savant-core savant-utils savant-dependency-management; do
  cd /Users/bpontarelli/dev/os/savant/$repo
  if [ -f src/main/shell/release-int.sh ]; then
    git rm src/main/shell/release-int.sh
    git commit -m "Remove obsolete release-int.sh script"
  fi
done
```

### Task 11: Delete obsolete savant-docs.md

**Files:**
- Delete: `/Users/bpontarelli/dev/os/savant/savant-ij/savant-docs.md`

- [ ] **Step 1: Delete and commit**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-ij
git rm savant-docs.md
git commit -m "Remove obsolete savant-docs.md"
```

### Task 12: Update CLAUDE.md

**Files:**
- Modify: `/Users/bpontarelli/dev/os/savant/savant-ij/CLAUDE.md`

- [ ] **Step 1: Update path references**

Replace all `~/.savant/` references with XDG paths:

The "Key Savant Concepts" section currently says:
```
- **Local cache:** `~/.savant/cache`
- **Plugin config:** `~/.savant/plugins/` (e.g., Java JDK paths in `org.savantbuild.plugin.java.properties`)
```

Replace with:
```
- **Local cache:** `$XDG_CACHE_HOME/savant` (default `~/.cache/savant`)
- **Plugin config:** `$XDG_CONFIG_HOME/savant/plugins/` (default `~/.config/savant/plugins/`, e.g., Java JDK paths in `org.savantbuild.plugin.java.properties`)
- **Global config:** `$XDG_CONFIG_HOME/savant/config.properties` (default `~/.config/savant/config.properties`)
```

- [ ] **Step 2: Commit**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-ij
git add CLAUDE.md
git commit -m "Update CLAUDE.md with XDG directory paths"
```

### Task 13: Final verification

- [ ] **Step 1: Run all tests across all repos**

```bash
cd /Users/bpontarelli/dev/os/savant/savant-version && sb test
cd /Users/bpontarelli/dev/os/savant/savant-utils && sb test
cd /Users/bpontarelli/dev/os/savant/savant-io && sb test
cd /Users/bpontarelli/dev/os/savant/savant-dependency-management && sb test
cd /Users/bpontarelli/dev/os/savant/savant-core && sb test
```
Expected: ALL TESTS PASS in all 5 repos
