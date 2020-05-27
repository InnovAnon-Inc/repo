#! /usr/bin/env bash
set -eu

(( $# >= 2 ))

segstr="${@:2}"
comstr="${segstr// /,}"
eval echo "$1{$comstr}"

