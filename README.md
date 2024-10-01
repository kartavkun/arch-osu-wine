# osu! for Arch-based distros

This script installing drivers and osu! for Arch-based distros

## Features

- Low audio latency
- Better performance than Windows
- Contains [OpenTabletDriver](https://opentabletdriver.net), [tosu](https://github.com/kotrikd/tosu) and packages for osu files
- Fonts from Windows
- udev rules for [Sayodevice web-driver](https://sayodevice.com/home) and [Wootility](https://wootility.io/) (ONLY ON CHROMIUM-BASED BROWSERS)

## Installation

You need to paste the command below into your terminal and follow the instructions

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/kartavkun/arch-osu-wine/main/setup.sh)
```

Also I highly recommend to use DE or WM with Xorg instead of Wayland. For example, [i3](https://i3wm.org/)

For gaming laptop with hybrid graphics IS IMPORTANT

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
