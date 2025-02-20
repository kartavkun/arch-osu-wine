#!/bin/bash

# Add udev rules
sudo cp $FILES_DIR/udev/* $UDEV_RULES_DIR
sudo udevadm control --reload-rules && sudo udevadm trigger

# Функция для копирования конфигов
echo "Install wireplumber config files"
cp -r "$CONFIG_DIR/wireplumber" "$HOME_CONFIG_DIR/"

echo "Install pipewire config files"
cp -r "$CONFIG_DIR/pipewire" "$HOME_CONFIG_DIR/"

systemctl --user restart pipewire.service pipewire.socket wireplumber.service pipewire-pulse.service pipewire-pulse.socket
