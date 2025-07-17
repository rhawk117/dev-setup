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



debug "Setting up bash environment..."

info "Copying .bashrc to ~/.bashrc"
cp -rf ./.bashrc ~/.bashrc && {
  success "Copied .bashrc successfully."
}


if [ ! -d ~/.bashrc.d ]; then
  mkdir -p ~/.bashrc.d
  info "Created directory ~/.bashrc.d"
fi

info "Copying files to ~/.bashrc.d"
cp -rf ./.bashrc.d ~/.bashrc.d && {
  success "Copied .bashrc.d files successfully."
}

info "Copying .minttyrc"
cp -rf ./.minttyrc ~/.minttyrc && {
  success "Copied .minttyrc successfully."
}

info "Setup complete. Reload the active shell terminal"