#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR


# cd $DIR/../cocosstudio
filelist="`find $DIR/../cocosstudio -name "*.png"`"
for i in $filelist; do
    md5src="`md5 -q $i`"
    echo $md5src $i
    # for j in $filelist; do
    #     md5dst="`md5 -q $j`"
    #     if [[ $md5src"abc" == $md5dst"abc" ]]; then
    #         echo $i
    #     fi
    # done
done