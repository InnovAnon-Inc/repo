#! /usr/bin/env bash
set -euxo pipefail

# TODO borked

D="$(mktemp -d)"
trap "rm -fr $D" 0

X=0
while getopts "d" arg; do
  case $arg in
    d)
      X=1
      ;;
  esac
done
shift $((OPTIND-1))
(( ! $# ))

if (( ! "$X" )) ; then
  cat >       "$D/1"
  lrzip -U -n "$D/1" >     "$D/.lrz"
  zpaq c      "$D/.zpaq"   "$D/.lrz"
  cat         "$D/.zpaq"
else
  cat >       "$D/.zpaq"
  zpaq x      "$D/.zpaq" > "$D/.lrz"
  lrzcat      "$D/.lrz"  > "$D/1"
  cat         "$D/1"
fi

