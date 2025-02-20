#!/bin/bash

mkdir -p $HOME/tmp
FONTS_DIR="$HOME/tmp"
FONT_TAR="https://gitlab.com/kartavkun/arch-osu-wine-extras/-/raw/main/WindowsFonts.tar.xz"

wget -O "$FONTS_DIR/WindowsFonts.tar.xz" "$FONT_TAR" && chk="$?"
tar -xf $FONTS_DIR/WindowsFonts.tar.xz -C $FONTS_DIR

# Функция для копирования шрифтов
echo "Installing fonts from Windows..."
sudo cp -r $FONTS_DIR/* /usr/share/fonts/
sudo chmod 644 /usr/share/fonts/WindowsFonts/*
sudo fc-cache --force
sudo fc-cache-32 --force
echo "The fonts successfully installed."

rm -rf $FONTS_DIR/*
