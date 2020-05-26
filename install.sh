#! /usr/bin/env bash
set -exu

DIR="`dirname "$(readlink -f "$0")"`"

if [[ $# -eq 0 ]] ; then install=( comms.sh get-docker.sh march.sh parts.sh pcurl.sh )
else                     install="$@"
fi

for k in "${install[@]}" ; do
sudo ln -fsv "$DIR/$k" "/usr/local/bin/${k%.sh}"
done
