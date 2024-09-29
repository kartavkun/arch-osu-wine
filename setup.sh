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
PACKAGES=("wget" "base-devel" "git" "go" "zenity" "xdg-desktop-portal")

for PACKAGE in "${PACKAGES[@]}"; do
    if ! pacman -Qi "$PACKAGE" &> /dev/null; then
        echo "Installing package '$PACKAGE'..."
        if ! sudo pacman -S --noconfirm "$PACKAGE"; then
            echo "Error: Failed to install package '$PACKAGE'."
            exit 1
        fi
    else
        echo "Package '$PACKAGE' is already installed."
    fi
done

# Install yay
if ! command -v yay &> /dev/null; then
    echo "Installing yay..."

    # Clone the yay repository
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg -si --noconfirm
    cd .. && rm -rf yay
else
    echo "yay is already installed."
fi

echo "All necessary packages have been successfully installed."

# Install linux-zen kernel
sudo pacman --noconfirm --needed linux-zen linux-zen-headers xdg-utils xdg-desktop-portal xdg-desktop-portal-gtk pipewire wireplumber

# Определение вендора видеокарты
VENDOR=$(lspci | grep -E "VGA|3D" | awk '{print $1}' | xargs -I{} lspci -s {} -n | awk '{print $3}' | cut -d':' -f1)

# Установка драйверов в зависимости от вендора
case $VENDOR in
  10de)
    echo "Обнаружена NVIDIA. Установка драйверов..."
    sudo pacman -Syu --needed --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader
    ;;
  1002)
    echo "Обнаружена AMD. Установка драйверов..."
    sudo pacman -Syu --needed --noconfirm mesa xf86-video-amdgpu lib32-libva-mesa-driver lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader
    ;;
  8086)
    echo "Обнаружена Intel. Установка драйверов..."
    sudo pacman -Syu --needed --noconfirm lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader
    ;;
  *)
    echo "Вендор видеокарты не распознан. Убедитесь, что у вас установлены соответствующие драйвера."
    exit 1
    ;;
esac

# Install OTD, osu-handler, osu-mime and tosu
yay -S --needed --noconfirm opentabletdriver osu-handler osu-mime tosu

# Fix OTD
echo "blacklist wacom" | sudo tee -a /etc/modprobe.d/blacklist.conf
sudo rmmod wacom
echo "blacklist hid_uclogic" | sudo tee -a /etc/modprobe.d/blacklist.conf
sudo rmmod hid_uclogic
systemctl --user daemon-reload
systemctl --user enable opentabletdriver --now

# Proton-osu mirrors
PROTONLINK="https://github.com/whrvt/umubuilder/releases/download/proton-osu-9-5/proton-osu-9-5.tar.xz"
WINEPREFIX="https://gitlab.com/NelloKudo/osu-winello-prefix/-/raw/master/osu-winello-prefix.tar.xz"

# Make directories
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/share/applications"
mkdir -p "$HOME/.local/share/osuconfig"
mkdir -p "$HOME/.local/share/wineprefixes"
mkdir -p "$HOME/.winellotmp"

# Download Proton and Wineprefix
wget -O "$HOME/.winellotmp/proton-osu-9-5.tar.xz" "$PROTONLINK" && chk="$?"
wget -O "$HOME/.winellotmp/osu-winello-prefix-umu.tar.xz" "$WINEPREFIX" && chk="$?" 

# Extract Proton
tar -xf "$HOME/.winellotmp/proton-osu-9-5.tar.xz" -C "$HOME/.local/share/osuconfig"

# Extract Wineprefix
tar -xf "$HOME/.winellotmp/osu-winello-prefix-umu.tar.xz" -C "$HOME/.local/share/wineprefixes"
mv "$HOME/.local/share/wineprefixes/osu-umu" "$HOME/.local/share/wineprefixes/osu-wineprefix" 

# Download osu!
mkdir ~/osu/
wget --output-document ~/osu/osu\!.exe https://m1.ppy.sh/r/osu\!install.exe

# Make web driver work with SayoDevices
echo "# SayoDevice O3C
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1d6b", TAG+="uaccess"
SUBSYSTEM=="usb", ATTRS{idVendor}=="1d6b", TAG+="uaccess"

# SayoDevice O3C++ / CMF51+
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="8089", TAG+="uaccess" 
SUBSYSTEM=="usb", ATTRS{idVendor}=="8089", TAG+="uaccess"

# SayoDevice ???" |  sudo tee "/etc/udev/rules.d/70-sayo.rules" >/dev/null

# Make web driver work with Wooting
echo "# Wooting One Legacy

SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", TAG+="uaccess"

SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", TAG+="uaccess"

# Wooting One update mode

SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402", TAG+="uaccess"

# Wooting Two Legacy

SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", TAG+="uaccess"

SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", TAG+="uaccess"

# Wooting Two update mode

SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2403", TAG+="uaccess"

# Generic Wootings

SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", TAG+="uaccess"

SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", TAG+="uaccess"" | sudo tee "/etc/udev/rules.d/70-wooting.rules" >/dev/null

# Init udev rules
sudo udevadm control --reload-rules && sudo udevadm trigger

# Clone git repo with all files
git clone https://github.com/kartavkun/arch-osu-wine $HOME/ArchOsu

# Определяем пути
DOT_LOCAL_DIR="$HOME/.local"
FILES_DIR="$HOME/ArchOsu/files"
FONTS_DIR="$FILES_DIR/fonts"
CONFIG_DIR="$FILES_DIR/config"
HOME_CONFIG_DIR="$HOME/.config"

# Make start file for osu!
cp $FILES_DIR $DOT_LOCAL_DIR/bin
chmod +x "$HOME/.local/bin/osu"

# Make .desktop file for rofi/wofi
cp $FILES_DIR $DOT_LOCAL_DIR/share
chmod +x "$HOME/.local/share/applications/osu.desktop"

# Функция для копирования шрифтов
echo "Installing fonts from Windows..."
sudo cp -r "$FONTS_DIR"/* /usr/share/fonts/
chmod 644 /usr/share/fonts/WindowsFonts/*
sudo fc-cache --force
sudo fc-cache-32 --force
echo "The fonts successfully installed."

# Функция для копирования конфигов
echo "Install wireplumber config files"
cp -r "$CONFIG_DIR/wireplumber" "$HOME_CONFIG_DIR/"

echo "Install pipewire config files"
cp -r "$CONFIG_DIR/pipewire" "$HOME_CONFIG_DIR/"

systemctl --user restart pipewire.service pipewire.socket wireplumber.service pipewire-pulse.service pipewire-pulse.socket
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
