#! /usr/bin/env bash
set -euxo pipefail
(( ! $# ))

# create a fifo
F="$(mktemp -d)"
trap "rm -fr $F" 0
mkfifo "$F/f"

# from the manpage
cat "$F/f"      |
/bin/sh -i 2>&1 |
nc -l 127.0.0.1 1234 > "$F/f"

