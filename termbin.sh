#! /usr/bin/env bash
set -exu
(( "$#" != 0 ))

#
# usage:
#   $0 <command> [args]...
#
# examples:
# - $0 echo [stuff]...
# - $0 cat  [files]...

# paste to termbin and get link
#link="$($* | tr '\0' '\n' | nc termbin.com 9999)"
link="$($* | nc termbin.com 9999 | tr -d \\0)"

# chomp link to prevent sending incomplete message on IRC
#link="${link%\\n}"

# copy to clipboard the chomped link
echo -n "$link" |
xclip -selection c

# output the link for optional further processing
#echo "$link" copied to clipboard
echo "$link"

