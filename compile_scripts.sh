#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export LUA_PATH="$DIR/lib/luajit/jit/?.lua;;" || exit 1
php "$DIR/lib/compile_scripts.php" $* || exit 1
