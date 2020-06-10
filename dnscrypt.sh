#! /usr/bin/env bash
set -euxo pipefail
(( ! $# ))

"${0/.sh/.awk}" \
  /usr/share/dnscrypt-proxy/dnscrypt-resolvers.csv |
sort -R |
sudo tee -a /etc/dnscrypt-proxy/dnscrypt-proxy.conf

