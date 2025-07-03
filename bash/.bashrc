#!/bin/bash

alias up='cd ..'
alias ll='ls -la --color=auto'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias tree='tree -C'
alias show_conf='cat ~/.bashrc'
alias edit_conf='nano ~/.bashrc'
alias reload='source ~/.bashrc'



alias git_log='git log --graph --oneline --decorate'
alias dir_ins='cd ~/Work/main/Insurance/'
alias py='/c/Users/hawkinsr/AppData/Local/Programs/Python/Python312/python.exe'
alias docs='cd ~/Work/project_doc'

alias uv='~/AppData/Local/Programs/Python/Python312/Scripts/uv.exe'
alias uvx='~/AppData/Local/Programs/Python/Python312/Scripts/uvx.exe'


alias df='df -h'
alias du='du -h'


#  -- custom wrappers ---
source ~/.bashrc.d/functions.sh
alias git_pub='git_pub'
alias upby='upby'
alias branch_init='branch_init'
alias rglob='rglob'

source ~/.bashrc.d/bkmark.sh
alias bkmark='bkmark'

source ~/.bashrc.d/fuzzy.sh
alias fzls='fzls'
alias fzinfo='fzinfo'
alias fzcomp='fzcomp'
alias fzcd='fzcd'
alias fzclip='fzclip'
alias fzvs='fzvs'
alias fzhelp='fzhelp'