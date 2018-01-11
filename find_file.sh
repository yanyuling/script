#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

# 传入文件名
fileTarget=$1

if [[ "$fileTarget"x == ""x ]]; then
    echo "请传入要找的文件"
    exit 1
fi
# 传入文件名的md5
targetMd5="`md5 -q $fileTarget`"

fileList="$(find $DIR/../cocosstudio/cocosstudio/ccs -name "*.*")"

for i in ${fileList[@]}; do
    tmpmd5="`md5 -q $i`"
    # echo $tmpmd5
    if [[ "$tmpmd5"x == "$targetMd5"x ]]; then
        echo "找到该文件："
        echo $i
    fi
done
