#!/bin/bash
set -xe

SRC_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/../src/"


docker run --rm -ti
-p 2181:2181 \
-p 2888:2888 \
-p 3888:3888 \
-p 8181:8181 \
-v ${SRC_DIR}/include/wrapper.sh:/opt/exhibitor/wrapper.sh \
-v ${SRC_DIR}/include/web.xml:/opt/exhibitor/web.xml \
    -e "HOSTNAME=localhost" \
    -e "ZK_PASSWORD=a" \
    fvigotti/exhibitor
