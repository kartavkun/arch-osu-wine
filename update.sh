#/bin/bash

SCRIPT=$HOME/osuinstall/scripts

sudo rm -rf $HOME/.local/share/osuconfig
sudo rm -rf $HOME/.local/share/wineprefixes/
sudo rm -rf $HOME/.local/bin/osu
sudo rm -rf $HOME/.local/bin/osu-gatari
sudo rm -rf $HOME/.local/bin/osu-akatsuki
sudo rm -rf $HOME/.local/share/applications/osu.desktop
sudo rm -rf $HOME/.local/share/applications/osu-akatsuki.desktop
sudo rm -rf $HOME/.local/share/applications/osu-gatari.desktop
sudo rm -rf $HOME/tmp/

mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/share/applications"
mkdir -p "$HOME/.local/share/osuconfig"
mkdir -p "$HOME/.local/share/wineprefixes"
mkdir -p "$HOME/tmp/"

# Delete old repo
rm -rf $HOME/osuinstall
git clone --depth 1 https://github.com/kartavkun/arch-osu-wine.git $HOME/osuinstall
cd $HOME/osuinstall

clear
$SCRIPT/osuinstall.sh
clear
$SCRIPT/drivers.sh
clear
$SCRIPT/devserver.sh

echo "osu! successfully updated!"
