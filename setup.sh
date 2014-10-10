#!/bin/sh
bin_dir=$(dirname $0)
cd ${bin_dir}/..

function clone_plugin() {
  if [ ! -d $1 ]; then
    git clone git@github.com:inversoft/savant-${1}.git ${1}
  fi
}

function clone() {
  if [ ! -d $1 ]; then
    git clone git@github.com:inversoft/${1}.git ${1}
  fi
}

clone_plugin database-plugin
clone_plugin deb-plugin
clone_plugin dependency-plugin
clone_plugin file-plugin
clone_plugin groovy-plugin
clone_plugin groovy-testng-plugin
clone_plugin idea-plugin
clone_plugin java-plugin
clone_plugin java-testng-plugin
clone_plugin release-git-plugin
clone_plugin tomcat-plugin
clone_plugin webapp-plugin
clone_plugin spock-plugin

clone savant-core
clone savant-dependency-management
clone savant-io
clone savant-maven-bridge
clone savant-utils

if [ ! -d wikis ]; then
  mkdir wikis
fi
cd wikis

clone savant-core.wiki
clone savant-database-plugin.wiki
clone savant-deb-plugin.wiki
clone savant-dependency-management.wiki
clone savant-dependency-plugin.wiki
clone savant-file-plugin.wiki
clone savant-groovy-plugin.wiki
clone savant-groovy-testng-plugin.wiki
clone savant-idea-plugin.wiki
clone savant-java-plugin.wiki
clone savant-java-testng-plugin.wiki
clone savant-maven-bridge.wiki
clone savant-release-git-plugin.wiki
clone savant-tomcat-plugin.wiki
clone savant-utils.wiki
clone savant-webapp-plugin.wiki
clone savant-spock-plugin.wiki
