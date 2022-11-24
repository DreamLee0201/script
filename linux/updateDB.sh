#!/bin/bash
#数据源
HOST1="192.168.8.101"
PORT1="3306"
USER1="root"
PASSWD1="root1q2w3e4R"

cd $(dirname $0)
CURRENT_DIR=`pwd`
DATE=`date +%F`
TIME=`date "+%Y-%m-%d_%H_%M_%S"`

DB1="datareport"
TABLE_NAME1="FILL_CONTRACT_SUB_SUPPLY_CONTRACT_ACCOUNT"
mkdir -pv ${CURRENT_DIR}/${DATE}/${DB1}/

#TABLES1=`mysql -h $HOST1 -P $PORT1 -u $USER1 -p$PASSWD1 -Bse 'use datareport;show tables'`
mysqldump -h ${HOST1} -P ${PORT1} -u ${USER1} -p${PASSWD1} --single-transaction --master-data=0 --extended-insert=false ${DB1} ${TABLE_NAME1} > ${CURRENT_DIR}/${DATE}/${DB1}/${TABLE_NAME1}.sql


#目标数据库
HOST2="192.168.18.213"
PORT2="3300"
USER2="museum"
PASSWD2="abc123!@#"
DB_NAME2="museum"
FILE_DIR=${CURRENT_DIR}/${DATE}/${DB1}

TABLES=`ls ${FILE_DIR}`
for TABLE_NAME in ${TABLES}
  do
    mysql -h ${HOST2} -P ${PORT2} -u ${USER2} -p${PASSWD2} -D ${DB_NAME2} < ${FILE_DIR}/${TABLE_NAME}
    echo "${TABLE_NAME} is excuted!"
  done
  
rm -rf ${CURRENT_DIR}/${DATE}
echo "Done!!!"



