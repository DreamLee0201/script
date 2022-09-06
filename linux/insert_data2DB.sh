#!/bin/bash
HOST=""
PORT="3306"
USER="cloud_dump"
PASSWD=""
DB_NAME=""
FILE_DIR=""
date=`date +%F`

TABLES=`ls ${FILE_DIR}`
for TABLE_NAME in ${TABLES}
  do
    mysql -h ${HOST} -P ${PORT} -u ${USER} -p${PASSWD} -D ${DB_NAME} < ${FILE_DIR}/${TABLE_NAME}
	echo "${TABLE_NAME}.sql is excuted!"
  done
  
echo "Done!!!"


