#!/bin/bash

FIX_DIR="$HOME/osuinstall/scripts/nvidia-xorg"

if [ -f /etc/systemd/system/display-manager.service ]; then
  display_manager=$(readlink -f /etc/systemd/system/display-manager.service)

  if [[ "$display_manager" == *sddm* ]]; then
    if [ -f "$FIX_DIR/sddm/Xsetup" ]; then
      mv "$FIX_DIR/sddm/Xsetup" /usr/share/sddm/scripts/Xsetup
    else
      echo "Файл $FIX_DIR/sddm/Xsetup не найден"
    fi

  elif [[ "$display_manager" == *gdm* ]]; then
    sed -i 's/^#\s*\(WaylandEnable=false\)/\1/' /etc/gdm/custom.conf

    if [ -f "$FIX_DIR/gdm/optimus.desktop" ]; then
      mv "$FIX_DIR/gdm/optimus.desktop" /usr/share/gdm/greeter/autostart/optimus.desktop
      mv "$FIX_DIR/gdm/optimus.desktop" /etc/xdg/autostart/optimus.desktop
    else
      echo "Файл $FIX_DIR/gdm/optimus.desktop не найден"
    fi

  elif [[ "$display_manager" == *lightdm* ]]; then
    if [ -f "$FIX_DIR/lightdm/display_setup.sh" ]; then
      mv "$FIX_DIR/lightdm/display_setup.sh" /etc/lightdm/display_setup.sh
      chmod +x /etc/lightdm/display_setup.sh
    else
      echo "Файл $FIX_DIR/lightdm/display_setup.sh не найден"
    fi

    if ! grep -q "display-setup-script=/etc/lightdm/display_setup.sh" /etc/lightdm/lightdm.conf; then
      echo "[Seat:*]
display-setup-script=/etc/lightdm/display_setup.sh" | tee -a /etc/lightdm/lightdm.conf
    else
      echo "Настройка LightDM уже присутствует в /etc/lightdm/lightdm.conf"
    fi
  else
    exit 1
  fi
else
  echo "Файл /etc/systemd/system/display-manager.service не найден"
fi
