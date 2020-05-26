#! /usr/bin/env bash
set -exu

[[ $# -ne 0 ]]

cd "`dirname "$(readlink -f "$0")"`"/..

grep -R "${@/#/-e }" --exclude-dir=.git -a

