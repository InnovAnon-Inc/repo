#! /usr/bin/env bash
(( $# != 0 ))

for k in * ; do
  git filter-branch -f --tree-filter \
    "rm -f $k" HEAD
done
git push origin --force --all

