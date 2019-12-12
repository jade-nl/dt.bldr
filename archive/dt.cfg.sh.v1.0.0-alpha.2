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
# Changes      : oct 28 2019 - First build                       1.0.0-alpha
#              : oct 31 2019 - Import data                     1.0.0-alpha.1
#              : nov 02 2019 - Show data                       1.0.0-alpha.2
# -------------------------------------------------------------------------- #
#set -xv
set -u
umask 026
# -------------------------------------------------------------------------- #
# --- Variables ---
# ------------------------------------------------------------------ #
# script core
scriptVersion="1.0.0-alpha.2"
scriptName="$(basename ${0})"
# script directories
scriptDir="/opt/dt.bldr"
binDir="${scriptDir}/bin"
cfgDir="${scriptDir}/cfg"
# script files
defCfgFile="${cfgDir}/dt.bldr.cfg"
usrCfgFile="$HOME/.config/dt.bldr/dt.bldr.cfg"
# arrays
declare -A optsDIRS
declare -A optsCMAKE
declare -A optsUSE
declare -A optsBUILD
declare -A optsDFLT
declare -A optsCRS
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
  
  echo "# -------------------------------------------------- directories --- #"
  for key in "${!optsDIRS[@]}"; do
      printf "#  %-28s%-5s%s\n" ${key} ${optsDIRS[$key]}
  done | sort
  
  echo "# ------------------------------------------------ cmake options --- #"
  for key in "${!optsCMAKE[@]}"; do
      printf "#  %-28s%-5s%s\n" ${key} ${optsCMAKE[$key]}
  done | sort
  
  echo "# -------------------------------------------------- use options --- #"
  for key in "${!optsUSE[@]}"; do
      printf "#  %-28s%-5s%s\n" ${key} ${optsUSE[$key]}
  done | sort
  
  echo "# ------------------------------------------------ build options --- #"
  for key in "${!optsBUILD[@]}"; do
      printf "#  %-28s%-5s%s\n" ${key} ${optsBUILD[$key]}
  done | sort
  
  echo "# ------------------------------------------------- run defaults --- #"
  for key in "${!optsDFLT[@]}"; do
      printf "#  %-28s%-5s%s\n" ${key} ${optsDFLT[$key]}
  done | sort
  
  echo "# -------------------------------------------------- cpu options --- #"
  for key in "${!optsCRS[@]}"; do
      printf "#  %-28s%-5s%s\n" ${key} ${optsCRS[$key]}
  done | sort
  
  echo "# ------------------------------------------------------------------ #"
}

# -------------------------------------------------------------------------- #
# --- Functions ---
# ------------------------------------------------------------------ #
# Function : Show error and exit
# Syntax   : _errHndlr
# ------------------------------------------------------------------ #
function _errHndlr ()
{
  # legible
  errorLocation="$1"
  errorMessage="$2"
  # show error
  echo "
  A fatal error occured.

    Script   : ${scriptName} (${scriptVersion})
    Function : ${errorLocation}
    Error    : ${errorMessage}

    For possible details :  ${cmkBldLog}

  Exiting now.
"
  exit 128
}

# -------------------------------------------------------------------------- #
# --- Main ---
# ------------------------------------------------------------------ #
clear
# some basic checks
[ "$EUID" -eq 0 ]      && _errHndlr "Basic checks" "Do not run as root user."
[ ! -f ${defCfgFile} ] && _errHndlr "Basic checks" "${defCfgFile} does not exist."
# -------------------------------------------------------- #
# parse both cfg files
while IFS=$'\n' read -r OPTVAL
do
  # process input line
  OPTVAL=${OPTVAL//\"/} # strip double quotes
  cfgOPT=${OPTVAL%=*}   # all before =
  cfgVal=${OPTVAL#*=}   # all after =
  # store opt + val pair in appropriate array
  [[ ${cfgOPT} =~ Dir ]]         && optsDIRS[${cfgOPT}]=${cfgVal}
  [[ ${cfgOPT} =~ ^CMAKE_ ]]     && optsCMAKE[${cfgOPT}]=${cfgVal}
  [[ ${cfgOPT} =~ ^USE_ ]]       && optsUSE[${cfgOPT}]=${cfgVal}
  [[ ${cfgOPT} =~ ^DONT_ ]]      && optsUSE[${cfgOPT}]=${cfgVal}
  [[ ${cfgOPT} =~ ^BUILD_ ]]     && optsBUILD[${cfgOPT}]=${cfgVal}
  [[ ${cfgOPT} =~ ^CUSTOM ]]     && optsBUILD[${cfgOPT}]=${cfgVal}
  [[ ${cfgOPT} =~ ^BINARY ]]     && optsBUILD[${cfgOPT}]=${cfgVal}
  [[ ${cfgOPT} =~ ^TESTBUILD_ ]] && optsBUILD[${cfgOPT}]=${cfgVal}
  [[ ${cfgOPT} =~ ^dflt ]]       && optsDFLT[${cfgOPT}]=${cfgVal}
  [[ ${cfgOPT} =~ ^crs ]]        && optsCRS[${cfgOPT}]=${cfgVal}
done < <(cat ${defCfgFile} ${usrCfgFile} 2>/dev/null)

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
