#!/bin/bash
set -xe

docker build -t "fvigotti/exhibitor" ../src

SRC_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/../src/"


