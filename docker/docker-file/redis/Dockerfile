FROM redis:5.0.5

MAINTAINER 595394202@qq.com

ENV TZ=Asia/Shanghai

RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY ./init.sql /docker-entrypoint-initdb.d/

COPY ./mysqld.cnf /etc/mysql/mysql.conf.d/

