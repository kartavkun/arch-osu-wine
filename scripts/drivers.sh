#!/bin/bash

NVIDIA_XORG_DIR="$HOME/osuinstall/files/NVIDIA-fix"

nvidia_prio_xorg() {
  sudo cp $NVIDIA_XORG_DIR/10-nvidia-drm-outputclass.conf /etc/X11/xorg.conf.d
  modeset=$(cat /sys/module/nvidia_drm/parameters/modeset)

  if [ "$modeset" = "N" ]; then
    # If the value is N, execute the command
    echo "options nvidia_drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidiadrm.conf
  else
    exit 1
  fi
  echo "xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto" | sudo tee -a ~/.xinitrc
  $HOME/osuinstall/scripts/display-manager.sh
}

# Detecting GPU vendor
VENDOR=$(lspci | grep -E "VGA|3D" | awk '{print $1}' | xargs -I{} lspci -s {} -n | awk '{print $3}' | cut -d':' -f1 | tr '\n' '_' | sed 's/_$//')

# 10de - NVIDIA
# 1002 - AMD
# 8086 - Intel

# Installing drivers based on the vendor
case $VENDOR in
10de)
  echo "NVIDIA detected. Installing drivers..."
  sudo pacman -Syu --needed --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader
  ;;
1002)
  echo "AMD detected. Installing drivers..."
  sudo pacman -Syu --needed --noconfirm mesa xf86-video-amdgpu lib32-libva-mesa-driver lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader
  ;;
8086)
  echo "Intel detected. Installing drivers..."
  sudo pacman -Syu --needed --noconfirm lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader
  ;;
8086_10de | 10de_8086)
  echo "Hybrid graphics detected: NVIDIA + Intel. Installing drivers..."
  sudo pacman -Syu --needed --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader
  nvidia_prio_xorg
  ;;
1002_10de | 10de_1002)
  echo "Hybrid graphics detected: NVIDIA + AMD. Installing drivers..."
  sudo pacman -Syu --needed --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader mesa xf86-video-amdgpu lib32-libva-mesa-driver lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader
  nvidia_prio_xorg
  ;;
8086_1002 | 1002_8086)
  echo "Hybrid graphics detected: AMD + Intel. Installing drivers..."
  sudo pacman -Syu --needed --noconfirm mesa xf86-video-amdgpu lib32-libva-mesa-driver lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader
  ;;
*)
  echo "Unknown GPU vendor. Please ensure the appropriate drivers are installed."
  exit 1
  ;;
esac
