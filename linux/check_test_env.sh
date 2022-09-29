#!/bin/bash

source /etc/profile

# 日志颜色
COLOR_G="\x1b[0;32m"
COLOR_Y="\x1b[0;33m"
COLOR_R="\x1b[0;31m"
RESET="\x1b[0m"
TIME=`date "+%Y-%m-%d %H:%M:%S"`

function info(){
  echo -e "${COLOR_G}[$TIME] [Info] ${1}${RESET}"
}

function warn()
{
  echo -e "${COLOR_Y}[$TIME] [Warn] ${1}${RESET}"
}

function error()
{
  echo -e "${COLOR_R}[$TIME] [Error] ${1}${RESET}"
}

PID_NUM_5040=`ps -ef|grep -v grep|grep server.port=5040|wc -l`
PID_NUM_5041=`ps -ef|grep -v grep|grep server.port=5041|wc -l`
PID_NUM_5050=`ps -ef|grep -v grep|grep server.port=5050|wc -l`
PID_NUM_5051=`ps -ef|grep -v grep|grep server.port=5051|wc -l`

RUNNING_NUM_5040=`netstat -tunlp|grep ':5040 '|awk '{print $7}'|cut -d '/' -f 1|wc -l`
RUNNING_NUM_5041=`netstat -tunlp|grep ':5041 '|awk '{print $7}'|cut -d '/' -f 1|wc -l`
RUNNING_NUM_5050=`netstat -tunlp|grep ':5050 '|awk '{print $7}'|cut -d '/' -f 1|wc -l`
RUNNING_NUM_5051=`netstat -tunlp|grep ':5051 '|awk '{print $7}'|cut -d '/' -f 1|wc -l`

RUNNING_NUM_7089=`netstat -tunlp|grep ':7089 '|awk '{print $7}'|cut -d '/' -f 1|wc -l`
RUNNING_NUM_80=`netstat -tunlp|grep ':80 '|awk '{print $7}'|cut -d '/' -f 1|wc -l`
RUNNING_NUM_88=`netstat -tunlp|grep ':88 '|awk '{print $7}'|cut -d '/' -f 1|wc -l`
RUNNING_NUM_8091=`netstat -tunlp|grep ':8091 '|awk '{print $7}'|cut -d '/' -f 1|wc -l`


#帆软
if [ $RUNNING_NUM_88 -le 0 ];then
  error "帆软，【重启】"
  cd /home/cscec/fine_report_tomcat/bin
  nohup ./startup.sh &
else
  info "帆软，不需要重启"
fi




#nginx_88
if [ $RUNNING_NUM_88 -le 0 ];then
  error "nginx_88，【重启】"
  cd /home/cscec/jenkins/nginx/sbin
  nohup ./nginx &
else
  info "nginx_88，不需要重启"
fi




#砼智慧测试 前端
if [ $RUNNING_NUM_7089 -le 0 ];then
  error "砼智慧测试 前端，【重启】"
  cd /opt/cloud_tong/frontend/server
  nohup ./startup.sh &
else
  info "砼智慧测试 前端，不需要重启"
fi

#砼智慧测试 后端
if [ $RUNNING_NUM_5040 -le 0 -a $RUNNING_NUM_5041 -le 0 ];then
  if [ $PID_NUM_5040 -le 0 -a $PID_NUM_5041 -le 0 ];then
    error "砼智慧测试 后端，【运行异常】"
    cd /opt/cloud_tong/backend
    nohup ./start_cloudTong.sh &
  else
    warn "砼智慧测试 后端，【正在重启。。。】"
  fi
else
  info "砼智慧测试 后端，不需要重启"
fi




#管理平台测试 前端
if [ $RUNNING_NUM_80 -le 0 ];then
  error "管理平台测试 前端，【重启】"
  cd /home/cscec/code/server
  nohup ./startup.sh &
else
  info "管理平台测试 前端，不需要重启"
fi

#管理平台测试 后端
if [ $RUNNING_NUM_5050 -le 0 -a $RUNNING_NUM_5051 -le 0 ];then
  if [ $PID_NUM_5050 -le 0 -a $PID_NUM_5051 -le 0 ];then
    error "管理平台测试 后端，【运行异常】"
    cd /home/cscec/runtime
    nohup ./start_2jeecgboots.sh &
  else
    warn "管理平台测试 后端，【正在重启。。。】"
  fi
else
  info "管理平台测试 后端，不需要重启"
fi

