#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

echo "lua规范检测"
for f in $(find $DIR/../src -name "*.lua"); do
    echo $f
    str=$( cat $f )
    echo $str | grep -e "^--\[\[\*\]\]" && echo "yes" || echo "no"
done
