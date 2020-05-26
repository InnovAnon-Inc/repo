#! /usr/bin/env bash
set -eu
URL="$1"
if   [[ $# -eq 2 ]] ; then REDIRECT="> $2"
elif [[ $# -eq 1 ]] ; then REDIRECT=
else exit 1 ; fi

#title           :pcurl.sh
#description     :This script will download a file in segments.
#author		 :Innovations Anonymous <InnovAnon-Inc@protonmail.com>
#date            :20200202
#version         :0.2    
#usage		 :bash pcurl.sh url
#notes           :Install curl to use this script.

command -v curl > /dev/null ||
apt-fast install -qy curl

waitall() { # PID...
  ## Wait for children to exit and indicate whether all exited with 0 status.
  local errors=0
  while : ; do
    while (( "$#" >= 3 )) ; do
      pid="$1"
      part="$2"
      retry="$3"
      shift
      shift
      shift
      if kill -0 "$pid" 2>/dev/null; then
        set -- "$@" "$pid" "$part" "$retry"
      elif ! wait "$pid"; then
        if ((retry < ${RETRIES:-10})) ; then
          curl -s -L $part "${URL}" &
          set -- "$@" $! "$part" $((retry + 1))
        else
          ((++errors))
        fi
      fi
    done
    (("$#" > 0)) || break
    # TODO: how to interrupt this sleep when a child terminates?
    sleep ${WAITALL_DELAY:-1}
   done
  ((errors == 0))
}

FILESIZE="`curl -s -I -L "${URL}" | awk 'tolower($1) == "content-length:" {sub("\r", "", $2); K=$2}END{printf("%s", K)}'`"
#old='^Content-Length: \([0-9]*\).*'
#new='\1'
#FILESIZE="$(echo -n `curl -s -I -L "${URL}" | sed -n 'x;${s/'"$old/$new"'/i;p;x;};1d'`)"
#FILESIZE="$(echo -n `curl -s -I -L "${URL}" | sed -n "0,/${old}/s,${old},${new},ip"`)"
#FILESIZE="$(echo -n `curl -s -I -L "${URL}" | sed -n 's/^Content-Length: \([0-9]*\).*/\1/ip'`)"
[[ "$FILESIZE" ]]

#TODO Add exit at this point if this previous step fails.

#MAX_SEGMENTS=10
MAX_SEGMENTS=$((`nproc` * 2))
MAX_SEGMENTS=$((MAX_SEGMENTS > 10 ? 10 : MAX_SEGMENTS))

SEGMENT_SIZE=$(("${FILESIZE}" / ${MAX_SEGMENTS}))
[[ "$SEGMENT_SIZE" ]]

START_SEG=0
END_SEG="${SEGMENT_SIZE}"

PARTS=`mktemp -d`
trap "rm -rf $PARTS" 0

declare -a pids
eval segnums=( {1.."${MAX_SEGMENTS}}" )
for i in "${segnums[@]}" ; do
  PART="--range ${START_SEG}-${END_SEG} -o "${PARTS}/part${i}""
  #curl -s -L --range ${START_SEG}-${END_SEG} -o "${PARTS}/part${i}" "${URL}" &
  curl -s -L $PART "${URL}" &
  pids+=($! "$PART" 0)
  START_SEG=$((${END_SEG} + 1))
  END_SEG=$((${START_SEG} + "${SEGMENT_SIZE}"))
done

waitall "${pids[@]}"

#segstr="${segnums[@]}"
#comstr="${segstr// /,}"
#eval parts="${PARTS}/part{$comstr}"
eval cat `parts ${PARTS}/part ${segnums[@]}` $REDIRECT
#eval cat $(eval echo ${PARTS}/part{`eval echo {1..${MAX_SEGMENTS}} | sed 's/ /,/g'`}) $REDIRECT

