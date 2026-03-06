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
MONGODB_HOST=mongodb.devaws.shop

mkdir -p /var/log/shell-roboshop
echo "the script started at $(date)"

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

NODEJS_SETUP(){
    dnf module disable nodejs -y &>> $LOG_FILE
    VALIDATE $? "Disable nodejs"
    dnf module enable nodejs:20 -y &>> $LOG_FILE
    VALIDATE $? "Enable nodejs"
    dnf install nodejs -y &>> $LOG_FILE
    VALIDATE $? "Install nodejs"
    npm install &>> $LOG_FILE
    VALIDATE $? "Install Dependencies"
    cp $SCRIPT_DIR/catalogue.service /etc/systemd/system/catalogue.service 
    VALIDATE $? "Creating Service"
}

SYSTEMD_SETUP(){
    systemctl daemon-reload
    systemctl enable catalogue  &>> $LOG_FILE
    VALIDATE $? "Enable Service"
}

APP_SETUP(){
    mkdir -p /app  &>> $LOG_FILE
    VALIDATE $? "Create Directory"
    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>> $LOG_FILE
    VALIDATE $? "Download Code"
    cd /app
    VALIDATE $? "Enter app Directory"
    rm -rf /app/*
    VALIDATE $? "Remove code"
    unzip /tmp/$app_name.zip &>> $LOG_FILE
    VALIDATE $? "Unzip Code"
}

RESTART_SERVICE(){
    systemctl restart $app_name
    VALIDATE $? "Restarted $app_name"
}

PRINT_TOTAL_TIME(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(( $END_TIME - $START_TIME ))
    echo -e "the script executed in: $Y $TOTAL_TIME $N Seconds."
}
