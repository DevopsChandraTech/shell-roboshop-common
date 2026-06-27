#!/bin/bash

source ./common.sh

app_name="payment"
SCRIPT_DIR=$PWD

check_root

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>> $LOG_FILE
VALIDATE $? "copying rabbitmq repo"
dnf install rabbitmq-server -y &>> $LOG_FILE
VALIDATE $? "Installing Server"
systemctl enable rabbitmq-server &>> $LOG_FILE
VALIDATE $? "Enable Server"
systemctl start rabbitmq-server &>> $LOG_FILE
VALIDATE $? "Start the Server"
rabbitmqctl add_user roboshop roboshop123 &>> $LOG_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $LOG_FILE
VALIDATE $? "Set Permissions to User"