#!/bin/bash

run_script() {

start_script() {
  # Clone git repo with all files
git clone https://github.com/kartavkun/arch-osu-wine $HOME/arch-osu-wine
git checkout separated

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

clear
echo -e "   ___            _ ____  _        _     _         __                 _             _      "
echo -e "  / _ \\ ___ _   _| / ___|| |_ __ _| |__ | | ___   / _| ___  _ __     / \\   _ __ ___| |__   "
echo -e " | | | / __| | | | \\___ \\| __/ _\` | '_ \\| |/ _ \\ | |_ / _ \\| '__|   / _ \\ | '__/ __| '_ \\  "
echo -e " | |_| \\__ \\ |_| |_|___) | || (_| | |_) | |  __/ |  _| (_) | |     / ___ \\| | | (__| | | | "
echo -e "  \\___/|___/\\__,_(_)____/ \\__\\__,_|_.__/|_|\\___| |_|  \\___/|_|    /_/   \\_\\_|  \\___|_| |_| "
echo ""
read -p "Do you want to start installing osu!stable? (y/n) [default: y]: " choice
choice=${choice:-y}  # Устанавливаем значение по умолчанию на 'n', если пользователь нажал Enter

if [[ "$choice" == "y" ]]; then
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
