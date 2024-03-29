#!/bin/bash

# =================================================================
#
#   SUBMODULE: truecrypt:bench
#   LOCAL ENTRY POINT: modules_encryption_truecrypt_bench
#
#   truecrypt
#   |-- truecrypt.sh
#   |-- bench.sh *CURRENT*
#   |-- encryption.sh
#   |-- decryption.sh
#
#   COMMENT: encryption:truecrypt benchmarking
#
# =================================================================

source $PROJ_ROOT_DIR/utility/utility.sh

modules_encryption_truecrypt_bench_inner() {
  #region ROOT IS REQUIRED

  local size=(104857600 209715200 524288000 1073741824) # 100MD 200MB 500MB 1GB
  local hash=(RIPEMD-160 SHA-512 Whirlpool)
  local encalg=(AES Serpent Twofish AES-Twofish AES-Twofish-Serpent Serpent-AES Serpent-Twofish-AES Twofish-Serpent)

  local cpu_info=$(cat /proc/cpuinfo | grep -oP "model name.*?:(.*)" | uniq | sed "s/model name.*: //")

  local time_start=$(date "+%Y-%m-%d %k:%M:%S")
  local time_start_unix=$(date +%s)

  local separator="-----------------------------------------------------------------------------------------------------------------------"

  echo "$separator"
  echo "- Bench TrueCrypt"
  echo "- Started at: $time_start"
  echo "- CPU: $cpu_info"
  echo "$separator"
  printf "%-10s | %-10s | %-30s | %-20s | %-20s | %-10s\n" \
    "SIZE" "HASH" "ENCRYPTION ALGORITHM" \
    "VOL CREATE TIME" "VOL FILL TIME" "SPEED (MB/sec)"

  echo "$separator"

  local mntdir=$PROJ_ROOT_DIR/out/mnt/tc/
  local benchdir=$PROJ_ROOT_DIR/out/bench/tc/
  mkdir -p "$mntdir"
  mkdir -p "$benchdir"

  for current_size in "${size[@]}"; do
    for current_hash in "${hash[@]}"; do
      for current_encalg in "${encalg[@]}"; do
        local password=$(
          tr </dev/urandom -dc _A-Z-a-z-0-9 | head -c${1:-64}
          echo
        )

        local container_name="$benchdir/tcc$(date +%F_%H-%M-%S).tc"

        # creating tc volume and time it
        local volume_create_time=$( (time (truecrypt -m=nokernelcrypto -t --size=$current_size --password="$password" -k "" \
          --random-source=/dev/urandom --volume-type=normal \
          --encryption=$current_encalg --hash=$current_hash --filesystem=FAT \
          -c "$container_name")) 2>&1 |
          grep -i "real" | sed "s/real//" | sed "s/ //g" | tr "\t" " ")

        # mount created volume
        truecrypt -m=nokernelcrypto \
          --password="$password" --mount "$container_name" "$mntdir"

        local fill_time_start=$(date +%s)

        local file_count=$(($current_size / 26214400 - 1))

        # fill the container with 25 MB files and time it
        local volume_fill_time=$( (time (for ((i = 1; i <= $file_count; i++)); do
          dd if=/dev/urandom of="$mntdir/$i.dat" \
            bs=26214400 count=1
        done)) 2>&1 |
          grep -i "real" | sed "s/real//" | sed "s/ //g" | tr "\t" " ")

        local fill_time_end=$(date +%s)

        # calc write speed
        local elapsed_fill_time=$(($fill_time_end - $fill_time_start))
        if [ $elapsed_fill_time -eq 0 ]; then
          elapsed_fill_time=1
        fi
        local elapsed_fill_speed=$(($file_count * 26214400 / $elapsed_fill_time / 1024 / 1024))

        # output
        printf "%-10s | %-10s | %-30s | %-20s | %-20s | %-10s\n" \
          "$((current_size / 1024 / 1024)) MB" "$current_hash" "$current_encalg" \
          "$volume_create_time" "$volume_fill_time" "$elapsed_fill_speed"

        # unmount created volume
        truecrypt -m=nokernelcrypto -d "$container_name"

        rm -f "$container_name"

      done
    done
  done

  rm -rf "$mntdir"
  rm -rf "$benchdir"

  echo "$separator"

  local time_end_unix=$(date +%s)
  local elapsed_time=$(expr ${time_end_unix} - ${time_start_unix})
  local elapsed_time=$(date -d@$elapsed_time -u +%H:%M:%S)

  echo "- Completed on $(date "+%Y-%m-%d %k:%M:%S")"
  echo "- Elapsed Time: $elapsed_time"
  echo "$separator"

  #endregion
}

modules_encryption_truecrypt_bench() {
  #region ROOT IS REQUIRED

  SUDO_CRED_LOCK_RESET

  source $PROJ_ROOT_DIR/utility/common.sh dialog_get_sup
  if [ $? -eq $RC_ERROR ]; then
    return
  fi
  rpass=$retval

  local log=$PROJ_ROOT_DIR/out/tcbench$(date +%F_%H-%M-%S).log
  sudo -E -S -k -p "" bash -c \
    "$(declare -f modules_encryption_truecrypt_bench_inner); modules_encryption_truecrypt_bench_inner" \
    <<<"$rpass" | tee "$log" | $DIALOG --progressbox 80 125
  $DIALOG --textbox "$log" 80 125

  /usr/bin/env python3 $PROJ_ROOT_DIR/utility/db.py -f $PROJ_DB_PATH -l \
    'encryption:truecrypt:bench' \
    "$(cat $log)" \
    'ok'

  rm -f $log

  SUDO_CRED_LOCK_RESET

  #endregion
}

RESOLVE_FUNC_CALL $@
