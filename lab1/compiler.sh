#!/bin/bash

extract_output_file_name() {
  if [ -z "$1" ]; then
    echo add filename in script args
    exit 1
  fi

  CAPTURED_STRING="$(grep -i "Output:" "$1")"
  TEMP_OUTPUT_FILE_NAME=${CAPTURED_STRING#//Output:}
  OUTPUT_FILE_NAME=$(echo "$TEMP_OUTPUT_FILE_NAME" | tr -d '[:space:]')

  if [ -z "$OUTPUT_FILE_NAME" ]; then
    echo Empty file name
    exit 1
  fi
}

compile() {
  gcc "$1" -o "$OUTPUT_FILE_NAME"

  if [ $? -ne 0 ]; then
    echo Compilation failed!
    rm -Rf "${CURRENT_DIR:?}/${TEMP_FOLDER:?}"
    exit 1
  fi
}

execute_in_temp_dir() {
  TEMP_FOLDER=$(mktemp -d)
  trap "rm -Rf TEMP_FOLDER; exit 1" SIGKILL SIGINT SIGHUP SIGTERM

  cp "$1" "$TEMP_FOLDER"/

  CURRENT_DIR=$(pwd)

  cd "$TEMP_FOLDER"

  compile "$1"

  mv "$OUTPUT_FILE_NAME" "$CURRENT_DIR"
  rm -Rf "${CURRENT_DIR:?}/${TEMP_FOLDER:?}"

  echo Compiled file: "$OUTPUT_FILE_NAME"
}

extract_output_file_name "$1"
execute_in_temp_dir "$1"
