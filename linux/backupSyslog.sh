#!/bin/bash
HOST="rm-bp15562vwk0phub9xho.mysql.rds.aliyuncs.com"
PORT="3306"
USER="cloud_dump"
PASSWD="Cloud_dump_20220901@zjbj"
DB_NAME="cloud"
TABLE_NAME="sys_log"
TIME=`date "+%Y-%m-%d_%H_%M_%S"`

mysqldump -h ${HOST} -P ${PORT} -u ${USER} -p${PASSWD} --single-transaction --master-data=2 --databases ${DB_NAME} --tables ${TABLE_NAME} --where="TO_DAYS(now())-TO_DAYS(create_time)>30" > ${TABLE_NAME}_${TIME}.sql

mysql -h ${HOST} -P ${PORT} -u ${USER} -p${PASSWD} -D ${DB_NAME} -e "DELETE FROM sys_log WHERE TO_DAYS(now())-TO_DAYS(create_time)>30"

#--execute="SELECT * FROM cost_list where TO_DAYS(now())-TO_DAYS(create_time)>30;"