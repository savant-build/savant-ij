#!/bin/sh
bin_dir=$(dirname $0)
cd ${bin_dir}/..

echo `pwd`
function update() {
  if [ -d $1 ]; then
    cd ${1}
    echo "Updating ${1}..."
    git pull
    cd ..
  fi
}

update database-plugin
update deb-plugin
update dependency-plugin
update file-plugin
update groovy-plugin
update groovy-testng-plugin
update idea-plugin
update java-plugin
update java-testng-plugin
update release-git-plugin
update tomcat-plugin
update webapp-plugin
update spock-plugin

update savant-core
update savant-dependency-management
update savant-io
update savant-maven-bridge
update savant-utils

cd wikis

update savant-core.wiki
update savant-database-plugin.wiki
update savant-deb-plugin.wiki
update savant-dependency-management.wiki
update savant-dependency-plugin.wiki
update savant-file-plugin.wiki
update savant-groovy-plugin.wiki
update savant-groovy-testng-plugin.wiki
update savant-idea-plugin.wiki
update savant-java-plugin.wiki
update savant-java-testng-plugin.wiki
update savant-maven-bridge.wiki
update savant-release-git-plugin.wiki
update savant-tomcat-plugin.wiki
update savant-utils.wiki
update savant-webapp-plugin.wiki
update savant-spock-plugin.wiki
