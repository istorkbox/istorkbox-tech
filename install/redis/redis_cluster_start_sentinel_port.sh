#!/bin/bash

if [ $# -ne 1 ];
then 
  echo "usage: ./$0 port"
  exit 1
else
#start redis_sentinel with redis user account
su - redis -l -c "/usr/local/redis/bin/redis-server /home/redis/$1/redis_sentinel_$1.conf --sentinel"

fi



