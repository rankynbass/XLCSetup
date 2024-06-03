#!/bin/bash
installdir=
"$installdir/install" --update
export OPENSSL_CONF="$installdir/openssl_fix.cnf"
"$installdir/XIVLauncher/XIVLauncher.Core" $@