#/bin/bash

# Proton-osu mirrors
PROTONLINK="https://github.com/whrvt/umubuilder/releases/download/proton-osu-9-11/proton-osu-9-11.tar.xz"
WINEPREFIX="https://gitlab.com/NelloKudo/osu-winello-prefix/-/raw/master/osu-winello-prefix.tar.xz"

sudo rm -rf "$HOME/.local/share/osuconfig"
sudo rm -rf "$HOME/.local/share/wineprefixes"
rm "$HOME/.local/bin/osu"
rm "$HOME/.local/bin/osu-gatari"
rm "$HOME/.local/bin/osu-akatsuki"

# Make directories
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share"
mkdir -p "$HOME/.local/share/applications"
mkdir -p "$HOME/.local/share/osuconfig"
mkdir -p "$HOME/.local/share/wineprefixes"
mkdir -p "$HOME/.winellotmp"

# Download Proton and Wineprefix
wget -O "$HOME/.winellotmp/proton-osu-9-11.tar.xz" "$PROTONLINK" && chk="$?"
wget -O "$HOME/.winellotmp/osu-winello-prefix-umu.tar.xz" "$WINEPREFIX" && chk="$?" 

# Extract Proton
tar -xf "$HOME/.winellotmp/proton-osu-9-11.tar.xz" -C "$HOME/.local/share/osuconfig"

# Extract Wineprefix
tar -xf "$HOME/.winellotmp/osu-winello-prefix-umu.tar.xz" -C "$HOME/.local/share/wineprefixes"
mv "$HOME/.local/share/wineprefixes/osu-umu" "$HOME/.local/share/wineprefixes/osu-wineprefix" 

# Clone git repo with all files
sudo rm -rf $HOME/ArchOsu/
git clone https://github.com/kartavkun/arch-osu-wine $HOME/ArchOsu

# Определяем пути
DOT_LOCAL_DIR="$HOME/.local"
FILES_DIR="$HOME/ArchOsu/files"
FONTS_DIR="$FILES_DIR/fonts"
CONFIG_DIR="$FILES_DIR/config"
HOME_CONFIG_DIR="$HOME/.config"
UDEV_RULES_DIR="/etc/udev/rules.d"
DEVSERVER_DIR="$HOME/ArchOsu/files/devserver"
NVIDIA_XORG_DIR="$HOME/ArchOsu/files/NVIDIA-fix"

cp $FILES_DIR/.local/osu $DOT_LOCAL_DIR/bin
chmod +x $HOME/.local/bin/osu

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

# Add devservers
read -p "Do you want to add osu! shortcut for Akatsuki? (y/n) [default: n]: " choice
choice=${choice:-n}  # Устанавливаем значение по умолчанию на 'n', если пользователь нажал Enter

if [[ "$choice" == "y" ]]; then
    add_akatsuki
else
    echo "Okay"
fi

read -p "Do you want to add osu! shortcut for Gatari? (y/n) [default: n]: " choice
choice=${choice:-n}  # Устанавливаем значение по умолчанию на 'n', если пользователь нажал Enter

if [[ "$choice" == "y" ]]; then
    add_gatari
else
    echo "Okay"
fi
