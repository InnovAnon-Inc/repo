#! /bin/bash
set -eu

#ARCH=`gcc -march=native -Q --help=target | grep -- '-march=' | cut -f3`
#TUNE=`gcc -march=$ARCH  -Q --help=target | grep -- '-mtune=' | cut -f3`
ARCH=`gcc -march=native -Q --help=target | awk '$1 == "-march=" {print $2}'
TUNE=`gcc -march=$ARCH  -Q --help=target | awk '$1 == "-mtune=" {print $2}'
echo ARCH=$ARCH
echo TUNE=$TUNE

