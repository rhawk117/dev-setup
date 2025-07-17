#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'


info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}


debug() {
  echo -e "${PURPLE}[DEBUG]${NC} $1"
}


info "◈ shell sync ◈"
info "    ❯  .bashrc "
info "   🗁  .bashrc.d "
info "    ❯  .minttyrc "



cp -rf ./shell/.bashrc ~/.bashrc && {
  success "(❯) copied .bashrc successfully."
}


if [ ! -d ~/.bashrc.d ]; then
  mkdir -p ~/.bashrc.d
  info "(🖿) created directory ~/.bashrc.d"
fi

cp -rf ./shell/.bashrc.d ~/.bashrc.d && {
  success "🗁 copied .bashrc.d files successfully."
}

info "(❯) copying .minttyrc"
cp -rf ./shell/.minttyrc ~/.minttyrc && {
  success "❯ copied .minttyrc successfully."
}

success "◈ setup complete, reload the active shell terminal ◈"