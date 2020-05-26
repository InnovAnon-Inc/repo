#! /usr/bin/env bash
set -eu
[[ $# -ne 0 ]]

if [[ $# -eq 1 ]] ; then sort $1
else
comm -12 <(sort $1) <($0 ${@:2})
fi
