#!/bin/sh
cd ../dependency-plugin
src/main/shell/release.sh

cd ../file-plugin
src/main/shell/release.sh

cd ../groovy-plugin
src/main/shell/release.sh

cd ../groovy-testng-plugin
src/main/shell/release.sh

cd ../savant-core
src/main/shell/release.sh

cd ../savant-dependency-management
src/main/shell/release.sh

cd ../savant-utils
src/main/shell/release.sh
