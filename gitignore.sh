#! /bin/bash
set -exu

cd "$(dirname "`readlink -f "$0"`")"/..

for k in */ ; do
[[ -f $k/configure.ac ]] || continue
cp -v glitter/.gitignore $k/.gitignore
done

