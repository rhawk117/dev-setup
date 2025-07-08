#!/bin/bash

git_branch() {
	if git rev-parse --git-dir > /dev/null 2>&1; then
		local branch
		branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
		if [ -n "$branch" ]; then
			echo " ($branch)"
		fi
	fi
}

set_ps1() {
  local branch_info
  branch_info=$(git_branch)
  PS1='\[\e]0;Git Bash: \w\a\]\n\[\e[1;34m\]\u\[\e[0m\]\[\e[1;31m\]@\h:\[\e[0m\]\[\e[1;37m\]\w\[\e[0m\]\[\e[33m\]'"$branch_info"'\[\e[0m\]\n\[\e[1;31m\]$\[\e[0m\]\[\e[37m\]:\[\e[0m\] '
}

PROMPT_COMMAND=set_ps1

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
alias snipmd='uv run ~/Work/repos/snip_md/snipmd/main.py'


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
alias fzless='fzless'
alias fzdiff='fzdiff'
alias fzh='fzh'
alias bdd_run='uv run /c/Users/hawkinsr/Work/bdd_run/main.py'
