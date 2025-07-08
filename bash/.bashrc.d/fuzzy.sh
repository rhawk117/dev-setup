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

fzless() {
  local file
  file=$(find . -type f | fzf \
    --preview 'head -50 {}' \
    --preview-window=right:50%:wrap \
    --height=80% \
    --border \
    --info=inline \
    --prompt="Select file to view: ")

  if [[ -n "$file" ]]; then
    less "$file"
  fi
}


fzdiff() {
  local reference_file="$1"
  local selected_file

  if [[ -z "$reference_file" ]]; then
    echo "Usage: fzdiff <reference_file>"
    echo "  reference_file    File to compare against (shown on left side of diff)"
    return 1
  fi

  if [[ ! -f "$reference_file" ]]; then
    echo "Error: Reference file '$reference_file' not found"
    return 1
  fi

  selected_file=$(find . -type f -not -path '*/\.*' | fzf \
    --preview "diff --color=always -u '$reference_file' {} 2>/dev/null || echo 'Files are identical or binary'" \
    --preview-window=right:60%:wrap \
    --height=80% \
    --border \
    --info=inline \
    --prompt="Select file to compare with '$reference_file': "
  )

  if [[ -n "$selected_file" ]]; then
    diff -u "$reference_file" "$selected_file"
  fi
}


fzh() {
  local cmd
  cmd=$(history | sort -k1,1nr | perl -pe 's/^\s*[0-9]+\s*//' | fzf \
    --height=40% \
    --border \
    --info=inline \
    --prompt="History: " \
    --no-preview\
  )

  if [[ -n "$cmd" ]]; then
    echo "$cmd"
    eval "$cmd"
  fi
}

fzhelp() {
  cat <<EOF
fzls: Find files and preview their content.
fzinfo: Find files and preview their information.
fzcomp: Select a command and show its type.
fzcd: Change directory using fzf.
fzclip: Copy selected text to clipboard.
fzvs: Open selected directory in VS Code.
fzless: View file content with less.
fzdiff: Compare a file with a reference file using diff.
fzh: Search through command history and execute selected command.
EOF
}