# XIVLauncher.Core local installer
A quick and dirty script to install (or uninstall) XIVLauncher locally without flatpak. Assuming you have a native (non-flatpak) install of steam, lutris, or even just wine, the dependencies should be met.

## How to use
Download XIVLocal-Installer.tar.gz from the latest release and extract. Alternately, `git clone` the repo.

Then run the install script
```
$ ./install.sh -h
Local install script for XIVLauncher.Core.
    --help, -h        Print this help text.
    --local           Install locally. Default option if nothing else is set.
    --steam           Install as steam compatibility tool
    --steamflatpak    Install as steam compatibility tool for flatpak steam
    --uninstall, -u   Uninstall. Works with the above options.
    --RB              Use XIVLauncher-RB instead of the official XIVLauncher.Core.
    --force, -f       Force install even if the current version is up-to-date.
    --download, -d    Download the files even if they are cached.
    --cc              Clear the cached files on exit.
```

## What this script does
### Using --local
1. Create a new directory at `$XDG_DATA_HOME/xivlauncher-local`. This is usually `~/.local/share/xivlauncher-local`, but if you're running this inside a flatpak, it could be different.
2. Download and extract aria2-static.tar.gz from https://github.com/rankynbass/aria2-static-build. This is a statically built copy of aria2 (built in debian12, but since it's statically linked, that doesn't really matter).
3. Download and extract XIVLauncher.Core.tar.gz from the official github at https://github.com/goatcorp/XIVLauncher.Core
4. Copy over a launcher script and other necessary files.
5. Make a symlink to the launcher at ~/.local/bin/xivlauncher-local. This will allow you to launch from the terminal with a simple `xivlauncher-local`. You will need to update your $PATH variable to include `$HOME/.local/bin`, if it isn't already done.
6. Create a .desktop file that points to the launcher, and try to refresh your desktop menu.

### Using --steam or --steamflatpak
1. Download and extract aria2-static and the latest XIVLauncher as above.
2. Copy the necessary files from the `resources` folder to the steam compatibility tool directory
3. After restarting steam, you can right-click on Final Fantasy XIV, go to settings, Compatibility, and select "XIVLauncher as Compatibility Tool".
4. Now when you launch FFXIV from steam, it will use XIVLauncher.Core instead. This solves the issues with running flatpaks under steam.

## Licensing
This install script will download a pre-compiled static copy of aria2 that does not depend on any system libraries. Aria2 is GPL v2 software. The source code can be found at [[this link](https://github.com/aria2/aria2)]. A copy of the license can be found in the repo as COPYING.GPL2 or [[online](https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt)].

XIVLauncher is licensed under GPL v3, and can be found here: [[XIVLauncher.Core](https://github.com/goatcorp/XIVLauncher.Core)] | [[XIVLauncher-RB](https://github.com/rankynbass/XIVLauncher.Core)]

The scripts included in this repo are licensed under GPL v3. A copy of the license can be found in the repo as COPYING.GPL3 or [[online](https://www.gnu.org/licenses/gpl-3.0.txt)].
