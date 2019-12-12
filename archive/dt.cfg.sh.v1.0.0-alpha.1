#!/bin/bash
# -------------------------------------------------------------------------- #
# Author       : J.Dekker / Jade_NL
# Owner        : J.Dekker
# -------------------------------------------------------------------------- #
# Syntax       : dt.cfg.sh <options>
# Options      : -s show configuration file(s)
#                -c check user configuration file
# -------------------------------------------------------------------------- #
# Purpose      : Show configuration files used bu dt.bldr.sh
#              : Make clear which are Default and which are user settings
#              : Check validity of user configuration file
# -------------------------------------------------------------------------- #
# Dependencies : default config file : /opt/dt.bldr/cfg/dt.bldr.cfg
# -------------------------------------------------------------------------- #
# Changes      : oct 30 2019 - First build / outline           1.0.0-alpha.1
# -------------------------------------------------------------------------- #
#set -xv
set -u
umask 026
# -------------------------------------------------------------------------- #
# --- Variables ---
# ------------------------------------------------------------------ #
# script core
scriptVersion="1.0.0-alpha.1"
scriptName="$(basename ${0})"
# script directories
scriptDir="/opt/dt.bldr"
binDir="${scriptDir}/bin"
cfgDir="${scriptDir}/cfg"
# script files
defCfgFile="${cfgDir}/dt.bldr.cfg"
usrCfgFile="$HOME/.config/dt.bldr/dt.bldr.cfg"
# general
doChkFile="0"
doShwFile="0"


# -------------------------------------------------------------------------- #
# --- Functions ---
# ------------------------------------------------------------------ #
# Function : Check configuration
# Syntax   : _doCheck
# ------------------------------------------------------------------ #
function _doCheck ()
{
  :
}

# ------------------------------------------------------------------ #
# Function : Show configuration
# Syntax   : _doShow
# ------------------------------------------------------------------ #
function _doShow ()
{
  awk -v defcfgfile="${defCfgFile}" '
  BEGIN { 
    # set field separator
    FS = "[ =]"
    # read default configuration file and store relevant parts
    while ( ( getline < defcfgfile ) > 0 )
      { gsub("\"","") 
        if ( $1 ~ /Dir/ )     optsDIRS[$1]  = " D "$2 
        if ( $1 ~ /^CMAKE_/ ) optsCMAKE[$1] = " D "$2  
        if ( $1 ~ /USE_/ )    optsUSE[$1]   = " D "$2  
        if ( $1 ~ /BUILD_/ )  optsBUILD[$1] = " D "$2  
        if ( $1 ~ /_BUILD/ )  optsBUILD[$1] = " D "$2  
        if ( $1 ~ /CUSTOM_/ ) optsBUILD[$1] = " D "$2  
        if ( $1 ~ /^dflt/ )   optsDFLT[$1]  = " D "$2  
        if ( $1 ~ /^crs/ )    optsCRS[$1]   = " D "$2 }
  }
  {
    # replace default with available user entries
      { gsub("\"","") }
      { if ( $1 ~ /Dir/ )     optsDIRS[$1]  = " U "$2 }
      { if ( $1 ~ /^CMAKE_/ ) optsCMAKE[$1] = " U "$2 }
      { if ( $1 ~ /USE_/ )    optsUSE[$1]   = " U "$2 }
      { if ( $1 ~ /BUILD_/ )  optsBUILD[$1] = " U "$2 }
      { if ( $1 ~ /_BUILD/ )  optsBUILD[$1] = " U "$2 }
      { if ( $1 ~ /CUSTOM_/ ) optsBUILD[$1] = " U "$2 }
      { if ( $1 ~ /^dflt/ )   optsDFLT[$1]  = " U "$2 }
      { if ( $1 ~ /^crs/ )    optsCRS[$1]   = " U "$2 }
  }
  END {
      # show what has been found
   { print "# ---------------------------------------------------------------------------- #" }
   {  printf "%-25s %5s %s\n", "#  Option", "D/U", "Value" }
   { print "# ---------------------------------------------------------------------------- #" }
   { print "# - directories -" }
   { print "# ----------------------------------------------------------------------- #" }
   for (key in optsDIRS)  { printf "# %-25s %s\n", key, optsDIRS[key] }
   { print "# ----------------------------------------------------------------------- #" }
   { print "# - cmake options -" }
   { print "# ----------------------------------------------------------------------- #" }
   for (key in optsCMAKE) { printf "# %-25s %s\n", key, optsCMAKE[key] }
   { print "# ----------------------------------------------------------------------- #" }
   { print "# - use options -" }
   { print "# ----------------------------------------------------------------------- #" }
   for (key in optsUSE)   { printf "# %-25s %s\n", key, optsUSE[key] }
   { print "# ----------------------------------------------------------------------- #" }
   { print "# - build options -" }
   { print "# ----------------------------------------------------------------------- #" }
   for (key in optsBUILD) { printf "# %-25s %s\n", key, optsBUILD[key] }
   { print "# ----------------------------------------------------------------------- #" }
   { print "# - run options -" }
   { print "# ----------------------------------------------------------------------- #" }
   for (key in optsDFLT)  { printf "# %-25s %s\n", key, optsDFLT[key] }
   { print "# ----------------------------------------------------------------------- #" }
   { print "# - cpu cores -" }
   { print "# ---------------------------------------------------------------------------- #" }
   for (key in optsCRS)   { printf "# %-25s %s\n", key, optsCRS[key] }
   { print "# ---------------------------------------------------------------------------- #" }

  }' "${usrCfgFile}"
}

# -------------------------------------------------------------------------- #
# --- Main ---
# ------------------------------------------------------------------ #
clear
# do not run script as root
#[ "$EUID" -eq 0 ] && echo "Do not run as root user!" && exit 255
# handle options given
while getopts "cs" OPTION
do
  case "${OPTION}" in
    c) doChkFile="1" ;;
    s) doShwFile="1" ;;
  esac
done
# no opts given
[ "$#" -eq "0" ] && doShwFile="1"
# execute options
[ "${doChkFile}" = "1" ] && _doCheck
[ "${doShwFile}" = "1" ] && _doShow
# -------------------------------------------------------------------------- #
# --- Cleanup ---
# ------------------------------------------------------------------ #
exit 0
# -------------------------------------------------------------------------- #
# End
