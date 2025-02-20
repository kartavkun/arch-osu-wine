#!/bin/bash

# Install OTD, osu-handler, osu-mime and tosu
yay -S --needed --noconfirm opentabletdriver osu-handler osu-mime tosu

# Fix OTD

# Regenerate initramfs
sudo mkinitcpio -P

# Unload kernel modules
sudo rmmod wacom hid_uclogic
systemctl --user daemon-reload
systemctl --user enable opentabletdriver --now
