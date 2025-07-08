#!/bin/bash

# git_publish: add, commit with -m, and optional --pull
git_pub() {

  usage() {
    cat <<EOF
Usage: git_pub [-m <message>] [-s|--sync] [-p|--
push>]
  -m --message   Commit message (required)

  -s, --sync     Pull changes before committing
  -p, --push     Push changes after committing
EOF
  }

  local message=""
  local do_pull=false
  local do_push=false
  # parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        usage
        return 0
        ;;

      -m|--message)
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

feature_branch() {
  local new_name=""
  local base_branch=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        echo "Usage: fcheckout -b <new-branch-name> -r <base-branch>"
        return 0
        ;;
      -b|--branch)
        if [[ -n "$2" && ! "$2" =~ ^- ]]; then
          new_name="$2"
          shift 2
        else
          echo "Error: -b/--branch requires a branch name argument"
          return 1
        fi
        ;;
      -r|--base)
        if [[ -n "$2" && ! "$2" =~ ^- ]]; then
          base_branch="$2"
          shift 2
        else
          echo "Error: -r/--base requires a base branch argument"
          return 1
        fi
        ;;
      *)
        echo "Unknown option: $1"
        return 1
        ;;
    esac
  done

  if [ -z "$new_name" ] || [ -z "$base_branch" ]; then
    echo "[error] Both parameters are required"
    echo "[usage]: fcheckout -b <new-branch-name> -r <base-branch>"
    return 1
  fi

  git checkout "$base_branch"
  git fetch -a
  git checkout -b "$new_name"
  echo "[info] new branch '$new_name' was created from '$base_branch'."
}

rglob() {
  local pattern
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        echo "Usage: rglob <pattern>"
        return 0
        ;;
      -p|--pattern)
        pattern="$2"
        shift 2
        ;;

      -t|--type)
        type="$2"
        shift 2
        ;;

      *)
        break
        ;;
    esac
  done

  type=${type:-f}
  pattern=${pattern:-"$1"}

  [ -z "$pattern" ] && {
    echo "Usage: rglob <pattern>"
    return 1
  }

  find . -name "$1" -type f
}