#! /usr/bin/env bash
set -eu
(( ! $# ))

if (( $# )) ; then
  sort $1
else
  comm -12 <(sort $1) <($0 ${@:2})
fi

