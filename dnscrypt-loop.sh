#! /usr/bin/env bash
set -euxo pipefail
(( ! $# ))

for k in socket service ; do
  sudo systemctl stop dnscrypt-proxy.$k
done

T="`mktemp`"
trap "rm -f $T" 0
fawk "${0/.sh/.awk}" \
  < /etc/dnscrypt-proxy/dnscrypt-proxy.conf > "$T"
sudo cp -v "$T" /etc/dnscrypt-proxy/dnscrypt-proxy.conf

for k in service socket ; do
    sudo systemctl start dnscrypt-proxy.$k
done

