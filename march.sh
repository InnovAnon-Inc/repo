#! /bin/bash
set -eu

ARCH=`gcc -march=native -Q --help=target | grep -- '-march=' | cut -f3`
TUNE=`gcc -march=$ARCH  -Q --help=target | grep -- '-mtune=' | cut -f3`
echo ARCH=$ARCH
echo TUNE=$TUNE

