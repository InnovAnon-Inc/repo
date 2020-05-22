#! /bin/bash
set -exu

cd ~/src
for p in */ ; do (
   set -xu
   cd $p
      k=m4

      git add . ; git commit -m m4 ; git push origin master ;

      git submodule deinit -f $k
      rm -rf .git/modules/$k
      git rm -r $k

      git add . ; git commit -m m4 ; git push origin master ;

      #git remote add $k https://github.com/InnovAnon-Inc/$k.git
      #git fetch $k

      #mkdir -pv $k/src
      #( set -exu
        #cd $k/src
        #git checkout $k/master -- $k/src/Makefile-LIBADD.inc ) || exit 2
        #git checkout FETCH_HEAD -- $k/src/Makefile-LIBADD.inc ) || exit 2
      ( git add . && git commit -m 'removed submodules' && git push origin master )
      git subtree add --prefix $k https://github.com/InnovAnon-Inc/$k-common.git master --squash
   git add .
   git commit -m 'converted submodules'
   git push origin master
) || exit 3 ; done
