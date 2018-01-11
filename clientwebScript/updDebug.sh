#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

bigServer=$1
echo "update svn"
$DIR/updateSvnDebug.sh $bigServer || exit 1

# echo "clean temp dir"
# if [[ -d /data/autodeploy/clientAuto/tmpData/ ]]; then
#     rm -rf /data/autodeploy/clientAuto/tmpData || exit 1
# fi
echo "create temp dir"
if [[ ! -d /data/autodeploy/clientAuto/tmpData/ ]]; then
    mkdir /data/autodeploy/clientAuto/tmpData || exit 1
fi
echo "copy to temp dir"
rsync -avz --delete --exclude='*.svn*' /data/autodeploy/clientAuto/current/patch/debug/ /data/autodeploy/clientAuto/tmpData/ || exit 1

# 令牌号
tokenNumber="0"
if [[ -f /opt/tankserver/game/webroot/clientweb/patch/debug/version.manifest ]]; then
    verManifestStr="`cat /opt/tankserver/game/webroot/clientweb/patch/debug/version.manifest`" || exit 1
    verManifestStr=${verManifestStr%/project.manifest*} || exit 1
    tokenNumber=${verManifestStr##*/} || exit 1
fi
tokenNumber=$[tokenNumber + 1] || exit 1
tokenNumber=$[tokenNumber % 5] || exit 1
echo "new token:$tokenNumber"
mv /data/autodeploy/clientAuto/tmpData/number /data/autodeploy/clientAuto/tmpData/$tokenNumber || exit 1
sed -i "s/debug\/number/debug\/$tokenNumber/g" /data/autodeploy/clientAuto/tmpData/version.manifest || exit 1
sed -i "s/debug\/number/debug\/$tokenNumber/g" /data/autodeploy/clientAuto/tmpData/$tokenNumber/project.manifest || exit 1

rsync -avz --delete --exclude='*.svn*' /data/autodeploy/clientAuto/tmpData/$tokenNumber/ /opt/tankserver/game/webroot/clientweb/patch/debug/$tokenNumber/ || exit 1
cp -f /data/autodeploy/clientAuto/tmpData/version.manifest /opt/tankserver/game/webroot/clientweb/patch/debug/version.manifest || exit 1