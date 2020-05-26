#! /usr/bin/env bash
set -eu
(( $# == 0 ))

if (( $# == 1 )) ; then
  sort $1
else
  comm -12 <(sort $1) <($0 ${@:2})
fi

