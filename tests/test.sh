#!/bin/bash
set -xe

docker build -t "fvigotti/kafka" ../src

export KAFKA_DEFAULT_PORT=9092
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

docker run --rm -ti -p ${KAFKA_DEFAULT_PORT}:${KAFKA_DEFAULT_PORT} \
    -e "KAFKA_BROKER_ID=1" \
    fvigotti/kafka
#http-server shared_volumes/www/ -p ${PROXYED_HTTP_PORT} -a localhost
#
#
