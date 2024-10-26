#/bin/bash 

# Proton-osu mirrors
PROTONLINK="https://github.com/whrvt/umubuilder/releases/download/proton-osu-9-6/proton-osu-9-6.tar.xz"
WINEPREFIX="https://gitlab.com/NelloKudo/osu-winello-prefix/-/raw/master/osu-winello-prefix.tar.xz"

# Make directories
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/share/applications"
mkdir -p "$HOME/.local/share/osuconfig"
mkdir -p "$HOME/.local/share/wineprefixes"
mkdir -p "$HOME/.winellotmp"

# Download Proton and Wineprefix
wget -O "$HOME/.winellotmp/proton-osu-9-6.tar.xz" "$PROTONLINK" && chk="$?"
wget -O "$HOME/.winellotmp/osu-winello-prefix-umu.tar.xz" "$WINEPREFIX" && chk="$?" 

# Extract Proton
tar -xf "$HOME/.winellotmp/proton-osu-9-6.tar.xz" -C "$HOME/.local/share/osuconfig"

# Extract Wineprefix
tar -xf "$HOME/.winellotmp/osu-winello-prefix-umu.tar.xz" -C "$HOME/.local/share/wineprefixes"
mv "$HOME/.local/share/wineprefixes/osu-umu" "$HOME/.local/share/wineprefixes/osu-wineprefix" 

rm -r $HOME/.winellotmp

$HOME/ArchOsu/scripts/drivers.sh
