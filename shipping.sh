#!/bin/bash
source ./common.sh

app_name="shipping"
SCRIPT_DIR=$PWD

check_root
app_setup
systemd_setup

dnf install mysql -y &>> $LOG_FILE
VALIDATE $? "Install mysql"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities' &>> $LOG_FILE
if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql  &>> $LOG_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>> $LOG_FILE
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>> $LOG_FILE
else
    echo -e "$app_name products already loaded $Y Skipping..! $N"
fi

restart_service
print_total_time
