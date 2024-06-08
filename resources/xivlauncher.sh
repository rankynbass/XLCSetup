#!/bin/bash
installdir=
"$installdir/xli" --update
export OPENSSL_CONF="$installdir/openssl_fix.cnf"
"$installdir/XIVLauncher/XIVLauncher.Core" $@