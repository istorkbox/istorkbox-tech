#!/bin/bash

#start redis with redis user account
if [ $# -ne 1 ];
then 
  echo "usage: ./$0 port"
  exit 1
else
  su - redis -l -c "/usr/local/redis/bin/redis-server /home/redis/$1/redis_$1.conf"
fi


