#! /usr/bin/env bash
set -exu

(( $# == 0 ))

cd "`dirname "$(readlink -f "$0")"`"/..

#grep -R "${@/#/-e }" --exclude-dir=.git -a

declare -a array
for ((i = 1; i <= $# ; i++)) ; do
  array+=(-e)
  array+=("${!i}")
done

grep -R "${array[@]}" --exclude-dir=.git -a

