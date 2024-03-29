#!/bin/bash

# =================================================================
#
#   SUBMODULE: truecrypt:encryption
#   LOCAL ENTRY POINT: dialog_modules_encryption_truecrypt_encrypt
#
#   truecrypt
#   |-- truecrypt.sh
#   |-- bench.sh
#   |-- encryption.sh *CURRENT*
#   |-- decryption.sh
#
#   COMMENT: encryption:truecrypt encrypt menu DIALOG
#
# =================================================================

source $PROJ_ROOT_DIR/utility/utility.sh

choose_encalg() {
  option=$($DIALOG --clear --title "Choose the encryption algorithm" \
    --menu "" 20 50 4 \
    "$DMENU_OPTION_1" "AES" \
    "$DMENU_OPTION_2" "Serpent" \
    "$DMENU_OPTION_3" "Twofish" \
    "$DMENU_OPTION_4" "AES-Twofish" \
    "$DMENU_OPTION_5" "AES-Twofish-Serpent" \
    "$DMENU_OPTION_6" "Serpent-AES" \
    "$DMENU_OPTION_7" "Serpent-Twofish-AES" \
    "$DMENU_OPTION_8" "Twofish-Serpent" 3>&1 1>&2 2>&3)

  case $? in
  $DIALOG_OK)
    case $option in
    $DMENU_OPTION_1)
      retval="AES"
      ;;

    $DMENU_OPTION_2)
      retval="Serpent"
      ;;

    $DMENU_OPTION_3)
      retval="Twofish"
      ;;

    $DMENU_OPTION_4)
      retval="AES-Twofish"
      ;;

    $DMENU_OPTION_5)
      retval="AES-Twofish-Serpent"
      ;;

    $DMENU_OPTION_6)
      retval="Serpent-AES"
      ;;

    $DMENU_OPTION_7)
      retval="Serpent-Twofish-AES"
      ;;

    $DMENU_OPTION_8)
      retval="Twofish-Serpent"
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
}

dialog_modules_encryption_truecrypt_encrypt() {
  local path=""
  local encalg=""
  local password=""

  while true; do
    option=$($DIALOG --clear --title "TrueCrypt - Encryption" \
      --menu "" 20 70 4 \
      "$DMENU_OPTION_1" "Choose file or dir... $([ -z $path ] && echo || echo [$(basename "$path")])" \
      "$DMENU_OPTION_2" "Choose algorithm... $([ -z $encalg ] && echo || echo [$encalg])" \
      "$DMENU_OPTION_3" "Enter password... $([ -z $password ] && echo || echo [*])" \
      "$DMENU_OPTION_4" "Process" 3>&1 1>&2 2>&3)

    case $? in
    $DIALOG_OK)
      case $option in
      $DMENU_OPTION_1)
        source $PROJ_ROOT_DIR/utility/common.sh dialog_input_path
        path=$retval
        ;;

      $DMENU_OPTION_2)
        choose_encalg
        encalg=$retval
        ;;

      $DMENU_OPTION_3)
        title=""
        text="Enter password"
        source $PROJ_ROOT_DIR/utility/common.sh dialog_input_password "\${title}" "\${text}"
        password=$retval
        ;;

      $DMENU_OPTION_4)
        correct=1

        if [ "$path" == "" ]; then
          correct=0
          $DIALOG --title "Error" --msgbox "Please choose file or dir..." 10 40
        fi
        if [ "$encalg" == "" ]; then
          correct=0
          $DIALOG --title "Error" --msgbox "Please choose encryption algorithm..." 10 40
        fi
        if [ "$password" == "" ]; then
          correct=0
          $DIALOG --title "Error" --msgbox "Please enter password..." 10 40
        fi

        if [ $correct -eq 1 ]; then

          local fdsize=$(du -sb $path | cut -f1)
          # case 1: min FAT size - 299008
          # case 2: $fdsize + extra space at 2 percent
          [ $fdsize -lt 299008 ] && size=299008 || size=$(($fdsize + $fdsize / 100 * 2))

          local fdname=$(basename "$path")

          #region ROOT IS REQUIRED

          SUDO_CRED_LOCK_RESET

          source $PROJ_ROOT_DIR/utility/common.sh dialog_get_sup
          if [ $? -eq $RC_ERROR ]; then
            continue
          fi
          rpass=$retval

          local mntdir=$PROJ_ROOT_DIR/out/mnt$(date +%F_%H-%M-%S)
          mkdir -p "$mntdir"

          local log=$PROJ_ROOT_DIR/out/truecrypt$(date +%F_%H-%M-%S).log
          # creating tc volume
          # note: --hash=<RIPEMD-160|SHA-512|Whirlpool>
          (truecrypt -m=nokernelcrypto -t --size=$size --password="$password" -k "" \
            --random-source=/dev/urandom --volume-type=normal \
            --encryption=$encalg --hash=SHA-512 --filesystem=FAT \
            -c "$PROJ_ROOT_DIR/out/$fdname.tc" 2>&1) | tee "$log" | $DIALOG --progressbox 20 70
          $DIALOG --clear --textbox "$log" 20 70

          /usr/bin/env python3 $PROJ_ROOT_DIR/utility/db.py -f $PROJ_DB_PATH -l \
            'encryption:truecrypt:encrypt' \
            "$(cat $log)" \
            'ok'

          rm -f $log

          # mount created volume
          sudo -E -S -k -p "" truecrypt -m=nokernelcrypto --password="$password" --mount "$PROJ_ROOT_DIR/out/$fdname.tc" "$mntdir" <<<"$rpass"

          # copy selected file or dir to the volume
          cp -r "$path" "$mntdir"

          # unmount created volume
          sudo -E -S -k -p "" truecrypt -m=nokernelcrypto -d "$PROJ_ROOT_DIR/out/$fdname.tc" <<<"$rpass"

          rmdir "$mntdir"

          SUDO_CRED_LOCK_RESET

          #endregion

        fi

        ;;

      esac

      ;;

    $DIALOG_CANCEL)
      return $DIALOG_CANCEL
      ;;

    $DIALOG_ESC)
      clear
      return $DIALOG_ESC
      ;;
    esac

  done
}

RESOLVE_FUNC_CALL $@
