#! /bin/bash
set -exu
#
# copy the project directory to the specified dest dir,
# and create a new branch in the dest dir
#
# usage: $0 $PROJECT $BRANCH [$DIR]
#
# examples:
# 1) $0 Abaddon     gui
# 2) $0 docker-doom zandronum docker-zandronum

PROJECT=$1
BRANCH=$2
if   [ $# -eq 2 ] ; then DIR=$PROJECT-$BRANCH
elif [ $# -eq 3 ] ; then DIR=$3
else exit 1 ; fi

cd "`dirname "$(readlink -f "$0")"`"/..
cp -r $PROJECT $DIR
cd             $DIR

git checkout -b $BRANCH

