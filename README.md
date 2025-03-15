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

OpenTabletDriver is not supported on Wayland natively. Anyway, you can use it, but you need to change Absolute mode to Artist mode.
If you're using Hyprland, you need to add this to your Hyprland config file:
```
device {
    name = opentabletdriver-virtual-artist-tablet 
    output = [your output. Exec hyprctl monitors to check
}
```
This thing will fix the area position in osu! when you have two and more monitors. Also you need to change monitor from single output to overall output. idk how to call it correctly, but you've got the point, i guess

Otherwise, use X11 sessions

Common desktop environments (DE) and window managers (WM) that work on X11 include:

- [GNOME](https://gnome.org)
- [KDE Plasma](https://kde.org/en/plasma-desktop/)
- [XFCE](https://xfce.org)
- [i3](https://i3wm.org)
- [Openbox](http://openbox.org)

If you are using GNOME or KDE, make sure to select the X11 session when logging in to ensure that you are using X11.

Additionally, there is a specific tweak in the script that prioritizes the use of the discrete GPU when using gaming laptops with hybrid graphics. This is essential for optimal performance and stability during gameplay.

## Troubleshooting

#### osu! files won't open
osu-handler package for opening osu! files making two instances of osu!. You need to change default application to open osu! files to another osu! instance. Just right click on osu! file and select "Open with" and choose another osu!, also set other osu! instance as default application for osu! files

#### Audio is "farting"
The problem is your PC, is kinda slow, unfortunately, but you can fix it (probably)

Just execute this command:
```
~/osuinstall/scripts/audio-config.sh
```


#### I want to connect to Gatari or Akatsuki
Execute this command:
```
~/osuinstall/scripts/devserver.sh
```

#### If you have other issues, notify me about it in [Issues](https://github.com/kartavkun/arch-osu-wine/issues)

## Credits:
- [Wineprefix by NelloKudo](https://gitlab.com/NelloKudo/osu-winello-prefix)
- [yawl by whrvt](https://github.com/whrvt/yawl)
- [WoW64 Wine Build by NelloKudo](https://github.com/NelloKudo/WineBuilder)

- [Udev rules for Wootility by Wooting themselves](https://help.wooting.io/article/147-configuring-device-access-for-wootility-under-linux-udev-rules)
- [Udev rules for SayoDevice by me](https://www.reddit.com/r/osugame/comments/1fa919k/how_to_fix_sayodevice_web_app_on_linux/)
- Udev rules for Drunkdeer-Antler by random guy from Youtube or Reddit (I really don't remember, sorry)

- Nvidia prio in Xorg for hybrid graphic made with [Yudek](https://osu.ppy.sh/users/16149779)
- osu-handler fix for latest updates by [NelloKudo](https://github.com/NelloKudo)

## License

GPL 3.0
