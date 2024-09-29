# osu! for Arch-based distros

This script installing drivers and osu! for Arch-based distros

## Features

- Low audio latency
- Better performance than Windows
- Contains OpenTabletDriver, tosu and packages for osu files
- Fonts from Windows
- udev rules for Sayodevice web-driver and Wootility

## Installation

You need to paste the command below into your terminal and follow the instructions

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/kartavkun/arch-osu-wine/main/setup.sh)
```

## Troubleshooting
#### Audio is "farting"
The problem is your CPU, is kinda slow, but you can fix it (probably)

You need to edit `pipewire.conf` and `pipewire-pulse.conf` in `.config/pipewire`

You need to change values in these files:

`pipewire.conf`
default.clock.quantum    = ~~64~~ 128
default.clock.min-quantum  = ~~64~~ 128


`pipewire-pulse.conf`
node.latency = ~~64~~ 128/48000

pulse.min.req       = ~~64~~ 128/48000
pulse.default.req   = ~~64~~ 128/48000
pulse.min.frag      = ~~64~~ 128/48000
pulse.min.quantum   = ~~64~~ 128/48000

#### If you have other issues, notify me about it in [Issues](https://github.com/kartavkun/arch-osu-wine/issues)

## Credits:
[Wineprefix by NelloKudo](https://gitlab.com/NelloKudo/osu-winello-prefix)
[Proton by whrvt](https://github.com/whrvt/umubuilder)

## License

GPL 3.0
