#!/bin/bash

source ./common.sh #calling common code using this source is source of the file and . -> current directory

CHECK_ROOT #checks root user privilizes or not in common script

dnf install mysql-server -y
VALIDATE $? "Installing MySql"
systemctl enable mysqld
VALIDATE $? "Enable MySql"
systemctl start mysqld 
VALIDATE $? "Start MySql" 
mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Set Password"

PRINT_TOTAL_TIME

