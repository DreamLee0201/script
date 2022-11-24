#!/bin/bash
HOST="rm-bp15562vwk0phub9xho.mysql.rds.aliyuncs.com"
PORT="3306"
USER="cloud_uat"
PASSWD="CloudUat@0900"
DB_NAME="cloud_uat"
FILE_DIR="/root/DB_backup/test/2022-10-18/cloud"
date=`date +%F`
cd $(dirname $0)
TABLES=`ls ${FILE_DIR}`
for TABLE_NAME in ${TABLES}
  do
    mysql -h ${HOST} -P ${PORT} -u ${USER} -p${PASSWD} -D ${DB_NAME} < ${FILE_DIR}/${TABLE_NAME}
    echo "${TABLE_NAME} is excuted!"
  done
  
echo "Done!!!"



