# XIVLauncher.Core local installer
A quick and dirty script to install (or uninstall) XIVLauncher locally without flatpak. Assuming you have a native (non-flatpak) install of steam, lutris, or even just wine, the dependencies should be met.

## How to use
Download XIVLocal-Installer.tar.gz from the latest release and extract. Alternately, `git clone` the repo.

Then run the install script
```
$ ./rbli -h                     
usage: rbli [-h] [-l | --custom PATH | -s | -f] [-u | --RB] [--info] [--force] [-d] [--clear]

Local install tool for XIVLauncher.Core.

options:
  -h, --help       show this help message and exit
  --info           Show information on the install target without doing anything.
  --force          Force the install even if the current version is up-to-date.
  -d, --download   Always download the source, even if it's already cached.
  --clear          Clear the cached files and exit.

Install targets:
  Where XIVLauncher will be installed

  -l, --local      Install to ~/.local/share/xivlaucher-core. The default option if no other options are passed.
  --custom PATH    Install locally to a custom location.
  -s, --steam      Install as steam compatibility tool to default path. Steam Deck users should choose this.
  -f, --flatpak    Install as steam compatibility tool for flatpak steam.
  -u, --uninstall  Uninstall the target instead.
  --RB             Install XIVLauncher-RB instead of the official XIVLauncher.Core.
```

## What this script does
### Using --local
1. Create a new directory at `$XDG_DATA_HOME/xivlauncher-local`. This is usually `~/.local/share/xivlauncher-local`, but if you're running this inside a flatpak, it could be different.
2. Download and extract aria2-static.tar.gz from https://github.com/rankynbass/aria2-static-build. This is a statically built copy of aria2 (built in ubuntu 24.04, but since it's statically linked, that doesn't really matter).
3. Download and extract XIVLauncher.Core.tar.gz from the selected github at https://github.com/goatcorp/XIVLauncher.Core or https://github.com/rankynbass/XIVLauncher.Core
4. Copy over a launcher script and other necessary files.
5. Make a symlink to the launcher at ~/.local/bin/xivlauncher-local. This will allow you to launch from the terminal with a simple `xivlauncher-local`. You will need to update your $PATH variable to include `$HOME/.local/bin`, if it isn't already done.
6. Create a .desktop file that points to the launcher, and try to refresh your desktop menu.

### Using --steam or --steamflatpak
**Note: I recommend using --RB with these options for the moment. It has a few extra bits to work around a few bugs. The official release *will* still work, however.**
1. Download and extract aria2-static and the latest XIVLauncher as above.
2. Copy the necessary files from the `resources` folder to the steam compatibility tool directory
3. After restarting steam, you can right-click on Final Fantasy XIV, go to settings, Compatibility, and select "XIVLauncher as Compatibility Tool".
4. Now when you launch FFXIV from steam, it will use XIVLauncher.Core instead. This solves the issues with running flatpaks under steam.
5. This is self-updating! It will do a quick version check, and if it detects a newer version it will download and install it. You can test this yourself by going into the `~/.local/share/Steam/compatibilitytools.d/xlcore` folder and editing the version file to 1.0.7.0. It will then download again the next time you launch.

### Using --custom PATH
You really shouldn't use this, but just in case:
1. Make sure you have permission to the PATH you set. I strongly advise against using sudo to do this; the script can delete files, and you really don't want it to delete anything important.
2. The files will be copied to `PATH/xivlauncher-local`. A .desktop file will be made in `$XDG_DATA_HOME/applications` and a symlink of `xivlauncher-local` will be made in `~/.local/bin`.
3. If you want to uninstall it, you need to use `./install -u --custom PATH` just like you did for the install. *Don't* get the path wrong, it can possibly delete files you don't want deleted.

## Licensing
This install script will download a pre-compiled static copy of aria2 that does not depend on any system libraries. Aria2 is GPL v2 software. The source code can be found at [[this link](https://github.com/aria2/aria2)]. A copy of the license can be found in the repo as COPYING.GPL2 or [[online](https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt)].

XIVLauncher is licensed under GPL v3, and can be found here: [[XIVLauncher.Core](https://github.com/goatcorp/XIVLauncher.Core)] | [[XIVLauncher-RB](https://github.com/rankynbass/XIVLauncher.Core)]

The scripts included in this repo are licensed under GPL v3. A copy of the license can be found in the repo as COPYING.GPL3 or [[online](https://www.gnu.org/licenses/gpl-3.0.txt)].
