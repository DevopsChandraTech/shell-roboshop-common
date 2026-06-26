#!/bin/bash

source ./mongodb.sh

check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOG_FILE
VALIDATE $? "Adding mongo repo"

dnf install mongodb-org -y  &>> $LOG_FILE
VALIDATE $? "Installing mongodb"

systemctl enable mongod &>> $LOG_FILE
VALIDATE $? "Enable mongodb"

systemctl start mongod &>> $LOG_FILE
VALIDATE $? "Start mongodb" 

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Alowing remote connections"

systemctl restart mongod 
VALIDATE $? "Restart mongod"

print_total_time



