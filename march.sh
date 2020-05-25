#! /bin/bash
set -exu

ARCH=`gcc -march=native -Q --help=target | grep -- '-march=' | cut -f3`
gcc -march=$ARCH  -Q --help=target | grep -- '-mtune=' | cut -f3

