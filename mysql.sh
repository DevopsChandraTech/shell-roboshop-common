#!/bin/bash

source ./common.sh

dnf install mysql-server -y &>> $LOG_FILE
VALIDATE $? "Installing MySql"
systemctl enable mysqld &>> $LOG_FILE
VALIDATE $? "Enable MySql"
systemctl start mysqld  &>> $LOG_FILE
VALIDATE $? "Start MySql Service"
mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOG_FILE
VALIDATE $? "Setting root pasword"

print_total_time