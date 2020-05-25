#! /bin/bash
set -exu

if [[ $# -eq 0 ]] ; then
M="auto update by $0"
else
M="$*"
fi

cd "`dirname "$(readlink -f "$0")"`"/..

declare -a pids
for k in */ ; do (
   set +e
   cd $k
   [[ -d .git ]] || continue
   git add .               ;
   git commit -m "$M"      ;
   #git push origin master ;
   git push origin
) &
  pids+=($!)
  sleep 1
done

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

waitall ${pids[@]}

