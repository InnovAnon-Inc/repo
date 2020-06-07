#! /usr/bin/env bash
set -euo pipefail
(( ! $# ))

while read line ; do
  gpg -q --encrypt --armor -r InnovAnon-Inc@protonmail.com << EOF
$line
EOF
done

