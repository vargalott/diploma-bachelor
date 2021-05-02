#!/bin/bash

source $PROJ_ROOT_DIR/utility/utility.sh

dialog_modules_encryption_main() {
  while true; do
    option=$($DIALOG --clear --title "Choose app" \
      --menu "Please select app:" 20 50 4 \
      "$DMENU_OPTION_1" "TrueCrypt" 3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      case $option in
      $DMENU_OPTION_1) # show truecrypt main menu
        source $PROJ_ROOT_DIR/modules/encryption/truecrypt/truecrypt.sh dialog_modules_encryption_truecrypt_main
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
