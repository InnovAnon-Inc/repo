#! /usr/bin/env bash
set -euxo pipefail

. `command -v delete.env`
(( $# ))

REPO=https://raw.githubusercontent.com/InnovAnon-Inc/repo/master
if [[ -z "${SELF:-}" ]] ; then
  SELF="$(basename "$0")"
  SELF="${SELF%.sh}"
  SELF="$SELF.sh"
fi

{  sed -e '/^#/d' \
       -e '/^$/d' \
       $@         ;
   echo "$SELF"   ;
}                 |
{ cd        /usr/local/bin ;
  while read line ; do
    l="${line%.sh}"
    if (( "$D" )) ; then
      rm   -fv    "$l"                  || exit $?
    else
      curl  -L -o "$line" "$REPO/$line" || exit $?
      chmod -v +x "$line"               || exit $?
      mv    -v    "$line" "$l"          || exit $?
    fi
  done ; 
}

