#! /usr/bin/env bash
set -exu

if (( $# == 0 )) ; then
M="auto update by $0"
else
M="$*"
fi

cd "`dirname "$(readlink -f "$0")"`"/..

declare -a pids
for k in */ ; do (
   set +e
   cd $k
   [[ -d .git ]] || continue
   git add .               ;
   git commit -m "$M"      ;
   #git push origin master ;
   git push origin
) ; done

