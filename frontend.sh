source ./common.sh

CHECK_ROOT
NGINX_SETUP

systemctl enable nginx  &>>$LOG_FILE
VALIDATE $? "Enable Nginx"
systemctl restart nginx 
VALIDATE $? "Start Nginx"
rm -rf /usr/share/nginx/html/* &>> $LOG_FILE
VALIDATE $? "Remove Default Html"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> $LOG_FILE
VALIDATE $? "Download App Code"
cd /usr/share/nginx/html &>> $LOG_FILE
VALIDATE $? "Enter Directory"
unzip /tmp/frontend.zip &>> $LOG_FILE
VALIDATE $? "Unzip Code"
rm -rf /etc/nginx/nginx.conf
VALIDATE $? "Remove Default Config"
cp $SCRIPT_DIR/nginx.conf /etc/nginx/nginx.conf &>> $LOG_FILE
systemctl restart nginx &>> $LOG_FILE
VALIDATE $? "Restart Service"

PRINT_TOTAL_TIME