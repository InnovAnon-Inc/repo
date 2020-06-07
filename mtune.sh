#! /usr/bin/env bash
set -eu
(( ! $# ))

ARCH="${ARCH:-`march -no-tune`}"
#TUNE=`gcc -march=$ARCH  -Q --help=target | grep -- '-mtune=' | cut -f3`
TUNE="`gcc -march=$ARCH  -Q --help=target | awk '$1 == "-mtune=" {print $2}'`"
TUNE="${TUNE:-$ARCH}"
echo $TUNE

