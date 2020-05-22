#! /bin/bash
set -exu
cd ~/src
for k in * ; do
[ -f $k/configure.ac ] || continue
cp -v glitter/.gitignore $k/.gitignore
done

