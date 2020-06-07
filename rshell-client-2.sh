#! /usr/bin/env bash
set -euxo pipefail
(( ! $# ))

# TODO borked

# create a fifo
F="$(mktemp -d)"
trap "rm -fr $F" 0
mkfifo "$F/f"

# nc reads from fifo
enclines < "$F/f" |
nc 127.0.0.1 1234 |
gpg -q --decrypt --allow-multiple-messages &

# spawn a pty on server side
cat >> "$F/f" << "EOF"
#python -c 'import pty; pty.spawn("/bin/bash")'
EOF

( # stty magick on client side
  #trap 'stty cooked echo' 0
  #stty raw -echo

  # more magick, then feed stdin into the fifo
{ #echo reset               ;
  echo export SHELL=$SHELL ;
  echo export  TERM=$TERM  ;
  echo stty rows    30     \
	    columns 80     ;
  cat                      ; } >> "$F/f" )

# wait for nc child proc
wait %1

