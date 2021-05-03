#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

dialog_greetings() {
  $DIALOG --title "Greetings" --msgbox "Welcome aboard" 10 40 3>&1 1>&2 2>&3

  case $? in
  $DIALOG_OK)
    return $STATUS_TRUE
    ;;

  $DIALOG_CANCEL)
    return $STATUS_FALSE
    ;;

  $DIALOG_ESC)
    CLEAR_EXIT
    ;;

  esac
}

RESOLVE_FUNC_CALL $@