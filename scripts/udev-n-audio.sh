#!/bin/bash

FILES_DIR="$HOME/osuinstall/files"
UDEV_RULES_DIR="/etc/udev/rules.d"
HOME_CONFIG_DIR="$HOME/.config"
CONFIG_DIR="$HOME/osuinstall/files/config"
SCRIPT_USER="$(whoami)"

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

echo "Add user to audio group"
sudo usermod -a -G audio $SCRIPT_USER

echo "Set max priority in security limits"
sudo mkdir -p /etc/security
sudo cp "$CONFIG_DIR/pipewire-extras/limits.conf" "/etc/security/limits.conf"

echo "Set max priority in pulse settings"
sudo mkdir -p /etc/pulse
sudo mkdir -p /etc/pulse/daemon.conf.d
sudo cp "$CONFIG_DIR/pipewire-extras/10-better-latency.conf" "/etc/pulse/daemon.conf.d/10-better-latency.conf"

sudo cp "$CONFIG_DIR/pipewire-extras/default.pa" "/etc/pulse/default.pa"
