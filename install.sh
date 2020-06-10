#! /usr/bin/env bash
set -exu

DIR="`dirname "$(readlink -f "$0")"`"

[[ -d          /usr/local/bin ]] ||
sudo mkdir -pv /usr/local/bin

if (( ! $# )) ; then install=( comms.sh get-docker.sh \
	m{arch,tune}.sh fawk.sh apt-{glob,list}.sh    \
       	parts.sh pcurl.sh waitall.sh                  \
	enclines.sh rshell-{,enc-}{client,server}.sh  \
	)
else                     install="$@"
fi

for k in "${install[@]}" ; do
sudo ln -fsv "$DIR/$k" "/usr/local/bin/${k%.sh}"
done

