#!/bin/sh
if [ -z "$XDG_DATA_HOME" ]; then
    XDG_DATA_HOME="$HOME/.local/share"
fi
if [ "$USE_RB" = "1" ]; then
    repo="rankynbass"
    name="xivlauncher-rb-local"
    title="XIVLauncher-RB"
else
    repo="goatcorp"
    name="xivlauncher-local"
    title="XIVLauncher.Core"
fi

scriptdir="$(realpath "$(dirname "$0")")"
xldir="$XDG_DATA_HOME/$name"

echo $xldir
echo "https://github.com/$repo/XIVLauncher.Core/releases/latest/download/XIVLauncher.Core.tar.gz"


mkdir -p "$xldir"

echo "Downloading static aria2 build..."
curl -L "https://github.com/rankynbass/aria2-static-build/releases/latest/download/aria2-static.tar.gz" -o /tmp/aria2-static.tar.gz
tar -xf /tmp/aria2-static.tar.gz -C "$xldir"

echo "Downloading latest XIVLauncher.Core..."
curl -L "https://github.com/$repo/XIVLauncher.Core/releases/latest/download/XIVLauncher.Core.tar.gz" -o /tmp/XIVLauncher.Core.tar.gz
echo "Installing to $xldir"
tar -xvf /tmp/XIVLauncher.Core.tar.gz -C "$xldir"
rm /tmp/XIVLauncher.Core.tar.gz

echo "Copying additional files..."
cp "$scriptdir/xivlauncher.sh" "$xldir/$name"
sed -i "s|XDG_DATA_HOME/NAME|$XDG_DATA_HOME/$name|" "$xldir/$name"
mkdir -p "$HOME/.local/bin"
ln -s "$xldir/$name" "$HOME/.local/bin/$name"

cp "$scriptdir/openssl_fix.cnf" "$xldir/openssl_fix.cnf"

cp "$scriptdir/xivlauncher.png" "$xldir/xivlauncher.png"

cp "$scriptdir/COPYING.GPL2" "$xldir/COPYING.GPL2"

cp "$scriptdir/COPYING.GPL3" "$xldir/COPYING.GPL3"

echo "Making desktop file entry"
mkdir -p "$XDG_DATA_HOME/applications"
cp "$scriptdir/XIVLauncher.desktop" "$XDG_DATA_HOME/applications/$name.desktop"
sed -i "s|Name=TITLE|Name=$title|"  "$XDG_DATA_HOME/applications/$name.desktop"
sed -i "s|Exec=|Exec=$xldir/$name|" "$XDG_DATA_HOME/applications/$name.desktop"
sed -i "s|Icon=|Icon=$xldir/xivlauncher.png|" "$XDG_DATA_HOME/applications/$name.desktop"

echo "Trying to update desktop menu..."
xdg-desktop-menu forceupdate

echo "Installation complete. You may need to update your \$PATH variable to include \$HOME/.local/bin if you want to launch from the terminal with \"xivlauncher-local\"."
