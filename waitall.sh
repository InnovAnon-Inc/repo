#! /usr/bin/env bash

waitall() { # PID...
  set -eu

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
          $part &
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

