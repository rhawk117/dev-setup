#!/bin/bash

declare -A TMPV_STORE

do_ls() {
  for key in "${!TMPV_STORE[@]}"; do
    echo "$key=${TMPV_STORE[$key]}"
  done
}

do_set() {
  local key="$1"
  local value="$2"

  if [[ -z "$key" || -z "$value" ]]; then
    echo "Usage: tmpv -s <key> <value>" >&2
    return 1
  fi

  TMPV_STORE["$key"]="$value"
}

do_get() {
  local key="$1"
  if [[ -z "$key" ]]; then
    echo "Usage: tmpv <key>" >&2
    return 1
  fi

  echo "${TMPV_STORE[$key]}"
}

do_rm() {
  local key="$1"
  if [[ -z "$key" ]]; then
    echo "Usage: tmpv -rm <key>" >&2
    return 1
  fi

  unset TMPV_STORE["$key"]
}

tmpv() {
  case "$1" in
    -ls|--list)
      do_ls
      ;;
    -s|--set)
      do_set "$2" "$3"
      ;;
    -rm|--remove)
      do_rm "$2"
      ;;
    -c|--clear)
      TMPV_STORE=()
      ;;
    -h|--help|"")
      echo "Usage:"
      echo "  tmpv -s <key> <value>    # Set variable"
      echo "  tmpv <key>               # Get variable value"
      echo "  tmpv -ls                 # List all variables"
      echo "  tmpv -rm <key>           # Remove variable"
      echo "  tmpv -c                  # Clear all variables"
      ;;
    *)
      do_get "$1"
      ;;
  esac
}