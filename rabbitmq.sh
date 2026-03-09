#!/bin/bash
source ./common.sh

CHECK_ROOT

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>> LOG_FILE
dnf install rabbitmq-server -y &>> LOG_FILE
VALIDATE $? "Installing Rabbitmq Server"
systemctl enable rabbitmq-server &>> LOG_FILE
VALIDATE $? "Enable rabbitmq server"
systemctl start rabbitmq-server &>> LOG_FILE
VALIDATE $? "Start Rabbitmq Server"
rabbitmqctl add_user roboshop roboshop123 &>> LOG_FILE
VALIDATE $? "Adding roboshop User"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> LOG_FILE
VALIDATE $? "Setting Permissions"

PRINT_TOTAL_TIME
