#! /usr/bin/env bash
set -euxo pipefail
(( ! $# ))

# create a fifo
F="$(mktemp -d)"
trap "rm -fr $F" 0
mkfifo "$F/f"

# spawn a pty, then feed in the fifo
{ cat << "EOF"
python -c 'import pty; pty.spawn("/bin/bash")'
EOF
  cat "$F/f" ; } |
nc 127.0.0.1 1234 &
P="$!"

( # stty magick on our side
  trap 'stty cooked echo' 0
  stty raw -echo

  # more magick, then feed stdin into the fifo
{ echo reset               ;
  echo export SHELL=$SHELL ;
  echo export  TERM=$TERM  ;
  echo stty rows    30     \
	    columns 80     ;
  cat                      ; } >> "$F/f"

  # wait for nc child proc
  wait "$P" )

