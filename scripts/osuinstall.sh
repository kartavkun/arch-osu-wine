#!/bin/bash

mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/applications"

# Download osu!
mkdir ~/osu/
wget --output-document ~/osu/osu\!.exe https://m1.ppy.sh/r/osu\!install.exe

FILES_DIR=$HOME/osuinstall/files
DOT_LOCAL_DIR=$HOME/.local

# Make start file for osu!
cp $FILES_DIR/.local/osu $DOT_LOCAL_DIR/bin
chmod +x $DOT_LOCAL_DIR/bin/osu

# Make .desktop file for rofi/wofi
cp $FILES_DIR/.local/osu.desktop $DOT_LOCAL_DIR/share/applications
chmod +x $DOT_LOCAL_DIR/share/applications/osu.desktop
cp $FILES_DIR/.local/osu-icon.png $DOT_LOCAL_DIR/share/applications
