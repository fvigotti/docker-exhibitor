#!/bin/sh
#/bin/bash -e

# Generates the default exhibitor config and launches exhibitor

MISSING_VAR_MESSAGE="must be set"
DEFAULT_AWS_REGION="us-west-2"
: ${S3_BUCKET:?$MISSING_VAR_MESSAGE}
: ${S3_PREFIX:?$MISSING_VAR_MESSAGE}
: ${HOSTNAME:?$MISSING_VAR_MESSAGE}
: ${AWS_REGION:=$DEFAULT_AWS_REGION}

cat <<- EOF > /opt/exhibitor/defaults.conf
	zookeeper-install-directory=/opt/zookeeper
	zookeeper-data-directory=/var/zookeeper/snapshots
	zookeeper-log-directory=/var/zookeeper/transactions
	log-index-directory=/var/zookeeper/transactions
	cleanup-period-ms=${EXH_cleanup_period_ms:-'300000'}
	check-ms=30000
	backup-period-ms=600000
	client-port=2181
	cleanup-max-files=20
	backup-max-store-ms=21600000
	connect-port=2888
	backup-extra=throttle\=&bucket-name\=${S3_BUCKET}&key-prefix\=${S3_PREFIX}&max-retries\=4&retry-sleep-ms\=30000
	observer-threshold=0
	election-port=3888
	zoo-cfg-extra=tickTime\=2000&initLimit\=10&syncLimit\=5&quorumListenOnAllIPs\=true
	auto-manage-instances-settling-period-ms=0
	auto-manage-instances=1
EOF

if [[ -n ${AWS_ACCESS_KEY_ID} ]]; then
  cat <<- EOF > /opt/exhibitor/credentials.properties
    com.netflix.exhibitor.s3.access-key-id=${AWS_ACCESS_KEY_ID}
    com.netflix.exhibitor.s3.access-secret-key=${AWS_SECRET_ACCESS_KEY}
EOF
fi

if [[ -n ${ZK_PASSWORD} ]]; then
	SECURITY="--security web.xml --realm Zookeeper:realm --remoteauth basic:zk"
	echo "zk: ${ZK_PASSWORD},zk" > realm
fi

exec 2>&1

# If we use exec and this is the docker entrypoint, Exhibitor fails to kill the ZK process on restart.
# If we use /bin/bash as the entrypoint and run wrapper.sh by hand, we do not see this behavior. I suspect
# some init or PID-related shenanigans, but I'm punting on further troubleshooting for now since dropping
# the "exec" fixes it.
#
# exec java -jar /opt/exhibitor/exhibitor.jar \
# 	--port 8181 --defaultconfig /opt/exhibitor/defaults.conf \
# 	--configtype s3 --s3config thefactory-exhibitor:${CLUSTER_ID} \
# 	--s3credentials /opt/exhibitor/credentials.properties \
# 	--s3region us-west-2 --s3backup true

if [[ -n ${AWS_ACCESS_KEY_ID} ]]; then
  java -jar /opt/exhibitor/exhibitor.jar \
    --port 8181 --defaultconfig /opt/exhibitor/defaults.conf \
    --configtype s3 --s3config ${S3_BUCKET}:${S3_PREFIX} \
    --s3credentials /opt/exhibitor/credentials.properties \
    --s3region ${AWS_REGION} --s3backup true --hostname ${HOSTNAME} \
    ${SECURITY}
else
  java -jar /opt/exhibitor/exhibitor.jar \
    --port 8181 --defaultconfig /opt/exhibitor/defaults.conf \
    --configtype s3 --s3config ${S3_BUCKET}:${S3_PREFIX} \
    --s3region ${AWS_REGION} --s3backup true --hostname ${HOSTNAME} \
    ${SECURITY}
fi