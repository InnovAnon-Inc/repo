#! /usr/bin/env bash
set -eu
if ((   $# )) \
&& [[  "$1" = "-no-tune" ]] ; then
  T=0
elif (( ! $# ))             ; then
  T=1
else exit 1                 ; fi

#ARCH=`gcc -march=native -Q --help=target | grep -- '-march=' | cut -f3`
ARCH="`gcc -march=native -Q --help=target | awk '$1 == "-march=" {print $2}'`"
echo $ARCH

if (( "$T" )) ; then
  #TUNE="`gcc -march=$ARCH  -Q --help=target | awk '$1 == "-mtune=" {print $2}'`"
  #TUNE="${TUNE:-$ARCH}"
  TUNE="`ARCH="$ARCH" mtune`"
  echo $TUNE
fi

