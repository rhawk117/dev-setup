#!/bin/bash

TMPV_FILE="/tmp/tmpv_store_$$"

do_ls() {
  if [[ -f "$TMPV_FILE" ]]; then
    while IFS='=' read -r key value; do
      echo "$key=$value"
    done < "$TMPV_FILE"
  fi
}

do_set() {
  local key="$1"
  local value="$2"

  if [[ -z "$key" || -z "$value" ]]; then
    echo "Usage: tmpv -s <key> <value>" >&2
    return 1
  fi

  if [[ -f "$TMPV_FILE" ]]; then
    grep -v "^$key=" "$TMPV_FILE" > "${TMPV_FILE}.tmp" 2>/dev/null
    mv "${TMPV_FILE}.tmp" "$TMPV_FILE" 2>/dev/null
  fi

  echo "$key=$value" >> "$TMPV_FILE"
}

do_get() {
  local key="$1"
  if [[ -z "$key" ]]; then
    echo "Usage: tmpv <key>" >&2
    return 1
  fi

  if [[ -f "$TMPV_FILE" ]]; then
    grep "^$key=" "$TMPV_FILE" | cut -d'=' -f2- | head -1
  fi
}

do_rm() {
  local key="$1"
  if [[ -z "$key" ]]; then
    echo "Usage: tmpv -rm <key>" >&2
    return 1
  fi

  if [[ -f "$TMPV_FILE" ]] && grep -q "^$key=" "$TMPV_FILE"; then
    grep -v "^$key=" "$TMPV_FILE" > "${TMPV_FILE}.tmp"
    mv "${TMPV_FILE}.tmp" "$TMPV_FILE"
  fi
}

do_usage() {
  cat << 'EOF'
Usage:
  tmpv -s <key> <value>    Set variable
  tmpv <key>               Get variable value
  tmpv -ls                 List all variables
  tmpv -rm <key>           Remove variable
  tmpv -c                  Clear all variables
EOF
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
      [[ -f "$TMPV_FILE" ]] && rm "$TMPV_FILE"
      ;;
    -h|--help|"")
      do_usage
      ;;
    *)
      do_get "$1"
      ;;
  esac
}

trap 'rm -f "$TMPV_FILE"' EXIT