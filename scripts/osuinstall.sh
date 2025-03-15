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

# Fix to osu-handler not working since Stable update
# 20250122.1: https://osu.ppy.sh/home/changelog/stable40/20250122.1
# Read more at: https://github.com/NelloKudo/osu-winello/issues/175#issuecomment-2708859950

# Symlinking the osu! folder to D: drive in Wineprefix
rm -rf "$HOME/.local/share/wineprefixes/osu-wineprefix/dosdevices/d:"
ln -s "$HOME/osu" "$HOME/.local/share/wineprefixes/osu-wineprefix/dosdevices/d:"

# Importing the regedit file with the file associations fixes
YAWL_PATH="$HOME/.local/share/osuconfig/yawl-winello"

WINEPREFIX="$HOME/.local/share/wineprefixes/osu-wineprefix" \
  $YAWL_PATH regedit /s "$FILES_DIR/osu-handler-fix.reg"

# Fix osu! compatibility more
cp "$HOME/osuinstall/files/dxvk/x64/*.dll" "$HOME/.local/share/wineprefixes/osu-wineprefix/drive_c/windows/system32"
cp "$HOME/osuinstall/files/dxvk/x32/*.dll" "$HOME/.local/share/wineprefixes/osu-wineprefix/drive_c/windows/syswow64"

# Setting DllOverrides for those to Native
for dll in dxgi d3d8 d3d9 d3d10core d3d11; do
  $YAWL_PATH reg add "HKEY_CURRENT_USER\Software\Wine\DllOverrides" /v "$dll" /d native /f
done

# Fixing the osu-handler entry from AUR (if installed)
PACKAGES=("osu-handler")

for PACKAGE in "${PACKAGES[@]}"; do
  if ! pacman -Qi "$PACKAGE" &>/dev/null; then
    echo "Installing package '$PACKAGE'..."
    if ! sudo pacman -Sy --noconfirm --needed "$PACKAGE"; then
      echo "Error: Failed to install package '$PACKAGE'."
      exit 1
    fi
  else
    echo "Package '$PACKAGE' is already installed."
  fi
done

if [ -e "/usr/share/applications/osu-file-extensions-handler.desktop" ]; then
  cp "/usr/share/applications/osu-file-extensions-handler.desktop" "$HOME/.local/share/applications"
  sed -i "s|Exec=/usr/lib/osu-handler/osu-handler-wine .*osu! |Exec=/usr/lib/osu-handler/osu-handler-wine |" "$HOME/.local/share/applications/osu-file-extensions-handler.desktop"
  update-desktop-database "$HOME/.local/share/applications"
fi
