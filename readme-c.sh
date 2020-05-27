#! /usr/bin/env bash
set -eu

cd "`dirname "$(readlink -f "$0")"`"/..

for PROJECT in */ ; do
  if [[ ! -e $PROJECT/configure.ac ]] ; then
    echo $PROJECT
    continue
  fi
  if ! diff -q $PROJECT/LICENSE* glitter/LICENSE ; then
    echo $PROJECT
    continue
  fi
  if [[ ! -e $PROJECT/README.md ]] ; then
    echo $PROJECT
    continue
  fi

  #cat << EOF
  cat >> $PROJECT/README.md << EOF
![Corporate Logo](https://i.imgur.com/UD8y4Is.gif)

EOF
#[![CircleCI](https://img.shields.io/circleci/build/github/InnovAnon-Inc/${PROJECT}?color=%23FF1100&logo=InnovAnon%2C%20Inc.&logoColor=%23FF1133&style=plastic)](https://circleci.com/gh/InnovAnon-Inc/${PROJECT})
#
#[![Latest Release](https://img.shields.io/github/commits-since/InnovAnon-Inc/${PROJECT}/latest?color=%23FF1100&include_prereleases&logo=InnovAnon%2C%20Inc.&logoColor=%23FF1133&style=plastic)](https://github.com/InnovAnon-Inc/${PROJECT}/releases/latest)
#
#[![Repo Size](https://img.shields.io/github/repo-size/InnovAnon-Inc/${PROJECT}?color=%23FF1100&logo=InnovAnon%2C%20Inc.&logoColor=%23FF1133&style=plastic)](https://github.com/InnovAnon-Inc/${PROJECT})
#
#![Dependencies](https://img.shields.io/librariesio/github/InnovAnon-Inc/${PROJECT}?color=%23FF1100&style=plastic)
#
#[![License Summary](https://img.shields.io/github/license/InnovAnon-Inc/${PROJECT}?color=%23FF1100&label=Free%20Code%20for%20a%20Free%20World%21&logo=InnovAnon%2C%20Inc.&logoColor=%23FF1133&style=plastic)](https://tldrlegal.com/license/unlicense#summary)
#
#EOF
done

