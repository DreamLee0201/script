#!/bin/bash
HOST="192.168.18.128"
PORT="3302"
USER="root"
PASSWD="123456"
DB_NAME="cloud"
FILE_DIR="show"
date=`date +%F`
cd $(dirname $0)
TABLES=`ls ${FILE_DIR}`
for TABLE_NAME in ${TABLES}
  do
    mysql -h ${HOST} -P ${PORT} -u ${USER} -p${PASSWD} -D ${DB_NAME} < ${FILE_DIR}/${TABLE_NAME}
    echo "${TABLE_NAME} is excuted!"
  done
  
echo "Done!!!"


