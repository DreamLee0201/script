#!/bin/bash
HOST="192.168.18.213"
PORT="3307"
USER="manager_root"
PASSWD="ZjbjCloudTest@Qwe213"

cd $(dirname $0)
CURRENT_DIR=`pwd`
DATE=`date +%F`
TIME=`date "+%Y-%m-%d_%H_%M_%S"`

DB1="mysql"
DB2="cloud"
DB3="cloud_tong"
mkdir -pv {${CURRENT_DIR}/${DATE}/${DB1}/,${CURRENT_DIR}/${DATE}/${DB2}/,${CURRENT_DIR}/${DATE}/${DB3}/}
TABLES1=`mysql -h $HOST -P $PORT -u $USER -p$PASSWD -Bse 'use mysql;show tables'`
TABLES2=`mysql -h $HOST -P $PORT -u $USER -p$PASSWD -Bse 'use cloud;show tables'`
TABLES3=`mysql -h $HOST -P $PORT -u $USER -p$PASSWD -Bse 'use cloud_tong;show tables'`
for TABLE_NAME in ${TABLES1}
  do
    #开启执行备份，表的路径/backup_mysql/当天日期/数据库名/数据库表名
    mysqldump -h ${HOST} -P ${PORT} -u ${USER} -p${PASSWD} --single-transaction --master-data=2 ${DB1} ${TABLE_NAME} > ${CURRENT_DIR}/${DATE}/${DB1}/${TABLE_NAME}.sql
  done

for TABLE_NAME in ${TABLES2}
  do
    #开启执行备份，表的路径/backup_mysql/当天日期/数据库名/数据库表名
    mysqldump -h ${HOST} -P ${PORT} -u ${USER} -p${PASSWD} --single-transaction --master-data=2 ${DB2} ${TABLE_NAME} > ${CURRENT_DIR}/${DATE}/${DB2}/${TABLE_NAME}.sql
  done

for TABLE_NAME in ${TABLES3}
  do
    #开启执行备份，表的路径/backup_mysql/当天日期/数据库名/数据库表名
    mysqldump -h ${HOST} -P ${PORT} -u ${USER} -p${PASSWD} --single-transaction --master-data=2 ${DB3} ${TABLE_NAME} > ${CURRENT_DIR}/${DATE}/${DB3}/${TABLE_NAME}.sql
  done
  
  
if [[ -d ${DATE} ]];then 
  tar -zcvf ${CURRENT_DIR}/DB_${TIME}.tar.gz ${DATE}/
  rm -rf ${DATE}/
fi
echo ${DATE}'备份完成。'


#清理14天前的备份
find ${CURRENT_DIR} -mtime +14 -name 'DB_*' -exec rm -rf {} \;
