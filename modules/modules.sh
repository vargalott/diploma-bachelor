#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

dialog_modules_main() {
  while true; do
    option=$($DIALOG --clear --title "Choose module" \
      --menu "Please select app module:" 20 50 4 \
      "$DMENU_OPTION_1" "Data encryption" \
      "$DMENU_OPTION_2" "Networking" 3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      case $option in
      $DMENU_OPTION_1) # show encryption main menu
        source $PROJ_ROOT_DIR/modules/encryption/encryption.sh dialog_modules_encryption_main
        ;;

      $DMENU_OPTION_2)
        source $PROJ_ROOT_DIR/modules/network/network.sh dialog_module_network_main
        ;;

      esac
      ;;

    $DIALOG_CANCEL)
      clear
      return $DIALOG_CANCEL
      ;;

    $DIALOG_ESC)
      CLEAR_EXIT
      ;;

    esac

  done
}

RESOLVE_FUNC_CALL $@
