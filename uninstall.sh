#!/bin/sh
if [ -z "$XDG_DATA_HOME" ]; then
    XDG_DATA_HOME="$HOME/.local/share"
fi
scriptdir="$(realpath "$(dirname "$0")")"
xldir="$XDG_DATA_HOME/xivlauncher-core"

echo "Removing XIVLauncher.Core local directory at $xldir"
rm -rf "$xldir"
echo "Removing terminal launcher script from $HOME/.local/bin/xivlauncher-local"
rm "$HOME/.local/bin/xivlauncher-local"
echo "Removing .desktop file"
rm "$XDG_DATA_HOME/applications/xivlauncher-local.desktop"
echo "Trying to update desktop menu..."
xdg-desktop-menu forceupdate

echo "XIVLauncher.Core local install removed."