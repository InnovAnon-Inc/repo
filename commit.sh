#! /bin/bash
set -exu

if [ $# -eq 0 ] ; then
M='auto update'
else
M="$*"
fi

cd "`dirname "$(readlink -f "$0")"`"/..

for k in */ ; do (
   set +e
   cd $k
   [ -d .git ] || continue
   git add .
   git commit -m "$M"
   git push origin master
) & sleep 1 ; done

