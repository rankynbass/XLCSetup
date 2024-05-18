# XIVLauncher.Core local installer
A quick and dirty script to install (or uninstall) XIVLauncher locally without flatpak. Assuming you have a local install of steam, all dependencies should be met.

What this script does:

1. Create a new directory at `$XDG_DATA_HOME/xivlauncher-local`. This is usually `~/.local/share/xivlauncher-local`, but if you're running this inside a flatpak, it could be different.
2. Extract aria2-static.tar.gz. This is a statically built copy of aria2 (built in debian12, but since it's statically linked, that doesn't really matter).
3. Download and extract XIVLauncher.Core.tar.gz from the official github at https://github.com/goatcorp/XIVLauncher.Core
4. Copy over a launcher script and openssl fix.
5. Make a symlink to the launcher at ~/.local/bin/xivlauncher-local. You will need to update your $PATH variable yourself, if it isn't already done.
6. Create a .desktop file that points to the launcher, and try to refresh your desktop menu.
