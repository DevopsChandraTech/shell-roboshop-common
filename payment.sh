#!/bin/bash

source ./common.sh

app_name="shipping"
SCRIPT_DIR=$PWD

check_root
app_setup
python3_setup
systemd_setup
