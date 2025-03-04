# osu! for Arch-based distros

This script installing drivers and osu! for Arch-based distros

## Features

- Low audio latency
- Better performance than Windows
- Contains [OpenTabletDriver](https://opentabletdriver.net), [tosu](https://github.com/kotrikd/tosu) and packages for osu files
- Fonts from Windows
- udev rules for [Sayodevice web-driver](https://sayodevice.com/home), [Drunkdeer-Antler](https://drunkdeer-antler.com/) and [Wootility](https://wootility.io/) (ONLY ON CHROMIUM-BASED BROWSERS)

## Installation and update

You need to paste the command below into your terminal and follow the instructions

```sh
curl -fsSL https://raw.githubusercontent.com/kartavkun/arch-osu-wine/main/setup.sh | sh
```

If you need to update, you need to paste it

```sh
curl -fsSL https://raw.githubusercontent.com/kartavkun/arch-osu-wine/main/update.sh | sh
```

osu! located at ~/osu/

### Important Note for Wayland and OpenTabletDriver

OpenTabletDriver is not supported on Wayland natively, but you can use it, but only if you have single monitor and you need to change Absolute mode to Artist mode
More info about this on [OpenTabletDriver official site](https://opentabletdriver.net/Wiki/FAQ/LinuxAppSpecific#osu-is-not-detecting-input-from-my-tablet-wayland)
Otherwise, use X11 sessions

Common desktop environments (DE) and window managers (WM) that work on X11 include:

- [GNOME](https://gnome.org)
- [KDE Plasma](https://kde.org/ru/plasma-desktop/)
- [XFCE](https://xfce.org)
- [i3](https://i3wm.org)
- [Openbox](http://openbox.org)

If you are using GNOME or KDE, make sure to select the X11 session when logging in to ensure that you are using X11.

Additionally, there is a specific tweak in the script that prioritizes the use of the discrete GPU when using gaming laptops with hybrid graphics. This is essential for optimal performance and stability during gameplay.

## Troubleshooting
#### Audio is "farting"
The problem is your PC, is kinda slow, unfortunately, but you can fix it (probably)

I made a script for this, just use this command and change value to 128:
```
~/osuinstall/scripts/audio-config.sh
```

If this script didn't work, you can try to change buffer size in `pipewire.conf` and `pipewire-pulse.conf` in `.config/pipewire`

You need to edit `pipewire.conf` and `pipewire-pulse.conf` in `.config/pipewire`

You need to change values in these files:

`pipewire.conf`

> default.clock.quantum    = ~~64~~ 128
>
> default.clock.min-quantum  = ~~64~~ 128

`pipewire-pulse.conf`

> node.latency = ~~64~~ 128/48000

> pulse.min.req       = ~~64~~ 128/48000
> 
> pulse.default.req   = ~~64~~ 128/48000
> 
> pulse.min.frag      = ~~64~~ 128/48000
> 
> pulse.min.quantum   = ~~64~~ 128/48000
> 

Then execute this command
```
systemctl --user restart pipewire.service pipewire.socket wireplumber.service pipewire-pulse.service pipewire-pulse.socket
```

#### I want to connect to Gatari or Akatsuki
Execute this command:
```
~/osuinstall/scripts/devserver.sh
```

#### If you have other issues, notify me about it in [Issues](https://github.com/kartavkun/arch-osu-wine/issues)

## Credits:
- [Wineprefix by NelloKudo](https://gitlab.com/NelloKudo/osu-winello-prefix)
- [Proton by whrvt](https://github.com/whrvt/umubuilder)
- [Udev rules for Wootility by Wooting themselves](https://help.wooting.io/article/147-configuring-device-access-for-wootility-under-linux-udev-rules)
- [Udev rules for SayoDevice by me](https://www.reddit.com/r/osugame/comments/1fa919k/how_to_fix_sayodevice_web_app_on_linux/)
- Nvidia prio in Xorg for hybrid graphic made with [Yudek](https://osu.ppy.sh/users/16149779)
- Udev rules for Drunkdeer-Antler by random guy from Youtube or Reddit (I really don't remember, sorry)

## License

GPL 3.0
