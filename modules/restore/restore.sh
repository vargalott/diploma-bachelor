#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

dialog_module_restore_main() {
  while true; do
    option=$($DIALOG --clear --title "Choose app" \
      --menu "Please select app:" 20 50 4 \
      "$DMENU_OPTION_1" "Scalpel" \
      "$DMENU_OPTION_2" "Foremost" 3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      case $option in
      $DMENU_OPTION_1) # show scalpel main menu
        source $PROJ_ROOT_DIR/modules/restore/scalpel/scalpel.sh dialog_modules_restore_scalpel_main
        ;;

      $DMENU_OPTION_2) # show foremost main menu
        source $PROJ_ROOT_DIR/modules/restore/foremost/foremost.sh dialog_modules_restore_foremost_main
        ;;

      esac

      ;;

    $DIALOG_CANCEL)
      return $DIALOG_CANCEL
      ;;

    $DIALOG_ESC)
      CLEAR_EXIT
      ;;

    esac

  done
}

RESOLVE_FUNC_CALL $@
