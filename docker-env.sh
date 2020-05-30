#! /usr/bin/env bash
set -exu

if ! command -v march ; then
  curl -Lo /usr/local/bin/march https://raw.githubusercontent.com/InnovAnon-Inc/repo/master/march.sh
  chmod +x /usr/local/bin/march
fi

LINES="`march`"
ARCH=`echo $LINES | awk '{print $1}'`
TUNE=`echo $LINES | awk '{print $2}'`
export   CFLAGS="${CFLAGS:-}   -march=$ARCH -mtune=$TUNE"
export CXXFLAGS="${CXXFLAGS:-} -march=$ARCH -mtune=$TUNE"
unset LINES ARCH TUNE

$*

