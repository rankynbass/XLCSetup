#!/bin/bash
installdir=
"$installdir/rbli" --update
export OPENSSL_CONF="$installdir/openssl_fix.cnf"
"$installdir/XIVLauncher/XIVLauncher.Core" $@