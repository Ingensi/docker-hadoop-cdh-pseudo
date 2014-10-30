# docker-cdh-pseudo-distributed

Docker container which contains a Cloudera distribution in pseudo distributed. It provides au pseudo distributed Hadoop cluster with the following services: 

* *HDFS*: 1 namenode and 1 datanode
* *YARN*: 1 resourcemanager, 1 nodemanager and 1 historyserver (mapreduce)

*WARNING*: This docker image can be *useful to speed up your developments* but it *should not be used in critical/production environments* for two main reasons:

* it does not provide a fully distributed cluster
* because it runs many hadoop processes, this image does not respect the docker "best practice" about `One container = One process`

# Run instruction

The docker run command has to be written according to your specific needs. Here is the pattern to follow:

```
# general command
docker run -d \
# hdfs data binding
  -v HDFS_DATA_PATH:/var/lib/hadoop-hdfs/cache:rw \

# eventually overwrite default container configuration (see container configuration section)
  -v CONTAINER_CONFIGURATION_PATH:/root/conf.sh:ro \

# bind logs to easily debug services
  -v HOST_HDFS_LOG_PATH:/var/log/hadoop-hdfs:rw \
  -v HOST_YARN_LOG_PATH:/var/log/hadoop-yarn:rw \

# overwrite some hadoop configuration files (see overwrite hadoop configuration)
  -v HADOOP_CONF_PATH:/tmp/hadoop_conf/

# bind ports with the host (see port mapping)
  -p 8020:8020 \n \

ingensi/cdh-pseudo-distributed
```

## Container configuration

At startup, an init script is launched in the container. It uses global variables defined in /root/conf.sh to run the startup procedure. To enable or disable some initialization steps, you can mount an host file that defines your own global variables and bind it to /root/conf.sh (to overwrite default file). Here is the list of all defined flobal variables:

* `FORMAT_HDFS`: true=try to format the namenode (default=true)
* `INITIALIZE_HDFS`: true=create all HDFS directories needed by hadoop services (default=true)

## Overwrite default hadoop configuration

Default configurations included in the container are provided by the official Cloudera RPM. If you want to customize some files, just create a volume as described below. Each file will be copied (cp -rf) in the hadoop configuration directory at startup.

Target configuration directories in the container:

* `/tmp/hadoop_conf`: files mounted in this directory will be copied in `/etc/hadoop/conf/`

## Port mapping

All hadoop ports are exposed by default. You can map some ports to your host by using the `-p` argument. Here is the list of all exposed ports:

* *HDFS datanode*
  * `50010` (TCP): dfs.datanode.address (DataNode HTTP server port)
  * `1004` secure (TCP): dfs.datanode.address
  * `50075` (TCP): dfs.datanode.http.address
  * `1006` secure (TCP): dfs.datanode.http.address
  * `50020` (TCP): dfs.datanode.ipc.address
* *HDFS namenode*
  * `8020` (TCP): fs.default.name / fs.defaultFS
  * `50070` (TCP): dfs.http.address / dfs.namenode.http-address
  * `50470` secure (TCP): dfs.https.address / dfs.namenode.https-address
* *YARN resourcemanager*
  * `8032` (TCP): yarn.resourcemanager.address
  * `8030` (TCP): yarn.resourcemanager.scheduler.address
  * `8031` (TCP): yarn.resourcemanager.resource-tracker.address
  * `8033` (TCP): yarn.resourcemanager.admin.address
  * `8088` (TCP): yarn.resourcemanager.webapp.address
* *YARN nodemanager*
  * `8040` (TCP): yarn.nodemanager.localizer.address
  * `8042` (TCP): yarn.nodemanager.webapp.address
  * `8041` (TCP): yarn.nodemanager.address
* *MAPREDUCE historyserver*
  * `10020` (TCP): mapreduce.jobhistory.address
  * `19888` (TCP): mapreduce.jobhistory.webapp.address

# Oracle license

This container includes an Oracle JDK. By using this container, you accept the Oracle Binary Code License Agreement for Java SE available here: http://www.oracle.com/technetwork/java/javase/terms/license/index.html
