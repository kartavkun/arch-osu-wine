#/bin/bash

DOT_LOCAL_DIR="$HOME/.local"
FILES_DIR="$HOME/ArchOsu/files"
FONTS_DIR="$FILES_DIR/fonts"
CONFIG_DIR="$FILES_DIR/config"
HOME_CONFIG_DIR="$HOME/.config"
UDEV_RULES_DIR="/etc/udev/rules.d"
DEVSERVER_DIR="$HOME/ArchOsu/files/devserver"

clear

# Функция для копирования шрифтов
echo "Installing fonts from Windows..."
sudo cp -r $FONTS_DIR/* /usr/share/fonts/
sudo chmod 644 /usr/share/fonts/WindowsFonts/*
sudo fc-cache --force
sudo fc-cache-32 --force
echo "The fonts successfully installed."

# Add udev rules
sudo cp $FILES_DIR/udev/* $UDEV_RULES_DIR
sudo udevadm control --reload-rules && sudo udevadm trigger

# Функция для копирования конфигов
echo "Install wireplumber config files"
cp -r "$CONFIG_DIR/wireplumber" "$HOME_CONFIG_DIR/"

echo "Install pipewire config files"
cp -r "$CONFIG_DIR/pipewire" "$HOME_CONFIG_DIR/"

systemctl --user restart pipewire.service pipewire.socket wireplumber.service pipewire-pulse.service pipewire-pulse.socket
