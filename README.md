# osu! for Arch-based distros

This script installing drivers and osu! for Arch-based distros

## Features

- Low audio latency
- Better performance than Windows
- Contains [OpenTabletDriver](https://opentabletdriver.net), [tosu](https://github.com/kotrikd/tosu) and packages for osu files
- Fonts from Windows
- udev rules for [Sayodevice web-driver](https://sayodevice.com/home), [Drunkdeer-Antler](https://drunkdeer-antler.com/) and [Wootility](https://wootility.io/) (ONLY ON CHROMIUM-BASED BROWSERS)

## Installation

You need to paste the command below into your terminal and follow the instructions

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/kartavkun/arch-osu-wine/main/setup.sh)
```

### Important Note on Xorg and Wayland

For playing osu!, it is recommended to use Xorg instead of Wayland, as Wayland can introduce a slight but noticeable input lag, which is critical for gameplay. Xorg provides lower latency and better responsiveness.

Common desktop environments (DE) and window managers (WM) that work on Xorg include:

- [GNOME](https://gnome.org)
- [KDE Plasma](https://kde.org/ru/plasma-desktop/)
- [XFCE](https://xfce.org)
- [i3](https://i3wm.org)
- [Openbox](http://openbox.org)

If you are using GNOME or KDE, make sure to select the X session when logging in to ensure that you are using Xorg.

Additionally, a specific tweak is applied in Xorg to prioritize the use of the discrete GPU when using gaming laptops with hybrid graphics. This is essential for optimal performance and stability during gameplay.


## Troubleshooting
#### Audio is "farting"
The problem is your CPU, is kinda slow, but you can fix it (probably)

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

#### If you have other issues, notify me about it in [Issues](https://github.com/kartavkun/arch-osu-wine/issues)

## Credits:
- [Wineprefix by NelloKudo](https://gitlab.com/NelloKudo/osu-winello-prefix)
- [Proton by whrvt](https://github.com/whrvt/umubuilder)
- [Udev rules for Wooting by Wooting themselves](https://help.wooting.io/article/147-configuring-device-access-for-wootility-under-linux-udev-rules)
- [Udev rules for SayoDevice by me](https://www.reddit.com/r/osugame/comments/1fa919k/how_to_fix_sayodevice_web_app_on_linux/)
- Nvidia prio in Xorg for hybrid graphic made with [Yudek](https://osu.ppy.sh/users/16149779)

## License

GPL 3.0
