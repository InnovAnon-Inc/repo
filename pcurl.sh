#!/bin/bash
set -eu
[[ $# -eq 1 ]]
URL="$1"

#title           :pcurl.sh
#description     :This script will download a file in segments.
#author		 :Innovations Anonymous <InnovAnon-Inc@protonmail.com>
#date            :20200202
#version         :0.2    
#usage		 :bash pcurl.sh url
#notes           :Install curl to use this script.

waitall() { # PID...
  ## Wait for children to exit and indicate whether all exited with 0 status.
  local errors=0
  while : ; do
    for pid in "$@"; do
      shift
      if kill -0 "$pid" 2>/dev/null; then
        set -- "$@" "$pid"
      elif ! wait "$pid"; then
        ((++errors))
      fi
    done
    (("$#" > 0)) || break
    # TODO: how to interrupt this sleep when a child terminates?
    sleep ${WAITALL_DELAY:-1}
   done
  ((errors == 0))
}

FILESIZE=`curl -s -I "${URL}" | sed -n 's/^Content-Length: \([0-9]*\).*/\1/p'`
echo FILESIZE=$FILESIZE 2>

#TODO Add exit at this point if this previous step fails.

#MAX_SEGMENTS=10
MAX_SEGMENTS=$((`nproc` * 2))

SEGMENT_SIZE=$((${FILESIZE} / ${MAX_SEGMENTS}))

START_SEG=0
END_SEG=${SEGMENT_SIZE}

PARTS=`mktemp -d`
trap "rm -rf $PARTS" 0

declare -a pids
for i in $(eval echo {1..${MAX_SEGMENTS}})
do
  curl -s --range ${START_SEG}-${END_SEG} -o ${PARTS}/part${i} "${URL}" &
  pids+=($!)
  START_SEG=$((${END_SEG} + 1))
  END_SEG=$((${START_SEG} + ${SEGMENT_SIZE}))
done

waitall "${pids[@]}"

cat $(eval echo ${PARTS}/part{`eval echo {1..${MAX_SEGMENTS}} | sed 's/ /,/g'`})

