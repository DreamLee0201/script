#!/bin/bash
SCRIPT_NAME=$0
package_name="cscec83.jar"
runtime_path="/opt/cloud_83resource/backend"
PORT1=5020
PORT2=5021
TIME=`date "+%Y-%m-%d_%H_%M_%S"`

function start_proc_prefer()
{
    if [ $1 -eq $PORT1 ];then
        other_port=$PORT2
    else
        other_port=$PORT1
    fi
    
    #先启动占用$1端口的Java进程
    start_time=`date --date='0 days ago' "+%Y-%m-%d %H:%M:%S"`
    echo "The service:$1 is starting......"
    rm -f ${runtime_path}/catalina_$1.out
    nohup java -jar ${runtime_path}/${package_name} --server.port=$1 >./catalina_$1.out 2>&1 &
    OLDPID_OTHER=`netstat -tunlp|grep ${other_port}|awk '{print $7}'|cut -d '/' -f 1`
    OLDPID_NUM_OTHER=`netstat -tunlp|grep ${other_port}|awk '{print $7}'|cut -d '/' -f 1|wc -l`
    while true
    do 
        PID_CURR=`netstat -tunlp|grep $1|awk '{print $7}'|cut -d '/' -f 1|wc -l`
        if [ $PID_CURR -gt 0 ];then
            if [ $OLDPID_NUM_OTHER -gt 0 ];then
                kill -15 $OLDPID_OTHER
                echo "The service:${other_port} is stopped."
            fi
            break
        else
            sleep 5
        fi
    done
    finish_time=`date --date='0 days ago' "+%Y-%m-%d %H:%M:%S"`
    duration=$(($(($(date +%s -d "$finish_time")-$(date +%s -d "$start_time")))))
    echo "The service:$1 is started."
    echo "The service:$1 execution duration: $duration seconds"
    
    #再启动占用$other_port端口的Java进程
    #rm -f ${runtime_path}/catalina_${other_port}.out
    #nohup java -jar ${runtime_path}/${package_name} --server.port=${other_port} >./catalina_${other_port}.out 2>&1 &
}


if [ -e ../${package_name} ];then
    rm -f ${package_name}
    mv ../${package_name} ./
fi

#FLAG=true
#while (($FLAG = true))
#do 
#    IS_SCRIPT_RUNNING=`ps -ef|grep -v grep|grep $SCRIPT_NAME|wc -l`
#    if [ $IS_SCRIPT_RUNNING -gt 2 ];then
#        echo $IS_SCRIPT_RUNNING
#        echo "Waiting another program running this script:$SCRIPT_NAME."
#        sleep 3
#    else
#        FLAG=false
#        break
#    fi
#done

OLDPID_1=`netstat -tunlp|grep $PORT1|awk '{print $7}'|cut -d '/' -f 1`
OLDPID_NUM_1=`netstat -tunlp|grep $PORT1|awk '{print $7}'|cut -d '/' -f 1|wc -l`
OLDPID_NUM_2=`netstat -tunlp|grep $PORT2|awk '{print $7}'|cut -d '/' -f 1|wc -l`
#OLDPID_1=`ps -ef|grep -v grep|grep server.port=$PORT1|awk '{print $2}'`
#OLDPID_NUM_1=`ps -ef|grep -v grep|grep server.port=$PORT1|wc -l`
#OLDPID_NUM_2=`ps -ef|grep -v grep|grep server.port=$PORT2|wc -l`
if [ $OLDPID_NUM_1 -gt 0 ];then
    if [ $OLDPID_NUM_2 -gt 0 ];then
        kill -15 $OLDPID_1
        start_proc_prefer $PORT1
        echo "start port:$PORT1"
    else
        start_proc_prefer $PORT2
        echo "start port:$PORT2"
    fi
else
    start_proc_prefer $PORT1
    echo "start port:$PORT1"
fi
