#!/bin/sh
if [ -z "$XDG_DATA_HOME" ]; then
    XDG_DATA_HOME="$HOME/.local/share"
fi
xldir="XDG_DATA_HOME/NAME"
export OPENSSL_CONF="$xldir/openssl_fix.cnf"

"$xldir/XIVLauncher.Core"