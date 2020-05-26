#! /usr/bin/env bash
set -exu

cd "`dirname "$(readlink -f "$0")"`"/..

for k in */ ; do (
   set +e
   cd $k
   git pull origin
)
done

