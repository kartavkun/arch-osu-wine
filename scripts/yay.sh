#!/bin/bash

# Install yay
if ! command -v yay &>/dev/null; then
  echo "Installing yay..."
  # Clone the yay repository
  git clone https://aur.archlinux.org/yay.git
  cd yay || exit
  makepkg -si --noconfirm
  cd .. && rm -rf yay
else
  echo "yay is already installed."
fi
