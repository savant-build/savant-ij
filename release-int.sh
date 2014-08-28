#!/bin/sh
cd ../dependency-plugin
src/main/shell/release-int.sh

cd ../file-plugin
src/main/shell/release-int.sh

cd ../groovy-plugin
src/main/shell/release-int.sh

cd ../groovy-testng-plugin
src/main/shell/release-int.sh

cd ../release-git-plugin
src/main/shell/release-int.sh

cd ../savant-core
src/main/shell/release-int.sh

cd ../savant-dependency-management
src/main/shell/release-int.sh

cd ../savant-utils
src/main/shell/release-int.sh
