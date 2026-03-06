#!/bin/bash
source ./common.sh
app_name="catalogue"
APP_SETUP
NODEJS_SETUP
SYSTEMD_SETUP


id roboshop &>> $LOG_FILE
if [ $? -ne 0 ]; then
    useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>> $LOG_FILE
    VALIDATE $? "Creating User"
else 
    echo -e "User Already Exist....! $Y SKIPPING $N" &>> $LOG_FILE
fi

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copy mongodb repo"

dnf install mongodb-mongosh -y  &>> $LOG_FILE
VALIDATE $? "Install mongosh"

INDEX=$(mongosh mongodb.devaws.shop --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Load $app_name products"
else
    echo -e "$app_name products already loaded ... $Y SKIPPING $N"
fi

systemctl restart $app_name
VALIDATE $? "Restarted $app_name"
