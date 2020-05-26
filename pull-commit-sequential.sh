#! /usr/bin/env bash
set -exu

cd "`dirname "$(readlink -f "$0")"`"/..

./pull-sequential.sh
./commit-sequential.sh

