#!/bin/bash
# -------------------------------------------------------------------------- #
# Author       : J.Dekker / Jade_NL
# -------------------------------------------------------------------------- #
# Syntax       : dt.cfg.sh <options>
# Options      : -s show configuration file(s)
#                -c check user configuration file
# -------------------------------------------------------------------------- #
# Purpose      : 1) Show configuration files used bu dt.bldr.sh
#              : 2) Check validity of configuration file(s)
# -------------------------------------------------------------------------- #
# Dependencies : default config file : /opt/dt.bldr/cfg/dt.bldr.cfg
# -------------------------------------------------------------------------- #
# Changes      : oct 28 2019 First build                         1.0.0-alpha
#              : oct 31 2019 Import data                       1.0.0-alpha.1
#              : nov 02 2019 Show data                         1.0.0-alpha.2
#              : nov 05 2019 Check data / set exit status         1.0.0-beta
#              : nov 18 2019 Minor chnages to layout            1.0.0-beta.1
#              : dec 02 2019 added partial git url flexibility  1.0.0-beta.2
#              : dec 03 2019 Changed variable name              1.0.0-beta.3
#              : dec 04 2019 First relese candidate               1.0.0-rc.0
# -------------------------------------------------------------------------- #
# Copright     : GNU General Public License v3.0
#              : https://www.gnu.org/licenses/gpl-3.0.txt
# -------------------------------------------------------------------------- #
#set -xv
set -u
umask 026
# -------------------------------------------------------------------------- #
# --- Variables ---
# ------------------------------------------------------------------ #
# script core
scriptVersion="1.0.0-rc.0"
scriptName="$(basename ${0})"
# script directories
scriptDir="/opt/dt.bldr"
binDir="${scriptDir}/bin"
cfgDir="${scriptDir}/cfg"
# script files
defCfgFile="${cfgDir}/dt.bldr.cfg"
usrCfgFile="$HOME/.local/cfg/dt.bldr.cfg"
# arrays
declare -A optsGIT
declare -A optsDRS
declare -A optsCMK
declare -A optsUSE
declare -A optsBLD
declare -A optsDFT
declare -A optsCRS
# colours
clrRST=$(tput sgr0)    # reset
clrBLK=$(tput setaf 0) # black
clrRED=$(tput setaf 1) # red
clrGRN=$(tput setaf 2) # green
clrBLU=$(tput setaf 4) # blue
# general
doChkFile="0"
doShwFile="0"
exitSTTS="0"
# -------------------------------------------------------------------------- #
# --- Functions ---
# ------------------------------------------------------------------ #
# Function : Check configuration
# Syntax   : _doCheck
# ------------------------------------------------------------------ #
function _doCheck ()
{
  echo " ---------------------------------------------------------------------- git --- "
    STATUS="${clrGRN}OK${clrRST}"
    [[ "${optsGIT[urlGit]}" =~ ^(git@github.com:|git://github.com/|https://github.com/) ]] || \
      { STATUS="${clrRED}ERROR${clrRST}" ; exitSTTS="255" ; }
#    eval [ ! -d "${optsGIT[$ITEM]}" ] && \
#      { STATUS="${clrRED}ERROR${clrRST}" ; exitSTTS="255" ; }
    printf "  %-28s%-18s%s\n" "urlGit" "${STATUS}" "${optsGIT[urlGit]}"
  echo " -------------------------------------------------------------- directories --- "
  for ITEM in baseRepDir logDir
  do
    STATUS="${clrGRN}OK${clrRST}"
    eval [ ! -d "${optsDRS[$ITEM]}" ] && \
      { STATUS="${clrRED}ERROR${clrRST}" ; exitSTTS="255" ; }
    printf "  %-28s%-18s%s\n" "${ITEM}" "${STATUS}" "${optsDRS[$ITEM]}"
  done
  echo " ------------------------------------------------------------ cmake options --- "
  # CMAKE_PREFIX_PATH
  STATUS="${clrGRN}OK${clrRST}"
  eval [ ! -d "${optsCMK[CMAKE_PREFIX_PATH]}" ] && \
    { STATUS="${clrRED}ERROR${clrRST}" ; exitSTTS="254" ; }
  printf "  %-28s%-18s%s\n" "CMAKE_PREFIX_PATH" "${STATUS}" "${optsCMK[CMAKE_PREFIX_PATH]}"
  # CMAKE_BUILD_TYPE="RelWithDebInfo"   -> Debug | Release | RelWithDebInfo
  STATUS="${clrGRN}OK${clrRST}"
  [[ "${optsCMK[CMAKE_BUILD_TYPE]}" =~ ^(Debug|Release|RelWithDebInfo)$ ]] || \
    { STATUS="${clrRED}ERROR${clrRST}" ; exitSTTS="253" ; }
  printf "  %-28s%-18s%s\n" "CMAKE_BUILD_TYPE" "${STATUS}" "${optsCMK[CMAKE_BUILD_TYPE]}"
  # CMAKE_FLAGS not checked
  STATUS="${clrBLK}not checked${clrRST}"
  printf "  %-28s%-18s%s\n" "CMAKE_FLAGS" "${STATUS}" "${optsCMK[CMAKE_FLAGS]}"
  echo " -------------------------------------------------------------- use options --- "
  for key in "${!optsUSE[@]}"
  do
    STATUS="${clrGRN}OK${clrRST}"
    ITEM="${optsUSE[$key]}"
    [[ "${ITEM,,}" =~ ^on$ ]] ||  [[ "${ITEM,,}" =~ ^off$ ]] || \
      { STATUS="${clrRED}ERROR${clrRST}" ; exitSTTS="252" ; }
    printf "  %-28s%-18s%s\n" ${key} ${STATUS} ${optsUSE[$key]}
  done
  
  echo " ------------------------------------------------------------ build options --- "
  for key in "${!optsBLD[@]}"
  do
    STATUS="${clrGRN}OK${clrRST}"
    ITEM="${optsBLD[$key]}"
    [[ "${ITEM,,}" =~ ^on$ ]] ||  [[ "${ITEM,,}" =~ ^off$ ]] || \
      { STATUS="${clrRED}ERROR${clrRST}" ; exitSTTS="251" ; }
    printf "  %-28s%-18s%s\n" ${key} ${STATUS} ${optsBLD[$key]}
  done
  
  echo " ------------------------------------------------------------- run defaults --- "
  for key in "${!optsDFT[@]}"
  do
    STATUS="${clrGRN}OK${clrRST}"
    ITEM="${optsDFT[$key]}"
    [[ "${ITEM,,}" =~ ^[01]$ ]] || \
      { STATUS="${clrRED}ERROR${clrRST}" ; exitSTTS="250" ; }
    printf "  %-28s%-18s%s\n" ${key} ${STATUS} ${optsDFT[$key]}
  done
  
  echo " -------------------------------------------------------------- cpu options --- "
  for key in "${!optsCRS[@]}"
  do
    STATUS="${clrGRN}OK${clrRST}"
    ITEM="${optsCRS[$key]}"
    [[ "${ITEM,,}" =~ ^([1-9][0-9]{1}|1[0-9]{2}|200)$ ]] || \
      { STATUS="${clrRED}ERROR${clrRST}" ; exitSTTS="249" ; }
    printf "  %-28s%-18s%s\n" ${key} ${STATUS} ${optsCRS[$key]}
  done
  echo " -------------------------------------------------------------------- ${clrBLU}$(date '+%H:%M')${clrRST} --- "
}

# ------------------------------------------------------------------ #
# Function : Show configuration
# Syntax   : _doShow
# ------------------------------------------------------------------ #
function _doShow ()
{
  echo " ---------------------------------------------------------------------- git --- "
  for key in "${!optsGIT[@]}"; do
      printf "  %-28s%-5s%s\n" ${key} ${optsGIT[$key]}
  done | sort
  echo " -------------------------------------------------------------- directories --- "
  for key in "${!optsDRS[@]}"; do
      printf "  %-28s%-5s%s\n" ${key} ${optsDRS[$key]}
  done | sort
  echo " ------------------------------------------------------------ cmake options --- "
  for key in "${!optsCMK[@]}"; do
      printf "  %-28s%-5s%s\n" ${key} ${optsCMK[$key]}
  done | sort
  echo " -------------------------------------------------------------- use options --- "
  for key in "${!optsUSE[@]}"; do
      printf "  %-28s%-5s%s\n" ${key} ${optsUSE[$key]}
  done | sort
  echo " ------------------------------------------------------------ build options --- "
  for key in "${!optsBLD[@]}"; do
      printf "  %-28s%-5s%s\n" ${key} ${optsBLD[$key]}
  done | sort
  echo " ------------------------------------------------------------- run defaults --- "
  for key in "${!optsDFT[@]}"; do
      printf "  %-28s%-5s%s\n" ${key} ${optsDFT[$key]}
  done | sort
  echo " -------------------------------------------------------------- cpu options --- "
  for key in "${!optsCRS[@]}"; do
      printf "  %-28s%-5s%s\n" ${key} ${optsCRS[$key]}
  done | sort
  echo " -------------------------------------------------------------------- ${clrBLU}$(date '+%H:%M')${clrRST} --- "
}

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
  ${clrRED}A fatal error occured.${clrRST}

   Script      : ${scriptName} (${scriptVersion})
   Function    : ${errorLocation}
   Description : ${errorMessage}

  Exiting now.

 -------------------------------------------------------------------- ${clrRED}$(date '+%H:%M')${clrRST} ---"
  exit 128
}

# -------------------------------------------------------------------------- #
# --- Main ---
# ------------------------------------------------------------------ #
clear
  echo " -------------------------------------------------------------------- ${clrBLU}$(date '+%H:%M')${clrRST} --- "
# some basic checks
[ "$EUID" -eq 0 ]      && _errHndlr "Basic checks" "Do not run as root user."
[ ! -f ${defCfgFile} ] && _errHndlr "Basic checks" "${defCfgFile} does not exist."
echo "  default configuration file  ${clrGRN}present${clrRST}"
if [ -s  ${usrCfgFile} ]
then
  echo "  user configuration file     ${clrGRN}present${clrRST}"
else
  echo "  user configuration file     ${clrRED}not present${clrRST}"
fi
# -------------------------------------------------------- #
# parse cfg files
while IFS=$'\n' read -r OPTVAL
do
  # process input line
  [[ "${OPTVAL}" =~ ^#.*$ ]] && continue
  OPTVAL=${OPTVAL%% *}  # remove comment/empty part on same line
  OPTVAL=${OPTVAL//\"/} # strip double quotes
  cfgOPT=${OPTVAL%=*}   # select all before = (inclusive)
  cfgVal=${OPTVAL#*=}   # select all after = (inclusive)
  # store opt + val pair in appropriate array
  [[ ${cfgOPT} =~ urlGit ]]      && optsGIT[${cfgOPT}]=${cfgVal}
  [[ ${cfgOPT} =~ Dir ]]         && optsDRS[${cfgOPT}]=${cfgVal}
  [[ ${cfgOPT} =~ ^CMAKE_ ]]     && optsCMK[${cfgOPT}]=${cfgVal}
  [[ ${cfgOPT} =~ ^USE_ ]]       && optsUSE[${cfgOPT}]=${cfgVal}
  [[ ${cfgOPT} =~ ^DONT_ ]]      && optsUSE[${cfgOPT}]=${cfgVal}
  [[ ${cfgOPT} =~ ^BUILD_ ]]     && optsBLD[${cfgOPT}]=${cfgVal}
  [[ ${cfgOPT} =~ ^CUSTOM ]]     && optsBLD[${cfgOPT}]=${cfgVal}
  [[ ${cfgOPT} =~ ^BINARY ]]     && optsBLD[${cfgOPT}]=${cfgVal}
  [[ ${cfgOPT} =~ ^TESTBUILD_ ]] && optsBLD[${cfgOPT}]=${cfgVal}
  [[ ${cfgOPT} =~ ^dflt ]]       && optsDFT[${cfgOPT}]=${cfgVal}
  [[ ${cfgOPT} =~ ^crs ]]        && optsCRS[${cfgOPT}]=${cfgVal}
done < <( cat ${defCfgFile} ${usrCfgFile} 2>/dev/null )

# handle options given
while getopts "cs" OPTION
do
  case "${OPTION}" in
    c) doChkFile="1" ;;
    s) doShwFile="1" ;;
  esac
done
# no opts given -> show configuration
[ "$#" -eq "0" ] && doChkFile="1"
# execute options
[ "${doChkFile}" = "1" ] && _doCheck
[ "${doShwFile}" = "1" ] && _doShow
# -------------------------------------------------------------------------- #
# --- Cleanup ---
# ------------------------------------------------------------------ #
exit ${exitSTTS}
# -------------------------------------------------------------------------- #
# End
