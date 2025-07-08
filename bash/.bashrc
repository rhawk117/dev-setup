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
# --color default bins--
alias ll='ls -la --color=auto'
alias ls='ls --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias dir='ls --color=auto --format=vertical'
alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -v'
alias mkdir='mkdir -v'
alias rmdir='rmdir -v'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias rgrep='rgrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip --color=auto'
alias tree='tree -C'
alias ps='ps --color=auto'
alias more='less -R'
alias cat='cat -n'
alias df='df -h'
alias du='du -h'

# --alias management--
alias show_conf='cat ~/.bashrc'
alias edit_conf='nano ~/.bashrc'
alias reload='source ~/.bashrc'

# --git aliases--
alias git_log='git log --graph --oneline --decorate'

# Directory shortcuts
alias dir_ins='cd ~/Work/main/Insurance/'
alias docs='cd ~/Work/project_doc'

# --python aliases--
alias py='~/AppData/Local/Programs/Python/Python312/python.exe'
alias uv='~/AppData/Local/Programs/Python/Python312/Scripts/uv.exe'
alias uvx='~/AppData/Local/Programs/Python/Python312/Scripts/uvx.exe'

# --project cli tools i made--
alias snipmd='uv run ~/Work/repos/snip_md/snipmd/main.py'
alias bdd_run='uv run ~/Work/bdd_run/main.py'

# --custom wrappers--
source ~/.bashrc.d/functions.sh
alias gitsnap='gitsnap'
alias gitfeat='gitfeat'
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
alias fzless='fzless'
alias fzdiff='fzdiff'
alias fzh='fzh'
alias fznano='fznano'
alias fzhelp='fzhelp'

source ~/.bashrc.d/tmpv.sh
alias tmpv='tmpv'