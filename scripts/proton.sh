#!/bin/bash

mkdir -p "$HOME/tmp"
mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/share/osuconfig"
mkdir -p "$HOME/.local/share/wineprefixes"

# Proton-osu mirrors
PROTONLINK="https://github.com/whrvt/umubuilder/releases/download/proton-osu-9-15/proton-osu-9-15.tar.xz"
WINEPREFIX="https://gitlab.com/NelloKudo/osu-winello-prefix/-/raw/master/osu-winello-prefix.tar.xz"

# Download Proton and Wineprefix
wget -O "$HOME/tmp/proton-osu-9-15.tar.xz" "$PROTONLINK"
wget -O "$HOME/tmp/osu-winello-prefix-umu.tar.xz" "$WINEPREFIX"

# Extract Proton
tar -xf "$HOME/tmp/proton-osu-9-15.tar.xz" -C "$HOME/.local/share/osuconfig"

# Extract Wineprefix
tar -xf "$HOME/tmp/osu-winello-prefix-umu.tar.xz" -C "$HOME/.local/share/wineprefixes"
mv "$HOME/.local/share/wineprefixes/osu-umu" "$HOME/.local/share/wineprefixes/osu-wineprefix"
