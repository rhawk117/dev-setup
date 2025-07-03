#!/bin/bash

# git_publish: add, commit with -m, and optional --pull
git_pub() {
  local message=""
  local do_pull=false
  local do_push=false
  # parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -m)
        if [[ -n $2 && ${2:0:1} != "-" ]]; then
          message="$2"
          shift 2
        else
          echo "Error: -m requires a commit message" >&2
          return 1
        fi
        ;;
      -s|--sync)
        do_pull=true
        shift
        ;;
      -p|--push)
        do_push=true
        shift
        ;;
      *)
        echo "Unknown option: $1" >&2
        return 1
        ;;
    esac
  done


  if $do_pull; then
    git pull || return $?
  fi

  git add . || return $?

  if ! git commit -m "$message"; then
    echo "Commit failed. Please check your changes."
    return 1
  fi

  if $do_push; then
    git push || return $?
  fi
}



upby() {
  for _ in $(seq 1 "$1"); do cd ..; done
}

branch_init() {
  local new_name=""
  local base_branch=""

  while getopts "r:b:" opt; do
    case $opt in
      b) new_name="$OPTARG" ;;
      r) base_branch="$OPTARG" ;;
      *) return 1 ;;
    esac
  done

  if [ -z "$new_name" ] || [ -z "$base_branch" ]; then
    echo "[error] Both parameters are required"
    echo "[usage]: fcheckout -b <new-branch-name> -r <base-branch>"
    return 1
  fi

  git fetch
  git checkout "$base_branch"
  git checkout -b "$new_name"
  echo "[info] new branch '$new_name' was created from '$base_branch'."
}

rglob() {
  if [[ -z "$1" ]]; then
    echo "Usage: rglob <pattern>"
    return 1
  fi

  find . -name "$1" -type f
}
