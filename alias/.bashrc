#!/bin/bash
alias ll='ls -la'
alias git_log='git log --graph --oneline --decorate'
alias up='cd ..'

alias edit_conf='nano ~/.bashrc'
upby_fn() {
  for i in $(seq 1 "$1"); do cd ..; done
}
alias upby='upby_fn'
alias upby='upby_fn'
alias df='df -h'
alias du='du -h'
alias grep='grep --color=auto'
alias reload='source ~/.bashrc'

new_branch() {
  set -euo pipefail
  local new_name=""
  local base_branch=""

  while getopts "n:b:" opt; do
    case $opt in
      n) new_name="$OPTARG" ;;
      b) base_branch="$OPTARG" ;;
      *) return 1 ;;
    esac
  done

  if [ -z "$new_name" ] || [ -z "$base_branch" ]; then
    echo "[error] Both parameters are required"
    echo "[usage]: new_branch -n <new-branch-name> -b <base-branch>"
    return 1
  fi

  git fetch
  git checkout "$base_branch"
  git pull
  git checkout -b "$new_name"
  echo "[info] new branch '$new_name' was created from '$base_branch'."
}
alias new_branch='gbranch'
alias show_alias='cat ~/.bashrc'
alias ls='ls --color=auto'
