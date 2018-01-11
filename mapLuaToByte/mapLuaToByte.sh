#!/bin/bash

#大地图，转换lua到二进制文件

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

# mkdir $DIR/../../res/data
lua mapLuaToByte.lua $DIR || exit 1