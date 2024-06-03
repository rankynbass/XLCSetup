#!/bin/bash
installdir=
parentdir="$(dirname "$installdir")"
"$installdir/install" --update --custom "$parentdir"
export OPENSSL_CONF="$installdir/openssl_fix.cnf"
"$installdir/XIVLauncher/XIVLauncher.Core" $@