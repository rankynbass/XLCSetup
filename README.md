# XIVLauncher.Core local installer
A quick and dirty script to install (or uninstall) XIVLauncher locally without flatpak. Assuming you have a native (non-flatpak) install of steam, lutris, or even just wine, the dependencies should be met.

## How to use
Download XIVLocal-Installer.tar.gz from the latest release and extract. Alternately, `git clone` the repo.

From the terminal, cd into the created directory, and then launch the install script with `./install.sh` to install the official XIVLauncher.Core, or `USE_RB=1 ./install.sh` if you want to install the latest XIVLauncher-RB instead.

That's it. You're done! You should now have a desktop entry for "XIVLauncher.Core (local)" or "XIVLauncher-RB (local)", which can be added to steam.

You can uninstall with `./uninstall.sh` for XIVLauncher.Core or `USE_RB=1 ./uninstall.sh` for XIVLauncher-RB.

## How to add to flatpak steam
This is a little trickier, but still entirely doable. You can enter the flatpak environment with
```
flatpak run --command=bash com.valvsoftware.Steam
```
and then do
```
curl -L https://github.com/rankynbass/XIVLocal/releases/latest/download/XIVLocal-Installer.tar.gz -o XIVLocal-Installer.tar.gz
tar -xf XIVLocal-Installer.tar.gz
cd `XIVLocal-Installer`
./install.sh
```

Then you can launch Steam, add a non-steam game, Browse, change the filter to All Files, and browse to `~/.var/app/com.valvesoftware.Steam/.local/applications`. Then select `xivlauncher-local.desktop`. Secret service doesn't work at the moment, so you'll have to add `XL_SECRET_PROVIDER=FILE %command%` to the launch arguments to save your password.

## What this script does
1. Create a new directory at `$XDG_DATA_HOME/xivlauncher-local`. This is usually `~/.local/share/xivlauncher-local`, but if you're running this inside a flatpak, it could be different.
2. Download and extract aria2-static.tar.gz from https://github.com/rankynbass/aria2-static-build. This is a statically built copy of aria2 (built in debian12, but since it's statically linked, that doesn't really matter).
3. Download and extract XIVLauncher.Core.tar.gz from the official github at https://github.com/goatcorp/XIVLauncher.Core
4. Copy over a launcher script and openssl fix.
5. Make a symlink to the launcher at ~/.local/bin/xivlauncher-local. This will allow you to launch from the terminal with a simple `xivlauncher-local`. You will need to update your $PATH variable to include `$HOME/.local/bin`, if it isn't already done.
6. Create a .desktop file that points to the launcher, and try to refresh your desktop menu.

## Licensing
This repo includes a pre-compiled static copy of aria2 that does not depend on any system libraries. Aria2 is GPL v2 software. The source code can be found at [[this link](https://github.com/aria2/aria2)]. A copy of the license can be found in the repo as COPYING.GPL2 or [[online](https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt)].

XIVLauncher is licensed under GPL v3, and can be found here: [[XIVLauncher.Core](https://github.com/goatcorp/XIVLauncher.Core)] | [[XIVLauncher-RB](https://github.com/rankynbass/XIVLauncher.Core)]

The scripts included in this repo are licensed under GPL v3. A copy of the license can be found in the repo as COPYING.GPL3 or [[online](https://www.gnu.org/licenses/gpl-3.0.txt)].
