#! /usr/bin/env bash
set -euo pipefail
(( ! $# ))
xargs -I @ sh -c \
  "apt list '@' 2> /dev/null | \
   awk -F / 'NR > 1 {print \$1}'"

