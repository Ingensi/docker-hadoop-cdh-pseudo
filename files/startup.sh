#!/bin/bash

. /root/conf.sh

if ${FORMAT_HDFS}; then
  # format namenode
  su -c "echo 'N' | hdfs namenode -format" hdfs
fi

if ${INITIALIZE_HDFS}; then
  # 1 start hdfs
  su -c "hdfs datanode  2>&1 > /var/log/hadoop-hdfs/hadoop-hdfs-datanode.log" hdfs&
  su -c "hdfs namenode  2>&1 > /var/log/hadoop-hdfs/hadoop-hdfs-namenode.log" hdfs&

  # 2 wait for process starting
  sleep 3

  # 3 exec cloudera hdfs init script
  /usr/lib/hadoop/libexec/init-hdfs.sh

  # 4 stop hdfs
  killall java
fi

# copy hadoop confs
cp -rf /tmp/hadoop_conf/* /etc/hadoop/conf/

# run supervisord
exec supervisord -c /etc/supervisord.conf
