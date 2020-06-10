#! /usr/bin/env bash
set -euo pipefail
(( $# ))

git filter-branch -f --tree-filter \
  "rm -vf "$(printf %q "$*")"" HEAD
git push origin --force --all

