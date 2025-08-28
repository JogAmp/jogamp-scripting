#!/bin/sh

version=$1

git checkout --track -b ${version} origin/${version}
git submodule update --recursive

# php8.2 maintenance/runScript.php maintenance/update.php 
php8.2 maintenance/run.php update

chown -R webrunner:webrunner .
chmod 400 LocalSettings.php

