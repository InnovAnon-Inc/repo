#! /usr/bin/env bash
set -euo pipefail

{ for k in $* ; do
    echo "${k##^#.*}"
  done        ;
  sed '/^#/d' ;
  cat         ; } |
xargs -I @ sh -c  \
  "apt list '@' 2> /dev/null | \
   awk -F / 'NR > 1 {print \$1}'"

