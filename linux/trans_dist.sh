#!/bin/bash
RESOURCE_PROJECT_DIR='/tmp'
DEST_SERVER='localhost'
DEST_SSH_PORT='22'
USER_NAME='root'
ENV=$1

#测试环境
function deploy_test_env() {
  RESOURCE_PROJECT_DIR='/home/cscec/code/server/static/pm_jeecg'
  DEST_SERVER='192.168.18.213'
}

function deploy_tongtest_env() {
  RESOURCE_PROJECT_DIR='/opt/cloud_tong/frontend/server/static/pm_jeecg'
  DEST_SERVER='192.168.18.213'
}

function deploy_res83test_env() {
  RESOURCE_PROJECT_DIR='/opt/cloud_83resource/frontend/server/static/pm_jeecg'
  DEST_SERVER='192.168.18.213'
}

function deploy_kjgtest_env() {
  RESOURCE_PROJECT_DIR='/home/zjbj/science-museum-vue/server/static/pm_jeecg'
  DEST_SERVER='192.168.18.211'
}

function deploy_kjgtest_app_env() {
  RESOURCE_PROJECT_DIR='/home/zjbj/science-museum-vue/server/static/jeecg_boot_app_22'
  DEST_SERVER='192.168.18.211'
}


#生产环境
function deploy_prod_env() {
  #RESOURCE_PROJECT_DIR='/home/zjbj/newServer/publush_server/static/pm_jeecg'
  #DEST_SERVER='121.43.150.137'
  #DEST_SSH_PORT='3822'
  echo ''
}

function deploy_tongprod_env() {
  RESOURCE_PROJECT_DIR='/usr/local/cloud_tong/frontend/server/static/pm_jeecg'
  DEST_SERVER='121.43.150.137'
  DEST_SSH_PORT='3822'
}

function deploy_83resprod_env() {
  RESOURCE_PROJECT_DIR='/usr/local/cloud_83resource/frontend/server/static/pm_jeecg'
  DEST_SERVER='121.43.150.137'
  DEST_SSH_PORT='3822'
}

function deploy_show_env() {
  RESOURCE_PROJECT_DIR='/usr/local/cloud_show/frontend/server/static/pm_jeecg'
  DEST_SERVER='121.43.150.137'
  DEST_SSH_PORT='3822'
}

function deploy_uat_env() {
  RESOURCE_PROJECT_DIR='/usr/local/cloud_uat/frontend/server/static/pm_jeecg'
  DEST_SERVER='121.43.150.137'
  DEST_SSH_PORT='3822'
}

function deploy_kjgprod_env() {
  RESOURCE_PROJECT_DIR='/opt/cloud_museum/frontend/server/static/pm_jeecg'
  DEST_SERVER='36.152.119.148'
  DEST_SSH_PORT='9122'
}

function deploy_kjgprod_app_env() {
  RESOURCE_PROJECT_DIR='/opt/cloud_museum/frontend/server/static/jeecg_boot_app_22'
  DEST_SERVER='36.152.119.148'
  DEST_SSH_PORT='9122'
}


case ${ENV} in
 test)
    deploy_test_env
    ;;
 tong_test)
    deploy_tongtest_env
    ;;
 83res_test)
    deploy_res83test_env
    ;;
 kjg_test)
    deploy_kjgtest_env
    ;;
 kjg_test_app)
    deploy_kjgtest_app_env
    ;;
 prod)
    deploy_prod_env
    ;;
 tong_prod)
    deploy_tongprod_env
    ;;
 83res_prod)
    deploy_83resprod_env
    ;;
 show)
    deploy_show_env
    ;;
 uat)
    deploy_uat_env
    ;;
 kjg_prod)
    deploy_kjgprod_env
    ;;
 kjg_prod_app)
    deploy_kjgprod_app_env
    ;;
 *)
    echo "Usage: $name [package-jar-name] [port] [test|tong_test|83res_test|prod|tong_prod|83res_prod|show|uat|kjg_test|kjg_test_app|kjg_prod]"
    exit 1
    ;;
esac


mkdir -pv ${ENV}
tar -zxf dist_${ENV}.tar.gz -C ${ENV}
#cp -rf ${ENV}/dist/* $RESOURCE_PROJECT_DIR/
scp -P ${DEST_SSH_PORT} -r ${ENV}/dist/* ${USER_NAME}@${DEST_SERVER}:${RESOURCE_PROJECT_DIR}/
rm -rf ${ENV}/ dist_${ENV}.tar.gz




