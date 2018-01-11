#!/bin/bash

basepath=$(cd `dirname $0`; pwd)
android_root_dir=$basepath"/../frameworks/runtime-src/proj.android"
projects_cocos_framework=$basepath"/../frameworks/cocos2d-x/"

cd $basepath

$NDK_ROOT/ndk-build -C $android_root_dir -j8 NDK_MODULE_PATH=$projects_cocos_framework:$projects_cocos_framework"/cocos":$projects_cocos_framework"/external":$projects_cocos_framework"/cocos/scripting" NDK_TOOLCHAIN_VERSION=4.9 NDK_DEBUG=1
