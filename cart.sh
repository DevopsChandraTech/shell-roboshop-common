#!/bin/bash

source ./common.sh

app_name="cart"
SCRIPT_DIR=$PWD
MONGODB_HOST="cart.devaws.shop"

check_root
app_setup
nodejs_setup
systemd_setup
restart_service
print_total_time