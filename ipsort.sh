#! /usr/bin/env bash
set -euxo pipefail

sort -n -t . $(printf -- ' -k %s,%s' {1..4}{,}) $*

