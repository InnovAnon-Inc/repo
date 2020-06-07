#! /usr/bin/env bash
set -euxo pipefail
(( ! $# ))

F="$(mktemp -d)"
trap "rm -fr $F" 0
mkfifo "$F/f"

#cat "$F/f" |
gpg -q --decrypt --allow-multiple-messages < "$F/f" |
/bin/sh -i 2>&1 |
enclines        |
nc -kl 127.0.0.1 1234 > "$F/f"

