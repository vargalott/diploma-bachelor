#!/bin/bash

# =================================================================
#
#   TOP-LEVEL: run:run
#   LOCAL ENTRY POINT: .
#
#   ./
#   |-- extern
#   |-- modules
#   |-- utility
#   |-- run.sh *CURRENT*
#
#   COMMENT: application entry point
#
# =================================================================

export PROJ_ROOT_DIR=$PWD
export APP_NAME="diploma-bachelor"
export DIALOGRC=$PROJ_ROOT_DIR/utility/.default.dialogrc

source $PROJ_ROOT_DIR/utility/utility.sh

if [ "$EUID" -eq 0 ]; then
  echo "Running as root is not allowed"
  exit $RC_ERROR
fi

app_cleanup() {
  rm -rf $PROJ_ROOT_DIR/out/*.log

  truecrypt -t -d # #?
  vearcrypt -t -d # #?

  source $PROJ_ROOT_DIR/utility/common.sh network_stop_test_server

  unset DIALOGRC
}

ctrl_c() {
  app_cleanup
  CLEAR_EXIT
}
trap ctrl_c INT
trap ctrl_c QUIT
trap ctrl_c TSTP

mkdir -p $PROJ_ROOT_DIR/out/

# say hello
source $PROJ_ROOT_DIR/modules/greetings.sh dialog_greetings

# show main menu
source $PROJ_ROOT_DIR/modules/modules.sh dialog_modules_main

ctrl_c
