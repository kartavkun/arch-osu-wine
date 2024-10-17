#/bin/bash

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

$HOME/ArchOsu/scripts/packages.sh
