#!/bin/bash

FILES_DIR="$HOME/osuinstall/files/"
UDEV_RULES_DIR="/etc/udev/rules.d"
HOME_CONFIG_DIR="$HOME/.config"
CONFIG_DIR="$HOME/osuinstall/files/config"

# Create udev rules directory
mkdir -p $UDEV_RULES_DIR

# Add udev rules
sudo cp $FILES_DIR/udev/* $UDEV_RULES_DIR
sudo udevadm control --reload-rules && sudo udevadm trigger

# Проверка, установлен ли pipewire-media-session
if pacman -Qs pipewire-media-session >/dev/null; then
  # Если pipewire-media-session установлен
  echo "Install pipewire-media-session config files"
  cp -r "$CONFIG_DIR/media-session.d" "$HOME_CONFIG_DIR/"
else
  # Если pipewire-media-session не установлен
  echo "Install wireplumber config files"
  cp -r "$CONFIG_DIR/wireplumber" "$HOME_CONFIG_DIR/"
fi

echo "Install pipewire config files"
cp -r "$CONFIG_DIR/pipewire" "$HOME_CONFIG_DIR/"

systemctl --user restart pipewire.service pipewire.socket wireplumber.service pipewire-pulse.service pipewire-pulse.socket
