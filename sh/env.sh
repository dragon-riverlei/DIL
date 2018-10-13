#!/usr/local/bin/bash

if [ ! "$DIL_ROOT" == "" ] && [ ! -d "$DIL_ROOT" ];then
    echo "$DIL_ROOT" does not exist.
    exit 1
fi

if [ "$DIL_ROOT" == "" ];then
    path=$(dirname "$0")
    DIL_ROOT=$(realpath "$path"/..)
fi

db="dil"
