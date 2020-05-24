#! /bin/bash
set -exu

cd "`dirname "$(readlink -f "$0")"`"/..

for k in poobuntu{,-{dev,ci}} docker-apt-cacher-ng Abaddon{,-gui} docker-hexchat docker-{wads,wine,zandronum,doom} ; do (
  set -exu
  cd $k
  ./run.sh
) || { echo $k; break; } ; done

