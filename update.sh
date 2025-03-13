#/bin/bash

SCRIPT=$HOME/osuinstall/scripts

rm -rf $HOME/.local/share/osuconfig
rm -rf $HOME/.local/share/wineprefixes/
rm -rf $HOME/.local/bin/osu
rm -rf $HOME/.local/bin/osu-gatari
rm -rf $HOME/.local/bin/osu-akatsuki
rm -rf $HOME/.local/share/applications/osu.desktop
rm -rf $HOME/.local/share/applications/osu-akatsuki.desktop
rm -rf $HOME/.local/share/applications/osu-gatari.desktop
rm -rf $HOME/.local/share/applications/osu-file-extensions-handler.desktop
rm -rf $HOME/tmp/

update-desktop-database ~/.local/share/applications
rm -rf $HOME/.local/share/applications/mimeinfo.cache

mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/share/applications"
mkdir -p "$HOME/.local/share/osuconfig"
mkdir -p "$HOME/.local/share/wineprefixes"
mkdir -p "$HOME/tmp/"

# Delete old repo
rm -rf $HOME/osuinstall
git clone --depth=1 --branch=yaml-build https://github.com/kartavkun/arch-osu-wine.git $HOME/osuinstall

clear
$SCRIPT/wine.sh
clear
$SCRIPT/osuinstall.sh
clear
$SCRIPT/drivers.sh
clear

echo "osu! successfully updated!"
