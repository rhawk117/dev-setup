#!/bin/bash

fzls() {
  usage() {
    echo "Usage: fzls [options] [pattern]"
    echo "Find files matching <pattern> and preview their content."
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message and exit"
    echo ""
    echo "  -t, --type    Specify the type of files to match (default: f for files)"
    echo "                options: f (file), d (directory), l (symlink)"
    echo ""
    echo "  -d, --directory Specify a directory to search in (default: $PWD)"
    echo ""
    echo "  -n, --name   Specify a name pattern to match (default: * for all files)"
    echo ""
    echo "  -l, --lines   Number of lines to preview (default: 20)"
    echo ""
    echo "  -a, --all     Include hidden files/directories (dotfiles)"
    echo ""
    echo "Examples:"
    echo "  fzls                    # Find all non-hidden files"
    echo "  fzls -n '*.py'          # Find Python files"
    echo "  fzls -a -n '.*'         # Find hidden files"
    echo "  fzls -t d               # Find directories only"
  }

  local name="*"
  local type="f"
  local directory="$PWD"
  local lines=20
  local include_hidden=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        usage
        return 0
        ;;
      -n|--name)
        if [[ -n "$2" && ! "$2" =~ ^- ]]; then
          name="$2"
          shift 2
        else
          echo "Error: -n/--name requires a pattern argument"
          usage
          return 1
        fi
        ;;
      -t|--type)
        if [[ -n "$2" && ! "$2" =~ ^- ]]; then
          type="$2"
          shift 2
        else
          echo "Error: -t/--type requires an argument"
          usage
          return 1
        fi
        ;;
      -d|--dir|--directory)
        if [[ -n "$2" && ! "$2" =~ ^- ]]; then
          directory="$2"
          shift 2
        else
          echo "Error: -d/--directory requires an argument"
          usage
          return 1
        fi
        ;;
      -l|--lines)
        if [[ -n "$2" && ! "$2" =~ ^- ]]; then
          lines="$2"
          shift 2
        else
          echo "Error: -l/--lines requires an argument"
          usage
          return 1
        fi
        ;;
      -a|--all)
        include_hidden=true
        shift
        ;;
      -*)
        echo "Unknown option: $1"
        usage
        return 1
        ;;
      *)
        name="$1"
        shift
        ;;
    esac
  done

  if [[ ! -d "$directory" ]]; then
    echo "Directory '$directory' does not exist."
    return 1
  fi

  local find_cmd="find \"$directory\" -name \"$name\" -type \"$type\""

  if [[ "$include_hidden" == false ]]; then
    find_cmd="$find_cmd ! -path '*/.*'"
  fi

  eval "$find_cmd" | \
    fzf -m --header "Select files (preview: first $lines lines)" \
        --preview "head -n $lines {}" \
        --preview-window=right:50%:border-left
}

fzinfo() {
  usage() {
    echo "Usage: fzinfo [options]"
    echo "Find files and preview their information."
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message and exit"
    echo ""
    echo "  -t, --type    Specify the type of files to match (default: f for files)"
    echo "                options: f (file), d (directory), l (symlink)"
    echo ""
    echo "  -d, --directory Specify a directory to search in (default: $PWD)"
    echo ""
    echo "  -n, --name   Specify a name to match (default: * for all files)"
  }

  local name=""
  local type="f"
  local directory="$PWD"

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        usage
        return 0
        ;;
      -n|--name)
        name="$2"
        shift 2
        ;;
      -t|--type)
        type="$2"
        shift 2
        ;;
      -d|--dir)
        directory="$2"
        shift 2
        ;;
      *)
        echo "Unknown option: $1"
        usage
        return 1
        ;;
    esac
  done

  if [[ ! -d "$directory" ]]; then
    echo "Directory '$directory' does not exist."
    return 1
  fi

  find "$directory" -name "$name" -type "$type" | \
    fzf -m --header "Select files (showing file info)" \
        --preview "echo '=== File Details ===' && \
                   echo 'Path: {}' && \
                   echo && \
                   echo '--- Permissions & Size ---' && \
                   ls -lah {} 2>/dev/null && \
                   echo && \
                   echo '--- File Type ---' && \
                   file {} 2>/dev/null && \
                   echo && \
                   echo '--- Statistics ---' && \
                   stat {} 2>/dev/null" \
        --preview-window=right:60%:border-left:wrap
}


fzcomp() {
  compgen -c | fzf --header "Select a command" --preview \
    "echo 'Command: {}' && echo && type {}" --preview-window=right:50%:border-left
}


fzcd() {
  local dir
  dir=$(find . -type d 2>/dev/null | fzf --height 40% --reverse --prompt="Select directory: ")
  if [ -n "$dir" ]; then
    cd "$dir" || echo "Failed to cd into $dir"
  fi
}

fzclip() {
  local selection
  selection=$(fzf)
  if [ -n "$selection" ]; then
    echo -n "$selection" | clip
    echo "Copied to clipboard: $selection"
  else
    echo "No selection made."
  fi
}

fzvs() {
  local dir
  dir=$(find . -type d 2>/dev/null | fzf --height 40% --reverse --prompt="Select directory to open in VS Code: ")
  if [ -n "$dir" ]; then
    code "$dir"
  else
    echo "No directory selected."
  fi
}

fzhelp() {
  echo "fzf commands:"
  echo "  fzls    - Find files matching a pattern and preview their content."
  echo "  fzinfo  - Find files and preview their information."
  echo "  fzcomp  - List available commands and show their type."
  echo "  fzcd    - Change directory using fzf."
  echo "  fzclip  - Copy selected text to clipboard."
  echo "  fzvs    - Open selected directory in Visual Studio Code."
  echo "  fzhelp  - Show this help message."
  echo ""
}
