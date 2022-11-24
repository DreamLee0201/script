#!/bin/bash
TIME=`date "+%Y-%m-%d_%H_%M_%S"`
FILE_NAME="dist.tar.gz"
SOURCE_DIR="dist"
DEST_DIR="pm_jeecg"

if [ -e ${FILE_NAME} ];then
    tar -zxf ${FILE_NAME}
    rm -rf ${DEST_DIR}/*
    mv ${DEST_DIR}/* ${FILE_NAME}/
    rm -rf dist
    mv ${FILE_NAME} backup/${FILE_NAME}_${TIME}
fi

find ./backup -mtime +60 -name 'dist_*' -exec rm -rf {} \;