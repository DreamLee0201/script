#!/bin/bash
#passwd:root0900
ENV=$1

case ${ENV} in
 test)
    echo "你在部署 管理平台测试环境前端。。。"
    ;;
 tong_test)
    echo "你在部署 砼智慧测试环境前端。。。"
    ;;
 83res_test)
    echo "你在部署 八三资源库测试环境前端。。。"
    ;;
 kjg_test)
    echo "你在部署 科技馆测试环境前端。。。"
    ;;
 kjg_test_app)
    echo "你在部署 科技馆测试环境手机App端。。。"
    ;;
 prod)
    echo "你在部署 管理平台【生产】环境前端。。。"
    ;;
 tong_prod)
    echo "你在部署 砼智慧【生产】环境前端。。。"
    ;;
 83res_prod)
    echo "你在部署 八三资源库【生产】环境前端。。。"
    ;;
 show)
    echo "你在部署 对外展示平台前端。。。"
    ;;
 uat)
    echo "你在部署 uat环境前端。。。"
    ;;
 kjg_prod)
    echo "你在部署 科技馆【生产】环境前端。。。"
    ;;
 kjg_prod_app)
    echo "你在部署 科技馆【生产】环境手机App端。。。"
    ;;
 *)
    echo "Usage: $name [package-jar-name] [port] [test|tong_test|83res_test|prod|tong_prod|83res_prod|show|uat|kjg_test|kjg_test_app|kjg_prod]"
    exit 1
    ;;
esac

tar -zcf dist_${ENV}.tar.gz dist/
scp ./dist_${ENV}.tar.gz root@192.168.18.213:/home/cscec/jenkins/temp/
rm -rf dist_${ENV}.tar.gz
ssh root@192.168.18.213 "source /etc/profile;cd /home/cscec/jenkins/temp;sh trans_dist.sh ${ENV}"

