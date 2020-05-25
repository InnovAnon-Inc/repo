#! /bin/bash
set -exu

cd "`dirname "$(readlink -f "$0")"`"/..

for k in poobuntu{,-{dev,ci}} docker-apt-cacher-ng     \
         Abaddon{,-gui}       docker-{hexchat,firefox} \
         docker-{wads,wine,zandronum,doomsday,doom}    \
         docker-buildworld ; do (
  set -exu
  cd $k
  ./run.sh
) || { echo $k; break; } ; done

