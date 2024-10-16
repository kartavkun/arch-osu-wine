#!/bin/bash

run_script() {

start_script() {
  # Clone git repo with all files
git clone https://github.com/kartavkun/arch-osu-wine $HOME/arch-osu-wine

chmod +x $HOME/ArchOsu/scripts/
}

# Install necessary packages
PACKAGES=("wget" "base-devel" "git" "go" "zenity" "xdg-desktop-portal" "linux-zen" "linux-zen-headers" "pipewire" "wireplumber" "xdg-utils" "xdg-desktop-portal-gtk")

for PACKAGE in "${PACKAGES[@]}"; do
    if ! pacman -Qi "$PACKAGE" &> /dev/null; then
        echo "Installing package '$PACKAGE'..."
        if ! sudo pacman -Syu --noconfirm --needed "$PACKAGE"; then
            echo "Error: Failed to install package '$PACKAGE'."
            exit 1
        fi
    else
        echo "Package '$PACKAGE' is already installed."
    fi
done

read -p "Do you want to start installing osu!stable? (y/n) [default: y]: " choice
choice=${choice:-y}  # Устанавливаем значение по умолчанию на 'n', если пользователь нажал Enter

if [[ "$choice" == "n" ]]; then
    start_script
else
    echo "Okay"
    exit 1
fi
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
