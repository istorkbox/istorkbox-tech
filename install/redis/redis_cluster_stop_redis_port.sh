#!/bin/bash

#start redis with redis user account
if [ $# -ne 1 ];
then 
  echo "usage: ./$0 port"
  exit 1
else
  /usr/local/redis/bin/redis-cli -p $1 shutdown
fi


