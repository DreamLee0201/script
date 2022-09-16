FROM mysql:5.7

MAINTAINER jeecgos@163.com

ENV TZ=Asia/Shanghai

RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY ./init.sql /docker-entrypoint-initdb.d/

COPY ./mysqld.cnf /etc/mysql/mysql.conf.d/
