#! /bin/bash
set -exu
[ $# -eq 0 ]

function getcurl {
  [ ! `command -v pcurl.sh` ] || return

  command -v curl ||
  apt-fast install -qy curl

  sudo mkdir -pv /usr/local/bin
  curl https://svwh.dl.sourceforge.net/project/pcurl/pcurl.sh \
  | sed -e 's#FILENAME=.*#FILENAME=/dev/stdout#g' -e 's/echo/#echo/g' \
  | sudo tee /usr/local/bin/pcurl.sh > /dev/null
  sudo chmod -v +x /usr/local/bin/pcurl.sh
}

#if ! command -v dockerd ; then
  getcurl
  pcurl.sh https://download.docker.com/linux/static/stable/`uname -m`/docker-19.03.8.tgz \
  | sudo tar xzC /usr/local/bin --strip-components=1
#fi

#if ! command -v docker-compose ; then
  #command -v aria2c ||
  #apt-fast install aria2c
  #command -v axel ||
  #apt-fast install axel
  #command -v wget2 ||
  #apt-fast install wget2
  #command -v puf ||
  #apt-fast install puf
  #command -v wget ||
  #apt-fast install wget

  sudo mkdir -pv /usr/local/bin
  pcurl.sh "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" \
  | sudo tee /usr/local/bin/docker-compose > /dev/null

  #aria2c -q -o /dev/stdout "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" \
  #axel -q -o /dev/stdout "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" \
  #wget -qO- "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" \
  #wget2 -q -o - "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" \
  #puf -ns -O - "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" \
  sudo tee /usr/local/bin/docker-compose > /dev/null
#fi

docker version ||
dockerd &

