#!/bin/bash

DIR="$( cd "$( dirname "$0" )" && pwd )"
cd $DIR

cd $DIR/../../src
grep @author . -r -L | grep -v "./cocos" | grep -v "./packages" | grep -v ".DS_Store" | grep -v "./app/config" | grep -v "./app/language"| grep -v "./config.lua"| grep -v "./main.lua"| grep -v "./app/shield"| grep -v "./app/MyApp.lua"
