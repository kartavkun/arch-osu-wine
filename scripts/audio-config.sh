#!/bin/bash

CONFIG_DIR="$HOME/osuinstall/files/config"
HOME_CONFIG_DIR="$HOME/.config/pipewire"

mkdir -p "$HOME_CONFIG_DIR"

# Check if pipewire config files are backed up
if [ -f "$HOME_CONFIG_DIR/pipewire.conf.bak" ] && [ -f "$HOME_CONFIG_DIR/pipewire-pulse.conf.bak" ]; then
  echo "Pipewire config files already backed up"
else
  if [ -f "$HOME_CONFIG_DIR/pipewire.conf" ] && [ -f "$HOME_CONFIG_DIR/pipewire-pulse.conf" ]; then
    echo "Backing up Pipewire config files"
    cp "$HOME_CONFIG_DIR/pipewire.conf" "$HOME_CONFIG_DIR/pipewire.conf.bak"
    cp "$HOME_CONFIG_DIR/pipewire-pulse.conf" "$HOME_CONFIG_DIR/pipewire-pulse.conf.bak"
  else
    echo "Original pipewire config files not found. Aborting."
    exit 1
  fi
fi

echo "Install pipewire config files"
echo "Choose a quantum (default: 32):"

select quantum in 16 32 48 64 128; do
  case $quantum in
  16 | 32 | 48 | 64 | 128)
    cp "$CONFIG_DIR/pipewire/${quantum}-quant/pipewire.conf" "$HOME_CONFIG_DIR/pipewire.conf"
    cp "$CONFIG_DIR/pipewire/${quantum}-quant/pipewire-pulse.conf" "$HOME_CONFIG_DIR/pipewire-pulse.conf"
    systemctl --user restart pipewire.service pipewire.socket wireplumber.service pipewire-pulse.service pipewire-pulse.socket
    echo "Installed config with quantum = $quantum"
    break
    ;;
  *)
    echo "Invalid choice"
    ;;
  esac
done
