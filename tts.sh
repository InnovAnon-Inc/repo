#! /usr/bin/env bash
set -euxo pipefail
(( $# ))

unbuffer docker exec docker-hexchat \
tail -f .config/hexchat/logs/freenode/#"$1".log |
unbuffer -p awk '{for(k=5; k<=NR; k++)printf("%s ", $k);print("\n")}' |
unbuffer -p espeak -v mb-us1 -s 145

#unbuffer -p awk '{for(k=5; k<=NR; k++)printf("%s ", $k);print("\n\n")}' |
#unbuffer -p festival --tts --language american_english

