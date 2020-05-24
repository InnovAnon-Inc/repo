#! /bin/bash
set -exu

cd "`dirname "$(readlink -f "$0")"`"/..

for k in poobuntu{,-{dev,ci}} docker-apt-cacher-ng Abaddon docker-{wads,wine,zandronum,doom} ; do (
  set -exu
  cd $k
  if [[ -f runs.sh ]] ; then ./runs.sh
  else                     ./run.sh
  fi
) || { echo $k; break; } ; done

