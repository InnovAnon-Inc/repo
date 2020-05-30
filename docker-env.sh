#! /usr/bin/env bash
set -exu

command -v march ||
curl -Lo /usr/local/bin/march https://raw.githubusercontent.com/InnovAnon-Inc/repo/master/march.sh

LINES="`march`"
ARCH=`echo $LINES | awk '{print $1}'`
TUNE=`echo $LINES | awk '{print $2}'`
export   CFLAGS="${CFLAGS+x}   -march=$ARCH -mtune=$TUNE"
export CXXFLAGS="${CXXFLAGS+x} -march=$ARCH -mtune=$TUNE"
unset LINES ARCH TUNE

$*

