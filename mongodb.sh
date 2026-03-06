#!/bin/bash

source ./common.sh #calling common code using this source is source of the file and . -> current directory

CHECK_ROOT #checks root user privilizes or not in common script

#copy mongodb repo
cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Adding Mongo Repo" 

#install mongodb
dnf install mongodb-org -y &>> $LOG_FILE
VALIDATE $? "Installing Mongo Repo"

# enable mongodb
systemctl enable mongod | tee -a $LOG_FILE
VALIDATE $? "Enable Mongo Repo"

#start mongodb
systemctl start mongod | tee -a $LOG_FILE
VALIDATE $? "Start Mongo Repo"

# using sed update ip address for remote connection
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing Remote Connection"

#restart mongodb service
systemctl restart mongod
VALIDATE $? "Restart Mongodb Service"

PRINT_TOTAL_TIME # prints the total time of the script