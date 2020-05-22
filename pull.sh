#! /bin/bash
set -exu
cd `dirname $(readlink -f $0)`/..
for k in */ ; do (
   set +e
   cd $k
   git pull origin master
) & sleep 1 ; done
