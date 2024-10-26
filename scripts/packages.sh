#/bin/bash

# Install yay
if ! command -v yay &> /dev/null; then
    echo "Installing yay..."

    # Clone the yay repository
    git clone https://aur.archlinux.org/yay.git
    cd yay || exit
    makepkg -si --noconfirm
    cd .. && rm -rf yay
else
    echo "yay is already installed."
fi

# Install OTD, osu-handler, osu-mime and tosu
yay -S --needed --noconfirm opentabletdriver osu-handler osu-mime tosu

# Fix OTD
echo "blacklist wacom" | sudo tee -a /etc/modprobe.d/blacklist.conf
sudo rmmod wacom
echo "blacklist hid_uclogic" | sudo tee -a /etc/modprobe.d/blacklist.conf
sudo rmmod hid_uclogic
systemctl --user daemon-reload
systemctl --user enable opentabletdriver --now

$HOME/ArchOsu/scripts/proton.sh
