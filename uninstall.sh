#!/bin/sh
if [ -z "$XDG_DATA_HOME" ]; then
    XDG_DATA_HOME="$HOME/.local/share"
fi
if [ "$USE_RB" = "1" ]; then
    name="xivlauncher-rb-local"
    title="XIVLauncher-RB"
else
    name="xivlauncher-local"
    title="XIVLauncher.Core"
fi
scriptdir="$(realpath "$(dirname "$0")")"
xldir="$XDG_DATA_HOME/$name"

echo "Removing $title local directory at $xldir"
rm -rf "$xldir"
echo "Removing terminal launcher script from $HOME/.local/bin/$name"
rm "$HOME/.local/bin/$name"
echo "Removing .desktop file"
rm "$XDG_DATA_HOME/applications/$name.desktop"
echo "Trying to update desktop menu..."
xdg-desktop-menu forceupdate

echo "$title local install removed."