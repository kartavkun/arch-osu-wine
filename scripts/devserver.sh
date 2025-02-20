#!/bin/bash

DEVSERVER_DIR="$HOME/osuinstall/files/devserver"
DOT_LOCAL_DIR="$HOME/.local"

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

read -p "Do you want to add osu! shortcut for Akatsuki? (y/n) [default: n]: " choice
choice=${choice:-n}

if [[ "$choice" == "y" ]]; then
  add_akatsuki
else
  echo "Okay"
fi

read -p "Do you want to add osu! shortcut for Gatari? (y/n) [default: n]: " choice
choice=${choice:-n}

if [[ "$choice" == "y" ]]; then
  add_gatari
else
  echo "Okay"
fi
