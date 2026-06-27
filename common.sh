#!/bin/bash

echo "the script start executed in $(date)"
START_TIME=$(date +%s)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

check_root(){
    USERID=$(id -u) # show user id

    if [ $USERID -ne 0 ]; then
        echo "Error:: run command with root user privilizes" | tee -a $LOG_FILE
        exit 1
    fi
}


LOG_FOLDER="/var/log/shell-script"
SCRIPT_NAME=$(echo $0 | awk -F "." '{print $1}')
LOG_FILE="$LOG_FOLDER/$SCRIPT_NAME.log"
MONGODB_HOST="mongodb.devaws.shop"
MYSQL_HOST="mysql.devaws.shop"

mkdir -p $LOG_FOLDER

VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo "Error:: command not found" &>> $LOG_FILE
        exit 1
    else
        echo -e "$2 $G Success.$N" | tee -a $LOG_FILE
    fi
}

nodejs_setup(){
    dnf module disable nodejs -y &>> $LOG_FILE
    VALIDATE $? "Disable nodejs"
    dnf module enable nodejs:20 -y &>> $LOG_FILE
    VALIDATE $? "Enable nodejs"
    dnf install nodejs -y &>> $LOG_FILE
    VALIDATE $? "Install nodejs"
    # systemuser creation
    cd /app 
    VALIDATE $? "Change Directory"
    npm install &>> $LOG_FILE
    VALIDATE $? "Install Dependencies"
}

app_setup(){
    id roboshop &>> $LOG_FILE
    if [ $? -ne 0 ]; then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
    else
        echo -e "System user already exists $Y Skipping..!$N"
    fi
    mkdir -p /app &>> $LOG_FILE
    VALIDATE $? "Create Directory"
    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>> $LOG_FILE
    VALIDATE $? "Download code"
    rm -rf /app/*
    VALIDATE $? "Remove Content in App Directory"
    cd /app 
    VALIDATE $? "Change Directory"
    unzip /tmp/$app_name.zip &>> $LOG_FILE
    VALIDATE $? "Unzip the Code"
}

java_setup(){
    dnf install maven -y &>> $LOG_FILE
    VALIDATE $? "Install maven"
    mvn clean package &>> $LOG_FILE
    VALIDATE $? "Install Package" 
    mv target/$app_name-1.0.jar $app_name.jar &>> $LOG_FILE
    VALIDATE $? "Move jar file"
    cp /$SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service &>> $LOG_FILE
    VALIDATE $? "Coping repo"
}

python3_setup(){
    dnf install $app_name gcc $app_name-devel -y &>> $LOG_FILE
    VALIDATE $? "Installing $app_name"
    pip3 install -r requirements.txt &>> $LOG_FILE
    VALIDATE $? "Installing Requirments"
}

nginx_setup(){
    dnf module disable nginx -y  &>> $LOG_FILE
    VALIDATE $? "Disable nginx"
    dnf module enable nginx:1.24 -y &>> $LOG_FILE
    VALIDATE $? "Enable nginx"
    dnf install nginx -y &>> $LOG_FILE
    VALIDATE $? "Install nginx"
    systemctl enable nginx &>> $LOG_FILE
    VALIDATE $? "enable nginx"
    systemctl start nginx &>> $LOG_FILE
    VALIDATE $? "Start nginx"
    rm -rf /usr/share/nginx/html/* &>> $LOG_FILE
    VALIDATE $? "Remove default content"
    curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> $LOG_FILE
    VALIDATE $? "Download nginx code"
    cd /usr/share/nginx/html &>> $LOG_FILE
    VALIDATE $? "Change Directory"
    unzip /tmp/frontend.zip &>> $LOG_FILE
    VALIDATE $? "Unzip code"
    rm -rf /etc/nginx/nginx.conf
    cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf
    VALIDATE $? "Copying nginx.conf"
}

systemd_setup(){
    cp /$SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATE $? "Copy systemctl Service"
    systemctl daemon-reload &>> $LOG_FILE
    VALIDATE $? "daemon-reload"
    systemctl enable $app_name &>> $LOG_FILE
    VALIDATE $? "Enable Service" 
    systemctl restart $app_name &>> $LOG_FILE
    VALIDATE $? "Start Service"
}

restart_service(){
    systemctl restart $app_name.service &>> $LOG_FILE
    VALIDATE $? "Restart $app_name"
}

print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$(($END_TIME - $START_TIME))
    echo -e "Script Executed in : $Y $TOTAL_TIME $N Secs."
}
