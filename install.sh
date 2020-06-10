#! /usr/bin/env bash
set -euxo pipefail
if (( "$UID" )) ; then
  SUDO="${SUDO:-sudo}"
else
  SUDO="${SUDO:-}"
fi
REPO="${REPO:-https://raw.githubusercontent.com/InnovAnon-Inc/repo/master}"

DIR="`dirname "$(readlink -f "$0")"`"

[[ -d          /usr/local/bin ]] ||
$SUDO mkdir -pv /usr/local/bin

if (( ! $# )) ; then install=( comms.sh get-docker.sh \
	m{arch,tune}.sh fawk.sh apt-{glob,list}.sh    \
       	parts.sh pcurl.sh waitall.sh                  \
	enclines.sh rshell-{,enc-}{client,server}.sh  \
	)
else                 install=($@)
fi

for k in ${install[@]} ; do
  [[ -e             "$DIR/$k" ]] ||
  curl -Lo          "$DIR/$k" "$REPO/$k"                || exit $?
  $SUDO chmod -v +x "$DIR/$k"                           || exit $?
  $SUDO ln -fsv     "$DIR/$k" "/usr/local/bin/${k%.sh}" || exit $?
done

