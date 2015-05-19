## rewrite of https://github.com/mbabineau/docker-zk-exhibitor
## with some changes.. (ie: signal forwarding from docker daemon , exhibitor jvm args from docker-envs , zoo.cfg default file ,...  )



### Versions
* Exhibitor 1.5.5
* ZooKeeper 3.4.6

### Usage
The container expects the following environment variables to be passed in:

* `S3_BUCKET` - bucket used by Exhibitor for backups and coordination
* `S3_PREFIX` - key prefix within `S3_BUCKET` to use for this cluster
* `AWS_ACCESS_KEY_ID` - AWS access key ID with read/write permissions on `S3_BUCKET`
* `AWS_SECRET_ACCESS_KEY` - secret key for `AWS_ACCESS_KEY_ID`
* `HOSTNAME` - addressable hostname for this node (Exhibitor will forward users of the UI to this address)
* `AWS_REGION` - (optional) the AWS region of the S3 bucket (defaults to `us-west-2`)                   
* `ZK_PASSWORD` - (optional) the HTTP Basic Auth password for the "zk" user

Starting the container:

    docker run -p 8181:8181 -p 2181:2181 -p 2888:2888 -p 3888:3888 \
        -e S3_BUCKET=<bucket> \
        -e S3_PREFIX=<key_prefix> \
        -e AWS_ACCESS_KEY_ID=<access_key> \
        -e AWS_SECRET_ACCESS_KEY=<secret_key> \
        -e HOSTNAME=<host> \
        mbabineau/zookeeper-exhibitor:latest

Once the container is up, confirm Exhibitor is running:

    $ curl -s localhost:8181/exhibitor/v1/cluster/status | python -m json.tool
    [
        {
            "code": 3, 
            "description": "serving", 
            "hostname": "<host>", 
            "isLeader": true
        }
    ]
_See Exhibitor's [wiki](https://github.com/Netflix/exhibitor/wiki/REST-Introduction) for more details on its REST API._

You can also check Exhibitor's web UI at `http://<host>:8181/exhibitor/v1/ui/index.html`

Then confirm ZK is available:

    $ echo ruok | nc <host> 2181
    imok