#! /usr/bin/env bash
set -euxo pipefail
(( ! $# ))

fawk "${0/.sh/.awk}"     \
  dnscrypt-resolvers.csv |
sort -R                  |
sudo tee -a /etc/dnscrypt-proxy/dnscrypt-proxy.conf

