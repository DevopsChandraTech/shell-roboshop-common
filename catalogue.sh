#!/bin/bash
source ./common.sh
CHECK_ROOT
app_name="catalogue"
APP_SETUP
NODEJS_SETUP
SYSTEMD_SETUP

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copy mongodb repo"

dnf install mongodb-mongosh -y  &>> $LOG_FILE
VALIDATE $? "Install mongodb client"

INDEX=$(mongosh $MONGODB_HOST --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Load $app_name products"
else
    echo -e "$app_name products already loaded ... $Y SKIPPING $N"
fi

RESTART_SERVICE

PRINT_TOTAL_TIME
