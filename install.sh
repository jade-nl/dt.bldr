#!/bin/sh
# -------------------------------------------------------------------------- #
# dt.bldr installer  
# -------------------------------------------------------------------------- #
# run as follows:
#   sudo sh install.sh 
# -------------------------------------------------------------------------- #
#set -xv
set -e
umask 022
clear
# -------------------------------------------------------------------------- #
# Remove directories and files, leave logs alone
# ------------------------------------------------------------------ #
echo " - - - - -> removing previous version:"
rm -r -f -v /opt/dt.bldr     2>/dev/null
rm -r -f -v /opt/dt.bldr/bin 2>/dev/null
rm -r -f -v /opt/dt.bldr/cfg 2>/dev/null
rm -r -f -v /opt/dt.bldr/log 2>/dev/null
# -------------------------------------------------------------------------- #
# Create directory structure
# ------------------------------------------------------------------ #
echo ""
echo " - - - - -> Creating directories:"
mkdir -v -m 755 /opt/dt.bldr
mkdir -v -m 755 /opt/dt.bldr/bin
mkdir -v -m 755 /opt/dt.bldr/cfg
mkdir -v -m 777 /opt/dt.bldr/log
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
chmod -v 555 /opt/dt.bldr/bin/dt.*.sh
chmod -v 500 /opt/dt.bldr/bin/uninstall.sh
chmod -v 444 /opt/dt.bldr/cfg/dt.bldr.cfg
# -------------------------------------------------------------------------- #
# Done
# ------------------------------------------------------------------ #
echo ""
echo " - - - - -> Done:"
exit 0
# -------------------------------------------------------------------------- #
# End
