#!/bin/bash

TIME=`date "+%Y%m%d_%H%M%S"`
PKG_NAME=$1
PORT=$2
cd $(dirname $0)
CURRENT_DIR=`pwd`

function start()
{
  ProcNum=`ps -ef|grep "${CURRENT_DIR}/${PKG_NAME} --server.port=$PORT"|grep -v 'grep'|wc -l`
  if [ $ProcNum -gt 0 ];then
    echo "The service has already started!"
  else
    if [ -e ${PKG_NAME} ];then
      nohup java -jar ${CURRENT_DIR}/${PKG_NAME} --server.port=$PORT >./catalina_$PORT.out 2>&1 &
      echo "The service is starting!"
    else 
      echo "There is no package to start!"
    fi
  fi
}

function stop()
{
  ProcNum=`ps -ef|grep "${CURRENT_DIR}/${PKG_NAME} --server.port=$PORT"|grep -v 'grep'|wc -l`
  PID=`ps -ef|grep "${CURRENT_DIR}/${PKG_NAME} --server.port=$PORT"|grep -v 'grep'|awk '{print $2}'`
  if [ $ProcNum -gt 0 ];then
    kill -9 $PID
  fi
}

function restart()
{
  stop
  start
}

name=`basename $0 .sh`
case $3 in
 start)
        start
        ;;
 stop)
        stop
        ;;
 restart)
        restart
        ;;
 *)
        echo "Usage: $name [package-jar-name] [port] [start|stop|restart]"
        exit 1
        ;;
esac
