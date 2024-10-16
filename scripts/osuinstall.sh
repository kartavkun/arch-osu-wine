#/bin/bash

DOT_LOCAL_DIR="$HOME/.local"
FILES_DIR="$HOME/ArchOsu/files"
FONTS_DIR="$FILES_DIR/fonts"
CONFIG_DIR="$FILES_DIR/config"
HOME_CONFIG_DIR="$HOME/.config"
UDEV_RULES_DIR="/etc/udev/rules.d"
DEVSERVER_DIR="$HOME/ArchOsu/files/devserver"

# Download osu!
mkdir ~/osu/
wget --output-document ~/osu/osu\!.exe https://m1.ppy.sh/r/osu\!install.exe

add_akatsuki() {
  cp $DEVSERVER_DIR/akatsuki/osu-akatsuki $DOT_LOCAL_DIR/bin
  cp $DEVSERVER_DIR/akatsuki/osu-akatsuki.desktop $DOT_LOCAL_DIR/share/applications
  chmod +x $HOME/.local/bin/osu-akatsuki
  chmod +x $HOME/.local/share/applications/osu-akatsuki.desktop
}

add_gatari() {
  cp $DEVSERVER_DIR/gatari/osu-gatari $DOT_LOCAL_DIR/bin
  cp $DEVSERVER_DIR/gatari/osu-gatari.desktop $DOT_LOCAL_DIR/share/applications
  chmod +x $HOME/.local/bin/osu-gatari
  chmod +x $HOME/.local/share/applications/osu-gatari.desktop
}
# Make start file for osu!
cp $FILES_DIR/.local/osu $DOT_LOCAL_DIR/bin
chmod +x $HOME/.local/bin/osu

# Make .desktop file for rofi/wofi
cp $FILES_DIR/.local/osu.desktop $DOT_LOCAL_DIR/share/applications
chmod +x $HOME/.local/share/applications/osu.desktop

# Add devservers
read -p "Do you want to add osu! shortcut for Akatsuki? (y/n) [default: n]: " choice
choice=${choice:-n}  # Устанавливаем значение по умолчанию на 'n', если пользователь нажал Enter

if [[ "$choice" == "y" ]]; then
    add_akatsuki
else
    echo "Okay"
fi

read -p "Do you want to add osu! shortcut for Gatari? (y/n) [default: n]: " choice
choice=${choice:-n}  # Устанавливаем значение по умолчанию на 'n', если пользователь нажал Enter

if [[ "$choice" == "y" ]]; then
    add_gatari
else
    echo "Okay"
fi

$HOME/ArchOsu/scripts/configs.sh
