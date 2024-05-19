#!/bin/sh
if [ -z "$XDG_DATA_HOME" ]; then
    XDG_DATA_HOME="$HOME/.local/share"
fi
scriptdir="$(realpath "$(dirname "$0")")"
xldir="$XDG_DATA_HOME/xivlauncher-local"

mkdir -p "$xldir"

tar -xf "$scriptdir/aria2-static.tar.gz" -C "$xldir"

echo "Downloading latest XIVLauncher.Core..."
curl -L "https://github.com/goatcorp/XIVLauncher.Core/releases/latest/download/XIVLauncher.Core.tar.gz" -o /tmp/XIVLauncher.Core.tar.gz
echo "Installing to $xldir"
tar -xvf /tmp/XIVLauncher.Core.tar.gz -C "$xldir"
rm /tmp/XIVLauncher.Core.tar.gz

echo "Copying additional files..."
cp "$scriptdir/xivlauncher.sh" "$xldir/xivlauncher-local"
mkdir -p "$HOME/.local/bin"
ln -s "$xldir/xivlauncher-local" "$HOME/.local/bin/xivlauncher-local"

cp "$scriptdir/openssl_fix.cnf" "$xldir/openssl_fix.cnf"

cp "$scriptdir/xivlauncher.png" "$xldir/xivlauncher.png"

echo "Making desktop file entry"
mkdir -p "$XDG_DATA_HOME/applications"
cp "$scriptdir/XIVLauncher.desktop" "$XDG_DATA_HOME/applications/xivlauncher-local.desktop"
sed -i "s|Exec=|Exec=$xldir/xivlauncher-local|" "$XDG_DATA_HOME/applications/xivlauncher-local.desktop"
sed -i "s|Icon=|Icon=$xldir/xivlauncher.png|" "$XDG_DATA_HOME/applications/xivlauncher-local.desktop"

echo "Trying to update desktop menu..."
xdg-desktop-menu forceupdate

echo "Installation complete. You may need to update your \$PATH variable to include \$HOME//.local/bin if you want to launch from the terminal with \"xivlauncher-local\"."
