#! /bin/bash
set -exu
cd ~/src
for k in * ; do
[ -f $k/configure.ac ] || continue
sed -i '1s#laurence\.a\.maddox@gmail.com#InnovAnon-Inc@protonmail.com#' $k/configure.ac
done

