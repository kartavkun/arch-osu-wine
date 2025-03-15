#!/bin/bash

mkdir -p "$HOME/tmp"
mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/share/osuconfig"
mkdir -p "$HOME/.local/share/wineprefixes"

# Wine-osu current versions for update
MAJOR=10
MINOR=3
PATCH=6
WINEVERSION=$MAJOR.$MINOR-$PATCH
LASTWINEVERSION=0

# Wine-osu mirror
WINELINK="https://github.com/NelloKudo/WineBuilder/releases/download/wine-osu-staging-${WINEVERSION}/wine-osu-winello-fonts-wow64-${WINEVERSION}-x86_64.tar.xz"

YAWLVERSION=0.6.2

PREFIXLINK="https://gitlab.com/NelloKudo/osu-winello-prefix/-/raw/master/osu-winello-prefix.tar.xz" # Default WINEPREFIX
YAWLLINK="https://github.com/whrvt/yawl/releases/download/v${YAWLVERSION}/yawl"                     # yawl (Wine launcher for Steam Runtime)

# Exported global variables

export WINE_PATH="$HOME/.local/share/osuconfig/wine-osu"

export WINENTSYNC="0" # Don't use these for setup-related stuff to be safe
export WINEFSYNC="0"
export WINEESYNC="0"

YAWL_PATH="$HOME/.local/share/osuconfig/yawl-winello"

# Download Wine, yawl and Wineprefix
wget -O "$HOME/tmp/wine-osu-winello-fonts-wow64-$MAJOR.$MINOR-$PATCH-x86_64.tar.xz" "$WINELINK"
wget -O "$HOME/tmp/osu-winello-prefix-umu.tar.xz" "$PREFIXLINK"
wget -O "$HOME/tmp/yawl" "$YAWLLINK"

# Extract Wine-osu
tar -xf "$HOME/tmp/wine-osu-winello-fonts-wow64-$MAJOR.$MINOR-$PATCH-x86_64.tar.xz" -C "$HOME/.local/share/osuconfig"

# Extract Wineprefix
tar -xf "$HOME/tmp/osu-winello-prefix-umu.tar.xz" -C "$HOME/.local/share/wineprefixes"
mv "$HOME/.local/share/wineprefixes/osu-umu" "$HOME/.local/share/wineprefixes/osu-wineprefix"

# Move yawl
mv "$HOME/tmp/yawl" "$HOME/.local/share/osuconfig"
chmod +x "$HOME/.local/share/osuconfig/yawl"

# Install and verify yawl ASAP, the wrapper mode does not download/install the runtime if no arguments are passed
YAWL_VERBS="make_wrapper=winello;exec=$WINE_PATH/bin/wine;wineserver=$WINE_PATH/bin/wineserver" "$HOME/.local/share/osuconfig/yawl"

YAWL_VERBS="update;verify" "$YAWL_PATH" "--version"
