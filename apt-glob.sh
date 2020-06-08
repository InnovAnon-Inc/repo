#! /usr/bin/env bash
set -euo pipefail

NO_GLOB="${NO_GLOB:-0}"
while getopts "g" arg; do
  case $arg in
    g)
      NO_GLOB=1
      ;;
  esac
done
shift $((OPTIND-1))


if (( $# )) ; then
  for k in $* ; do
    echo "${k##^#*}"
  done
else
  sed -e '/^#/d' \
      -e '/^$/d'
fi |
if (( "$NO_GLOB" )) ; then
  cat
else
  xargs -I @ $SHELL -c  \
    "apt list '@' 2> /dev/null | \
     awk -F / 'NR > 1 {print \$1}'"
fi

