#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

echo "复制大图"

rsync -avz --delete $DIR/../res $DIR/../frameworks/runtime-src/proj.android/assets/
rsync -avz --delete $DIR/../src $DIR/../frameworks/runtime-src/proj.android/assets/
rsync -avz --delete $DIR/../config.json $DIR/../frameworks/runtime-src/proj.android/assets/