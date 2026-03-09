#!/bin/bash
source ./common.sh
CHECK_ROOT
app_name=payment
APP_SETUP

dnf install python3 gcc python3-devel -y &>> $LOG_FILE
pip3 install -r requirements.txt &>> $LOG_FILE

SYSTEMD_SETUP
RESTART_SERVICE
PRINT_TOTAL_TIME