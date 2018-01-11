#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

bigServer=$1
if [[ ! -d /data/autodeploy/clientAuto/current/ ]]; then
    mkdir /data/autodeploy/clientAuto/current/ || exit 1
fi
if [[ ! -d /data/autodeploy/clientAuto/current/patch ]]; then
    mkdir /data/autodeploy/clientAuto/current/patch || exit 1
fi
if [[ ! -d /data/autodeploy/clientAuto/current/patch/debug ]]; then
    svn checkout http://svn.raysns.com/repos/tank2/clientweb/patch/$bigServer/debug /data/autodeploy/clientAuto/current/patch/debug
fi

svn cleanup /data/autodeploy/clientAuto/current/patch/debug
svn stat /data/autodeploy/clientAuto/current/patch/debug | grep \\? | awk '{print $2}' | xargs rm -rf || exit 1
svn revert -R /data/autodeploy/clientAuto/current/patch/debug  || exit 1
svn update /data/autodeploy/clientAuto/current/patch/debug
