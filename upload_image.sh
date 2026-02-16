#!/bin/bash
#set -x

# set up variables
TV_IP="192.168.1.204"     # IP address of your TV
OUTPUT_DIR="/home/my-user/disneyland-countdown/img/output"
PROJECT_ROOT="/home/my-user/samsung-tv-ws-api"

# activate the python virtual environment
source ${PROJECT_ROOT}/.venv/bin/activate

python ${PROJECT_ROOT}/example/async_art_update_from_directory.py ${TV_IP} --folder ${OUTPUT_DIR} --check 0
