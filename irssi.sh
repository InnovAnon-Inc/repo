#! /usr/bin/env bash
(( #$ == 2 ))
server="$1"
chatnet="$2"

openssl s_client -showcerts -connect $server:6697 |
awk '$0 == "-----BEGIN CERTIFICATE-----" {FLAG=1} FLAG {print} $0 == "-----END CERTIFICATE-----" {exit}' >
~/.irssi/$server.crt

# TODO needs to write to server section. idk what that looks like
cat >> ~/.irssi/<config> << EOF
  {
    address     = "$server";
    chatnet     = "$chatnet";
    port        = "6697";
    use_ssl     = "yes";
    ssl_verify  = "yes";
    autoconnect = "yes";
    ssl_cafile  = "~/.irssi/$server.crt";
  }
EOF

