#!/bin/bash
set -xe

docker build -t "fvigotti/exhibitor" ../src

SRC_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/../src/"


#export KAFKA_DEFAULT_PORT=9092
#mkdir -p /tmp/docker_nginx_test
#cp -Rfp ./shared_volumes /tmp/docker_nginx_test/
#
#
#
#export NGINX_HTTP_PORT=17080
#export PROXYED_HTTP_PORT=18089
#export DOCKER_DAEMON_OPTIONS="-d"
#export DOCKER_DAEMON_OPTIONS="--rm -ti"
#
#
#
#docker run ${DOCKER_DAEMON_OPTIONS} --name test_fvigotti_nginx \
#-v /tmp/docker_nginx_test/shared_volumes/cache/:/var/cache/nginx/   \
#-v /tmp/docker_nginx_test/shared_volumes/etc/:/etc/nginx/   \
#-v /tmp/docker_nginx_test/shared_volumes/logs/:/var/log/nginx/   \
#-p ${NGINX_HTTP_PORT}:${NGINX_HTTP_PORT} \
#-p ${PROXYED_HTTP_PORT}:${PROXYED_HTTP_PORT} \
# fvigotti/nginx
#
#
#docker run --rm -ti -p ${PROXYED_HTTP_PORT}:${PROXYED_HTTP_PORT} -v $(pwd)/shared_volumes/www/:/www fvigotti/fatubuntu http-server /www/ -p ${PROXYED_HTTP_PORT} -a localhost
#http-server shared_volumes/www/ -p ${PROXYED_HTTP_PORT} -a localhost

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
#http-server shared_volumes/www/ -p ${PROXYED_HTTP_PORT} -a localhost
#
#
