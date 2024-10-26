#/bin/bash


# Proton-osu mirrors
PROTONLINK="https://github.com/whrvt/umubuilder/releases/download/proton-osu-9-6/proton-osu-9-6.tar.xz"
WINEPREFIX="https://gitlab.com/NelloKudo/osu-winello-prefix/-/raw/master/osu-winello-prefix.tar.xz"

# Delete old
rm -r "$HOME/.local/share/osuconfig"
rm -r "$HOME/.local/share/wineprefixes"
rm -r "$HOME/.winellotmp"

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

# Определяем пути
NVIDIA_XORG_DIR="$HOME/ArchOsu/files/NVIDIA-fix"

get_display_manager() {
    if [ -f /etc/systemd/system/display-manager.service ]; then
        display_manager=$(readlink -f /etc/systemd/system/display-manager.service)
        case "$display_manager" in
            *sddm*)
                echo "xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto" | tee -a /usr/share/sddm/scripts/Xsetup
                ;;
            *gdm*)
              sed -i 's/^#\s*\(WaylandEnable=false\)/\1/' /etc/gdm/custom.conf
                echo "[Desktop Entry]
Type=Application
Name=Optimus
Exec=sh -c "xrandr --setprovideroutputsource modesetting NVIDIA-0; xrandr --auto"
NoDisplay=true
X-GNOME-Autostart-Phase=DisplayServer" | tee -a /usr/share/gdm/greeter/autostart/optimus.desktop
              echo "[Desktop Entry]
Type=Application
Name=Optimus
Exec=sh -c "xrandr --setprovideroutputsource modesetting NVIDIA-0; xrandr --auto"
NoDisplay=true
X-GNOME-Autostart-Phase=DisplayServer" | tee -a /etc/xdg/autostart/optimus.desktop
                ;;
            *lightdm*)
                echo "#!/bin/sh
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto" | tee -a /etc/lightdm/display_setup.sh
                chmod +x /etc/lightdm/display_setup.sh
                echo "[Seat:*]
display-setup-script=/etc/lightdm/display_setup.sh" | tee -a /etc/lightdm/lightdm.conf
                ;;
            *)
              exit 1
                ;;
        esac
    else
        echo "Файл /etc/systemd/system/display-manager.service не найден"
    fi
}

nvidia_prio_xorg() {
    sudo cp $NVIDIA_XORG_DIR/10-nvidia-drm-outputclass.conf /etc/X11/xorg.conf.d
    modeset=$(cat /sys/module/nvidia_drm/parameters/modeset)

      if [ "$modeset" = "N" ]; then
        # Если значение N, выполняем команду
        echo "options nvidia_drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidiadrm.conf
      else
        exit 1
      fi   
    echo "xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto" | sudo tee -a ~/.xinitrc
    get_display_manager
}

# Определение вендора видеокарты
VENDOR=$(lspci | grep -E "VGA|3D" | awk '{print $1}' | xargs -I{} lspci -s {} -n | awk '{print $3}' | cut -d':' -f1 | tr '\n' '_' | sed 's/_$//')

# 10de - NVIDIA
# 1002 - AMD 
# 8086 - Intel

# Установка драйверов в зависимости от вендора
case $VENDOR in
  10de)
    echo "Обнаружена NVIDIA. Установка драйверов..."
    sudo pacman -Syu --needed --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader
    ;;
  1002)
    echo "Обнаружена AMD. Установка драйверов..."
    sudo pacman -Syu --needed --noconfirm mesa xf86-video-amdgpu lib32-libva-mesa-driver lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader
    ;;
  8086)
    echo "Обнаружена Intel. Установка драйверов..."
    sudo pacman -Syu --needed --noconfirm lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader
    ;;
  8086_10de)
    echo "Обнаружена гибридная графика NVIDIA и Intel. Установка драйверов..."
    sudo pacman -Syu --needed --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader
    nvidia_prio_xorg
    ;;
  10de_8086)
    echo "Обнаружена гибридная графика NVIDIA и Intel. Установка драйверов..."
    sudo pacman -Syu --needed --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader
    nvidia_prio_xorg
    ;;
  1002_10de)
    echo "Обнаружена гибридная графика NVIDIA и AMD. Установка драйверов..."
    sudo pacman -Syu --needed --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader mesa xf86-video-amdgpu lib32-libva-mesa-driver lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader
    nvidia_prio_xorg
    ;;
  10de_1002)
    echo "Обнаружена гибридная графика NVIDIA и AMD. Установка драйверов..."
    sudo pacman -Syu --needed --noconfirm nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader mesa xf86-video-amdgpu lib32-libva-mesa-driver lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader
    nvidia_prio_xorg
    ;;
  8086_1002)
    echo "Обнаружена гибридная графика AMD и Intel. Установка драйверов..."
    sudo pacman -Syu --needed --noconfirm mesa xf86-video-amdgpu lib32-libva-mesa-driver lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader
    ;;
  1002_8086)
    echo "Обнаружена гибридная графика AMD и Intel. Установка драйверов..."
    sudo pacman -Syu --needed --noconfirm mesa xf86-video-amdgpu lib32-libva-mesa-driver lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader
    ;;

  *)
    echo "Вендор видеокарты не распознан. Убедитесь, что у вас установлены соответствующие драйвера."
    exit 1
    ;;
esac
