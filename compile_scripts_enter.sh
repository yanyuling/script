#!/bin/bash
DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

if [[ ! -d /tmp/tank2tmp ]]; then
    mkdir /tmp/tank2tmp
fi
rsync -avz --delete --exclude='*.svn*' $1/ /tmp/tank2tmp/luacode/
# $DIR/compile_scripts.sh -i /tmp/tank2tmp/luacode -o $2 -b 32 -m files -ex luac -ek keyj7ge3ghk -es signbvsjy78e4jvywl || exit 1
cocos luacompile -s /tmp/tank2tmp/luacode -d $2 -e -k keyj7ge3ghk -b signbvsjy78e4jvywl --encrypt --disable-compile || exit 1

