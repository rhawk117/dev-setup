#!/bin/bash

echo "Copying .bashrc to ~/.bashrc"
cp -f ./.bashrc ~/.bashrc

echo "Copying .bashrc.d to ~/.bashrc.d"

if [ ! -d ~/.bashrc.d ]; then
  mkdir -p ~/.bashrc.d
  echo "Created directory ~/.bashrc.d"
fi

cp -rf ./.bashrc.d ~
