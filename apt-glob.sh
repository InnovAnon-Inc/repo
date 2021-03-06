#! /usr/bin/env bash
set -euo pipefail

NO_GLOB="${NO_GLOB:-0}"
ECHO="${ECHO:-}"
while getopts "ge" arg; do
  case $arg in
    g)
      NO_GLOB=1
      ;;
    e)
      ECHO=-e
      ;;
  esac
done
shift $((OPTIND-1))

apt-list $ECHO $* |
if (( "$NO_GLOB" )) ; then
  cat
else
  xargs -I @ $SHELL -c  \
    "apt list '@' 2> /dev/null | \
     awk -F / 'NR > 1 {print \$1}'"
fi

