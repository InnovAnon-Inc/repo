#! /bin/bash
set -exu
cd `dirname $(readlink -f $0)`/..
for k in */ ; do (
   set +e
   cd $k
   [ -d .git ] || continue
   git add .
   git commit -m 'auto update'
   git push origin master
) & sleep 1 ; done
