#!/bin/bash
#coding=utf-8
#作用: 本脚本旨在在容器启动后把配置文件和需要启动程序进行配置和创建

#export GO111MODULE="on"
#export GOPROXY="https://goproxy.cn"

#run config
#cp ./supervisord.conf /etc/supervisor/

#create path for log
#mkdir -p /var/log/your_need_dic
#chmod -R 777 /var/log/your_need_dic

cd $GOPATH/src/gome && go mod init && go mod tidy

#start supervisord
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf

#tail -f /dev/null
