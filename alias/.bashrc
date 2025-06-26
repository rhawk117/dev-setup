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
  git pull
  git checkout -b "$new_name"
  echo "[info] new branch '$new_name' was created from '$base_branch'."
}
alias fbranch='fcheckout'
alias show_alias='cat ~/.bashrc'
alias ls='ls --color=auto'
