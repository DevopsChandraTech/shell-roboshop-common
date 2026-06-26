#!/bin/bash

source ./common.sh

app_name="catalogue"
SCRIPT_DIR=$PWD
MONGODB_HOST="mongodb.devaws.shop"

check_root
app_setup
nodejs_setup
restart_service
print_total_time


cp /$SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copy mongo repo service"

dnf install mongodb-mongosh -y &>> $LOG_FILE
VALIDATE $? "Install mongodb client"

INDEX=$(mongosh mongodb.devaws.shop --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $INDEX -le 1 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js &>> $LOG_FILE
    VALIDATE $? "Create Schema"
else
    echo -e "$app_name products already exist $Y Skipping $N"
fi

restart_service
print_total_time
