#!/bin/bash

run_script() {
  # Путь к файлу конфигурации pacman
  PACMAN_CONF="/etc/pacman.conf"

  # Проверка наличия секции [multilib]
  if grep -q "^[[:space:]]*#\s*\[multilib\]" "$PACMAN_CONF"; then
    # Раскомментирование секции [multilib]
    sudo sed -i 's/^[[:space:]]*#\s*\[multilib\]/[multilib]/' "$PACMAN_CONF"
  fi

  # Раскомментирование строки Include только под [multilib]
  if awk '/^\[multilib\]/{f=1} f && /^[[:space:]]*#\s*Include = \/etc\/pacman.d\/mirrorlist/{print; f=0} f && /^\[/{f=0} {print}' "$PACMAN_CONF" | grep -q "Include"; then
    sudo sed -i '/^\[multilib\]/,/^\[/{s/^[[:space:]]*#\s*Include = \/etc\/pacman.d\/mirrorlist/Include = \/etc\/pacman.d\/mirrorlist/}' "$PACMAN_CONF"
  fi

  # Install necessary packages
  PACKAGES=("wget" "base-devel" "git" "go" "zenity" "xdg-desktop-portal" "linux-zen" "linux-zen-headers" "pipewire" "wireplumber" "xdg-utils" "xdg-desktop-portal-gtk")

  for PACKAGE in "${PACKAGES[@]}"; do
    if ! pacman -Qi "$PACKAGE" &>/dev/null; then
      echo "Installing package '$PACKAGE'..."
      if ! sudo pacman -Sy --noconfirm --needed "$PACKAGE"; then
        echo "Error: Failed to install package '$PACKAGE'."
        exit 1
      fi
    else
      echo "Package '$PACKAGE' is already installed."
    fi
  done

  git clone https://github.com/arch-osu/arch-osu-wine.git $HOME/osuinstall

  SCRIPT=$HOME/osuinstall/scripts

  clear
  $SCRIPT/yay.sh
  clear
  $SCRIPT/aur-packages.sh
  clear
  $SCRIPT/proton.sh
  clear
  $SCRIPT/nvidia-xorg.sh
  clear
  $SCRIPT/osuinstall.sh
  clear
  $SCRIPT/devserver.sh
  clear
  $SCRIPT/fonts.sh
  clear
  $SCRIPT/udev-n-audio.sh
  clear

  echo "osu! successfully installed!"
}

if [[ -f /etc/os-release ]]; then
  . /etc/os-release
  if [[ "$ID" == "arch" || "$ID_LIKE" == *"arch"* ]]; then
    run_script
  else
    echo "Why you try to use this script on not Arch-based distro???"
    exit 1
  fi
else
  echo "idk what is your distro, sorry..."
  exit 1
fi
