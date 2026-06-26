#!/bin/bash

source ./common.sh

app_name="user"
SCRIPT_DIR=$PWD

check_root
app_setup
nodejs_setup
systemd_setup
restart_service
print_total_time