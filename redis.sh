#!/bin/bash

source ./common.sh

check_root

dnf module disable redis -y &>> $LOG_FILE
VALIDATE $? "disable redis"
dnf module enable redis:7 -y &>> $LOG_FILE
VALIDATE $? "enable redis"
dnf install redis -y &>> $LOG_FILE
VALIDATE $? "Install redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "allowing remote connections"

systemctl enable redis &>> $LOG_FILE
VALIDATE $? "Enable redis"
systemctl restart redis &>> $LOG_FILE
VALIDATE $? "restart redis"

print_total_time