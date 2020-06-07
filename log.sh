#! /usr/bin/env bash
set -euxo pipefail
CMD="${0/-log/}"
LOG="${CMD%.*}.log"
ARG="${@:1}"
rm -f           "$LOG"
unbuffer        "$CMD" ${ARG[@]} |&
unbuffer -p tee "$LOG"

