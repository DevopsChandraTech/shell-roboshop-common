#!/bin/bash

#colours for script
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

#log folder creation 
LOG_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
START_TIME=$(date +%s)
mkdir -p /var/log/shell-roboshop

# checks user with root priviliges or not
USER_ID=$(id -u)
CHECK_ROOT(){
    if [ $USER_ID -ne 0 ]; then
        echo "Error:: Run Command With Root User Privilizes."
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N" | tee -a $LOG_FILE
    fi
}

PRINT_TOTAL_TIME(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME-$START_TIME ))
    echo -e "the script executed in: $Y $TOTAL_TIME $N Seconds."
}
