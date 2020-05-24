#! /bin/bash
set -exu

cd "$(dirname "`readlink -f "$0"`")"/..

for k in */ ; do
[ -f $k/configure.ac ] || continue
sed -i '1s#0\.0#1.0#' $k/configure.ac
done

