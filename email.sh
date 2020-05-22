#! /bin/bash
set -exu

if   [ $# -eq 0 ] ; then
FIND='laurence\.a\.maddox@gmail\.com'
REPL='InnovAnon-Inc@protonmail.com'
elif [ $# -eq 2 ] ; then
FIND="$1"
REPL="$2"
else exit 2 ; fi

cd "$(dirname "`readlink -f "$0"`")"/..

for k in * ; do
[ -f $k/configure.ac ] || continue
sed -i '1s#'"$FIND"'#'"$REPL"'#' $k/configure.ac
done

