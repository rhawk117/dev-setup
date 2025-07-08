#!/bin/bash

# gitsnap: add, commit with -m, and optional --pull
gitsnap() {

  usage() {
    cat <<EOF
Usage: git_pub [-m <message>] [-s|--sync] [-p|--
push>]
  -m --message   Commit message (required)

  -s, --sync     Pull changes before committing
  -p, --push     Push changes after committing
  -a, --add      Specify files or directories to add (default: '.')
EOF
  }

  local message=""
  local do_pull=false
  local do_push=false
  local add='.'
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
        shift 1
        ;;

      -p|--push)
        do_push=true
        shift 1
        ;;

      -a|--add)
        if [[ -n $2 && ${2:0:1} != "-" ]]; then
          add="$2"
          shift 2
        else
          echo "Error: -a requires a file or directory to add" >&2
          return 1
        fi
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

  git add "$add" || return $?

  if ! git commit -m "$message"; then
    echo "Commit failed. Please check your changes."
    return 1
  fi

  if $do_push; then
    git push || return $?
  fi
}
# gitfeat: create a new branch from a base branch, this helps me always sync local with remote bc i always forget
gitfeat() {
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


upby() {
  for _ in $(seq 1 "$1"); do cd ..; done
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