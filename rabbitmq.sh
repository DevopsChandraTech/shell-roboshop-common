#!/bin/bash
source ./common.sh

CHECK_ROOT

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo
dnf install rabbitmq-server -y
VALIDATE $? "Installing Rabbitmq Server"
systemctl enable rabbitmq-server
VALIDATE $? "Enable rabbitmq server"
systemctl start rabbitmq-server
VALIDATE $? "Start Rabbitmq Server"
rabbitmqctl add_user roboshop roboshop123
VALIDATE $? "Adding roboshop User"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "Setting Permissions"

PRINT_TOTAL_TIME
