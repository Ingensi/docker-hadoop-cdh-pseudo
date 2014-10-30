#!/bin/bash

# Script executed by supervisord as bootstrap
####

# It manager the hadoop processes startup sequence via
# the systemctl command. This is the only script launched
# at startup by supervisord.

# 1 HDFS
supervisorctl start hdfs-namenode hdfs-datanode

# 2 YARN
supervisorctl start yarn-resourcemanager yarn-nodemanager mapreduce-historyserver
