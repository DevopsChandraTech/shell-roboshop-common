#!/bin/bash

source ./common.sh

app_name="nginx"
SCRIPT_DIR=$PWD

check_root
nginx_setup
restart_service
print_total_time
