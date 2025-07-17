#!/bin/bash

SNAPSHOT_PATH=""

# custom bookmarking of paths
bkmark() {
  do_path() {
    export SNAPSHOT_PATH="$PWD"
    echo "[ ⚐ ] bookmarked: $SNAPSHOT_PATH"
  }

  do_go() {
    if [[ -z "$SNAPSHOT_PATH" ]]; then
      echo "✗ [ error ] bookmark unset :("
      return 1
    fi
    cd "$SNAPSHOT_PATH" || return $?
    echo "[ 🕮 ] opening bookmark: $SNAPSHOT_PATH"
  }

  do_show() {
    echo "${SNAPSHOT_PATH:-none}"
  }

  if [[ -z "$1" ]]; then
    do_path
    return 0
  fi

  case "$1" in
    path|-p)
      do_path
      ;;
    go|-g)
      do_go
      ;;
    show|-s)
      do_show
      ;;
    *)
      echo "Usage: bkmark {path|go|show}"
      return 1
      ;;
  esac
}
