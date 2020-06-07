#! /usr/bin/env bash
set -euxo pipefail
(( ! $# ))

#while read line ; do
#  gpg -q --encrypt --armor -r InnovAnon-Inc@protonmail.com << EOF
#$line
#EOF
#done              |
enclines          |
nc 127.0.0.1 1234 |
gpg -q --decrypt --allow-multiple-messages

