#!/bin/sh
# -------------------------------------------------------------------------- #
# dt.bldr installer  
# -------------------------------------------------------------------------- #
# run as follows: sudo sh install.sh 
# -------------------------------------------------------------------------- #
# set some defaults
#set -xv
set -e
umask 022
clear
# -------------------------------------------------------------------------- #
# Remove previously installed files
# ------------------------------------------------------------------ #
rm -r -f -v /opt/dt.bldr/*
# -------------------------------------------------------------------------- #
# Create directories
# ------------------------------------------------------------------ #
echo " - - - - -> Creating directories:"
mkdir -m 755 -p -v /opt/dt.bldr/bin
mkdir -m 755 -p -v /opt/dt.bldr/cfg
# -------------------------------------------------------------------------- #
# Copy files
# ------------------------------------------------------------------ #
echo " - - - - -> Copying files:"
cp -f -v bin/dt.*.sh /opt/dt.bldr/bin/
cp -f -v bin/uninstall.sh /opt/dt.bldr/bin/
cp -f -v cfg/dt.bldr.cfg /opt/dt.bldr/cfg/
# -------------------------------------------------------------------------- #
# Set owner and permissions
# ------------------------------------------------------------------ #
echo " - - - - -> Setting permissions:"
chmod -v 755 /opt/dt.bldr/bin/dt.*.sh
chmod -v 750 /opt/dt.bldr/bin/uninstall.sh
chmod -v 444 /opt/dt.bldr/cfg/dt.bldr.cfg

exit 0
# -------------------------------------------------------------------------- #
# End
