#! /usr/bin/env bash
set -eu
URL="$1"
(( $# <= 2 ))

#title           :pcurl.sh
#description     :This script will download a file in segments.
#author		 :Innovations Anonymous <InnovAnon-Inc@protonmail.com>
#date            :20200202
#version         :0.2    
#usage		 :bash pcurl.sh url
#notes           :Install curl to use this script.

command -v curl > /dev/null ||
apt-fast install -qy curl

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
  PART="curl -s -L --range ${START_SEG}-${END_SEG} -o "${PARTS}/part${i}" "$URL""
  #curl -s -L --range ${START_SEG}-${END_SEG} -o "${PARTS}/part${i}" "${URL}" &
  $PART &
  pids+=($! "$PART" 0)
  START_SEG=$((${END_SEG} + 1))
  END_SEG=$((${START_SEG} + "${SEGMENT_SIZE}"))
done
#if $(( END_SEG < FILESIZE )) ; then
#  ((++i))
#  segnums+=($i)
#  PART="--range ${START_SEG}-${FILESIZE} -o "${PARTS}/part${i}""
#  curl -s -L $PART "${URL}" &
#  pids+=($! "$PART" 0)
#fi
#(( START_SEG - 1 == FILESIZE ))

if ! command -v waitall > /dev/null ; then
  curl -Lo /usr/local/bin/waitall https://raw.githubusercontent.com/InnovAnon-Inc/repo/master/waitall.sh
  chmod +x /usr/local/bin/waitall
fi
source "`command -v waitall`"
waitall "${pids[@]}"

#segstr="${segnums[@]}"
#comstr="${segstr// /,}"
#eval parts="${PARTS}/part{$comstr}"
#eval cat $(eval echo ${PARTS}/part{`eval echo {1..${MAX_SEGMENTS}} | sed 's/ /,/g'`}) $REDIRECT
#eval cat `parts ${PARTS}/part ${segnums[@]}` $REDIRECT

cat `parts "${PARTS}/part" "${segnums[@]}"` > "${PARTS}/whole"

if [[ "${CHECKSUM+x}" ]] ; then
  CHECKALG="${CHECKALG:-sha256sum}"
  echo "$CHECKSUM" "${PARTS}/whole" | "$CHECKALG" -c
fi

if (( $# == 1 )) ; then
  cat "${PARTS}/whole"
else
  mv "${PARTS}/whole" "$2"
fi

