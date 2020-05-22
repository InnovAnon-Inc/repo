#! /bin/bash
set -exu

cd "$(dirname "`readlink -f "$0"`")"/..

for p in */ ; do (
   set -xeu
   [ -f $p/configure.ac ] || continue
   [ $p != m4-common    ] || continue
   cd $p

   if [ -d m4 ] ; then
   git rm -r m4
   rm -rf m4
   fi

   git remote remove m4        || :
   git remote remove m4-common || :

   git remote add m4-common https://github.com/InnovAnon-Inc/m4-common.git
   git add .
   git commit -m 'remove m4'
   git subtree add --prefix=m4 m4-common master --squash
   git add .
   git commit -m 're-add m4'
   git push origin master
) || { echo $p; exit 2; } ; done

