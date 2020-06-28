#!/bin/sh
# -------------------------------------------------------------------------- #
# dt.bldr installer  
# -------------------------------------------------------------------------- #
# run as follows: sudo sh install.sh 
# -------------------------------------------------------------------------- #
#set -xv
set -e
umask 022
clear
# -------------------------------------------------------------------------- #
# Forcefully remove previously installed directories and files
# ------------------------------------------------------------------ #
echo ""
echo " - - - - -> removing previous version:"
rm -r -f -v /opt/dt.bldr 2>/dev/null
# -------------------------------------------------------------------------- #
# Create directory structure
# ------------------------------------------------------------------ #
echo ""
echo " - - - - -> Creating directories:"
mkdir -m 755 -v /opt/dt.bldr
mkdir -m 755 -v /opt/dt.bldr/bin
mkdir -m 755 -v /opt/dt.bldr/cfg
# -------------------------------------------------------------------------- #
# Copy files
# ------------------------------------------------------------------ #
echo ""
echo " - - - - -> Copying files:"
cp -f -v bin/dt.*.sh /opt/dt.bldr/bin/
cp -f -v bin/uninstall.sh /opt/dt.bldr/bin/
cp -f -v cfg/dt.bldr.cfg /opt/dt.bldr/cfg/
# -------------------------------------------------------------------------- #
# Set owner and permissions
# ------------------------------------------------------------------ #
echo ""
echo " - - - - -> Setting permissions:"
chmod -v 755 /opt/dt.bldr/bin/dt.*.sh
chmod -v 750 /opt/dt.bldr/bin/uninstall.sh
chmod -v 444 /opt/dt.bldr/cfg/dt.bldr.cfg
# -------------------------------------------------------------------------- #
# Done
# ------------------------------------------------------------------ #
echo ""
echo " - - - - -> Done:"
exit 0
# -------------------------------------------------------------------------- #
# End
