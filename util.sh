#!/bin/bash
DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

#获得目录的md5值
function getDirMd5(){

    echo "$(md5 -qs "$(md5 -q $(find $1 -type f ! -path "*.DS_Store*" ! -path "*.svn*"))")"

}