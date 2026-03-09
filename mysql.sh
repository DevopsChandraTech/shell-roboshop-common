#!/bin/bash

source ./common.sh #calling common code using this source is source of the file and . -> current directory

CHECK_ROOT #checks root user privilizes or not in common script

dnf install mysql-server -y &>>LOG_FILE
VALIDATE $? "Installing MySql"
systemctl enable mysqld &>>LOG_FILE
VALIDATE $? "Enable MySql"
systemctl start mysqld &>>LOG_FILE
VALIDATE $? "Start MySql" 
mysql_secure_installation --set-root-pass RoboShop@1 &>>LOG_FILE
VALIDATE $? "Set Password"

PRINT_TOTAL_TIME

