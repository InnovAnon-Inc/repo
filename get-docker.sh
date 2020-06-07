#! /usr/bin/env bash
set -exu
(( ! $# ))

getcurl() {
  command -v curl ||
  sudo apt-fast install -qy curl

  if ! command -v pcurl ; then
    sudo mkdir -pv /usr/local/bin
    curl https://raw.githubusercontent.com/InnovAnon-Inc/repo/master/pcurl.sh \
    | sudo tee /usr/local/bin/pcurl > /dev/null
    sudo chmod -v +x /usr/local/bin/pcurl
  fi
}

if ! command -v dockerd ; then
  getcurl
  pcurl https://download.docker.com/linux/static/stable/`uname -m`/docker-19.03.8.tgz \
  | sudo tar xzC /usr/local/bin --strip-components=1
fi

if ! command -v docker-compose ; then
  getcurl
  pcurl "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" \
  | sudo tee /usr/local/bin/docker-compose > /dev/null
  sudo chmod -v +x /usr/local/bin/docker-compose
fi

docker version ||
dockerd &

