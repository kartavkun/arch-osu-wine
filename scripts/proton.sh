#!/bin/bash

mkdir -p "$HOME/tmp"
mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/share/osuconfig"
mkdir -p "$HOME/.local/share/wineprefixes"

PROTON_VERSION=9-16

# Proton-osu mirrors
PROTONLINK="https://github.com/whrvt/umubuilder/releases/download/proton-osu-$PROTON_VERSION/proton-osu-$PROTON_VERSION.tar.xz"
WINEPREFIX="https://gitlab.com/NelloKudo/osu-winello-prefix/-/raw/master/osu-winello-prefix.tar.xz"

# Download Proton and Wineprefix
wget -O "$HOME/tmp/proton-osu-$PROTON_VERSION.tar.xz" "$PROTONLINK"
wget -O "$HOME/tmp/osu-winello-prefix-umu.tar.xz" "$WINEPREFIX"

# Extract Proton
tar -xf "$HOME/tmp/proton-osu-$PROTON_VERSION.tar.xz" -C "$HOME/.local/share/osuconfig"

# Extract Wineprefix
tar -xf "$HOME/tmp/osu-winello-prefix-umu.tar.xz" -C "$HOME/.local/share/wineprefixes"
mv "$HOME/.local/share/wineprefixes/osu-umu" "$HOME/.local/share/wineprefixes/osu-wineprefix"
