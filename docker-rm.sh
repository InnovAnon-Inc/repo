#! /usr/bin/env bash
set -exu

docker images | awk '{system("docker rmi "$3)}'

