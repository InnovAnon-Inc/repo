#! /usr/bin/env bash
set -exu

cd "$(dirname "`readlink -f "$0"`")"/..

for p in */ ; do (
   set -xeu
   [[ ! -f $p/configure.ac ]] ||
   [[ $p = m4-common ]]       || continue
   cd $p

   if [[ -d m4 ]] ; then
   [[ ! -d .git ]] || git rm -r m4
   rm -rf m4
   fi

   [[ -d .git ]] || continue

   git remote remove m4        || :
   git remote remove m4-common || :

   git add .
   git commit -m 'remove m4'
   git push origin master
) || { echo $p; exit 2; } ; done

