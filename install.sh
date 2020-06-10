#! /usr/bin/env bash
set -euxo pipefail
if (( "$UID" )) ; then
  SUDO="${SUDO:-sudo}"
else
  SUDO="${SUDO:-}"
fi

DIR="`dirname "$(readlink -f "$0")"`"

[[ -d          /usr/local/bin ]] ||
$SUDO mkdir -pv /usr/local/bin

if (( ! $# )) ; then install=( comms.sh get-docker.sh \
	m{arch,tune}.sh fawk.sh apt-{glob,list}.sh    \
       	parts.sh pcurl.sh waitall.sh                  \
	enclines.sh rshell-{,enc-}{client,server}.sh  \
	)
else                     install="$@"
fi

for k in "${install[@]}" ; do
  $SUDO ln -fsv "$DIR/$k" "/usr/local/bin/${k%.sh}"
done

