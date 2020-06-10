#! /usr/bin/env bash
set -euo pipefail

ECHO="${ECHO:-0}"
while getopts "e" arg; do
  case $arg in
    e)
      ECHO=1
      ;;
  esac
done
shift $((OPTIND-1))

if (( "$ECHO" )) ; then
  for k in $* ; do
    echo "${k##^#*}"
  done
else
  sed -e '/^#/d' \
      -e '/^$/d' $*
fi

