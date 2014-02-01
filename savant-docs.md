# Savant Build System
Savant is a complete build and dependency management system built entirely from Scratch. It doesn't use Maven, Ivy or Ant under the hoods and provides a entirely new way of thinking about your builds.

# A Little Something Different
Unlike Ant, Savant has plugins. Unlike Maven and Gradle, Savant plugins don't provide build targets. Instead, Savant plugins provide functionality that you can use in your targets. This solves one of the main pain points of other build systems.

To explain this better, let's look at an extremely simple build file:

```
import 'testng-plugin'
```

In most build systems, this would add the target **test** to your project. You could then execute this target from the command-line like this:

```
$ build test
```

Let's now say that your project needs to first create a database and load it up with some data before you run your tests. How do you do this?

Well, in some build tools you can do something like this:

```
import 'testng-plugin'

test.doBefore << {
  setupDatabase()
}
```

So far so good right? Well, what happens when you want to first setup the database, then run one test set, then reset the database, then run another test set? Things become much more difficult because you don't have access to the internals of the plugin and can't easily inject code in the middle of its processing.

Another example where traditional plugin systems break down is target dependencies. The issue here is that the **testng** plugin can't run until the **java** plugin has run. Specifically, the **java** plugin's compile target needs to be called first. That means that the **testng** plugin needs to depend either directly on the **java** plugin or depend on there being a target named **compile**.

Savant is completely different. It is a hybrid approach that incorporates concepts from Ant tasks, but also provides the power of Groovy and a complete dependency management system (even plugins are dependencies).

# Getting Started

First you need to download the Savant bundle.

# Executing Savant


# Basic Savant Build

Let's start out by looking at a simple Savant build file that defines a project.

```
project(group: "org.example", name: "my-project", version: "1.0", license: "Apachev2") {
}
```

You define your project details using the project method. This method takes a block, that allows you to define additional details about your project like dependencies. The key here is that the project requires these attributes:

* group - The group identifier for your organization (usually a reverse domain name)
* name - The name of the project
* version - A semantic version http://semver.org
* license - The license of your project

One of the most important details is that Savant requires that everything uses Semantic Versions. This is vitally important when Savant calculates dependencies of your project. You should read the Semantic Version specification by visiting http://semver.org.

You also need to specify a license for your project. All projects must provide a license. This helps Savant determine if your project is in compliance with organizational requirements about software licensing.

# Dependencies

Next, let's add some dependencies to the project

```
project(group: "org.example", name: "my-project", version: "1.0", license: "Apachev2") {
  dependencies {
    group(type: "compile") {
      dependency(id: "org.apache.commons:commons-collections:3.1.0")
    }
  }
}
```

This defines a single compile-time dependency on the Commons Collections library version 3.1.0. This isn't enough information for Savant to download this dependency. You need to tell Savant where to download from. This is done using a workflow definition:

```
project(group: "org.example", name: "my-project", version: "1.0", license: "Apachev2") {
  workflow {
    fetch {
      cache()
      url(url: "http://savant.inversoft.org")
    }
    publish {
      cache()
    }
  }

  dependencies {
    group(type: "compile") {
      dependency(id: "org.apache.commons:commons-collections:3.1.0")
    }
  }
}
```

This tells Savant to first check the local cache for dependencies. If they aren't found there, download them from http://savant.inversoft.org and cache them locally (that's what the publish section is for).

You can simplify this build file like this:

```
project(group: "org.example", name: "my-project", version: "1.0", license: "Apachev2") {
  workflow {
    standard()
  }

  dependencies {
    group(type: "compile") {
      dependency(id: "org.apache.commons:commons-collections:3.1.0")
    }
  }
}
```

The local cache for Savant is stored at ~/.savant/cache.

We now have given Savant enough information to download the dependency and cache it locally.

# Targets

Our Savant build file still doesn't do anything, let's add some targets.

```
project(group: "org.example", name: "my-project", version: "1.0", license: "Apachev2") {
  workflow {
    standard()
  }

  dependencies {
    group(type: "compile") {
      dependency(id: "org.apache.commons:commons-collections:3.1.0")
    }
  }
}

target(name: "clean", description: "Cleans out the build directory") {
  ...
}

target(name: "compile", description: "Compiles the project") {
  ...
}

target(name: "test", description: "Executes the projects tests", dependsOn: ["compile"]) {
  ...
}
```

This is a fairly common build file that includes targets to clean the project, compile the project and run the tests. Notice that the **test** target depends on the **compile** target.

## Target Dependencies

Target dependencies are an ordered list. This means that Savant will ensure that dependent targets are executed in the order they are defined. For example:

```
target(name: "one") {
  output.info("One")
}

target(name: "two") {
  output.info("Two")
}

target(name: "three", dependsOn: ["one", "two"]) {
  output.info("Three")
}
```

If we run the build like this:

```
$ sb three
```

Savant guarantees that the output will always be:

```
One
Two
Three
```

#