#! /usr/bin/env bash
set -exu

if ! command -v march ; then
  curl -Lo /usr/local/bin/march https://raw.githubusercontent.com/InnovAnon-Inc/repo/master/march.sh
  curl -Lo /usr/local/bin/mtune https://raw.githubusercontent.com/InnovAnon-Inc/repo/master/mtune.sh
  chmod +x /usr/local/bin/m{arch,tune}
fi

ARCH="`march -no-tune`"
TUNE="`mtune`"
export   CFLAGS="${CFLAGS:-}   -march=$ARCH -mtune=$TUNE"
export CXXFLAGS="${CXXFLAGS:-} -march=$ARCH -mtune=$TUNE"
unset ARCH TUNE

$*

