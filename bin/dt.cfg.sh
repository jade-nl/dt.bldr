#!/bin/bash
# -------------------------------------------------------------------------- #
# Author       : J.Dekker / Jade_NL
# -------------------------------------------------------------------------- #
# Syntax       : dt.cfg.sh <options>
# Options      : -s show configuration file(s)
#                -c check user configuration file
# -------------------------------------------------------------------------- #
# Purpose      : 1) Show configuration files used by dt.bldr.sh
#              : 2) Check validity of configuration file(s)
# -------------------------------------------------------------------------- #
# Dependencies : default config file : /opt/dt.bldr/cfg/dt.bldr.cfg
# -------------------------------------------------------------------------- #
# Changes      : oct 28 2019 First build                         1.0.0-alpha
#              : nov 05 2019 Check data / set exit status         1.0.0-beta
#              : dec 04 2019 First relese candidate               1.0.0-rc.0
#              : dec 10 2019 Relese Version 1.0.0                      1.0.0
#              : dec 11 2019 Removed leftover stuff                    1.0.1
#              : dec 24 2019 Fixed a typo                              1.0.2
#              : jan 02 2020 Incorporated extra CMAKE_INSTALL_iX vars  1.1.0
#                            Changed CMAKE_INSTALL checks
#                            Added installing from local tarbal
#              : jan 03 2020 Local vs remote overhaul                  1.1.1
#              : jan 05 2020 Code cleanup                              1.2.0
# -------------------------------------------------------------------------- #
# Copright     : GNU General Public License v3.0
#              : https://www.gnu.org/licenses/gpl-3.0.txt
# -------------------------------------------------------------------------- #
#set -xv
#set -u
umask 026
# -------------------------------------------------------------------------- #
# --- Variables ---
# ------------------------------------------------------------------ #
# script core
scriptVersion="1.2.0"
scriptName="$(basename ${0})"
# script directories
scriptDir="/opt/dt.bldr"
binDir="${scriptDir}/bin"
cfgDir="${scriptDir}/cfg"
# script files
defCfgFile="${cfgDir}/dt.bldr.cfg"
usrCfgFile="$HOME/.local/cfg/dt.bldr.cfg"
# arrays
declare -A optsSRC
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
  echo " ------------------------------------------------------------------- source --- "
  STATUS="${clrGRN}OK${clrRST}"
  # remote, local or invalid
  if [ -z "${optsSRC[useSRC]}" ]
  then
    # empty
    STATUS="${clrRED}ERROR  - cannot be empty -${clrRST}" ; exitSTTS="254"
    printf "  %-28s%-18s%s\n" "useSRC" "${STATUS}" "${optsSRC[useSRC]}"
  elif [[ ! "${optsSRC[useSRC]}" =~ ^(git|local) ]]
  then
    # invalid entry
    STATUS="${clrRED}ERROR  ${clrRST}invalid entry: " ; exitSTTS="253"
    printf "  %-28s%-18s%s\n" "useSRC" "${STATUS}" "${optsSRC[useSRC]}"
  elif [[ "${optsSRC[useSRC]}" == "git" ]]
  then
    # -------------------------------------------------------------- #
    # remote -> git
    printf "  %-28s%-18s%s\n" "useSRC" "${STATUS}" "${optsSRC[useSRC]}"
    if [ -z "${optsSRC[gitSRC]}" ]
    then
      STATUS="${clrRED}ERROR  - cannot be empty -${clrRST}" ; exitSTTS="252"
    elif [[ ! "${optsSRC[gitSRC]}" =~ ^(git@github.com:|git://github.com/|https://github.com/) ]]
    then
      STATUS="${clrRED}ERROR${clrRST}" ; exitSTTS="251"
    fi
    printf "  %-28s%-18s%s\n" "gitSRC" "${STATUS}" "${optsSRC[gitSRC]}"
    [ -z "${optsDRS[baseGitSRCDir]}" ] && \
      { STATUS="${clrRED}ERROR  - cannot be empty -${clrRST}" ; exitSTTS="251" ; }
    printf "  %-28s%-18s%s\n" "baseGitSRCDir" "${STATUS}" "${optsDRS[baseGitSRCDir]}"
  else
    # -------------------------------------------------------------- #
    # local -> tarball
    printf "  %-28s%-18s%s\n" "useSRC" "${STATUS}" "${optsSRC[useSRC]}"
    if [ -z "${optsSRC[lclSRC]}" ]
    then
      STATUS="${clrRED}ERROR  - cannot be empty -${clrRST}" ; exitSTTS="249"
    elif [[ ! "${optsSRC[lclSRC]}" =~ ^darktable-[0-9\.]*.tar.xz$ ]]
    then
      STATUS="${clrRED}ERROR${clrRST}" ; exitSTTS="248"
    fi
    printf "  %-28s%-18s%s\n" "lclSRC" "${STATUS}" "${optsSRC[lclSRC]}"
    [ -z "${optsDRS[baseLclSRCDir]}" ] && \
      { STATUS="${clrRED}ERROR  - cannot be empty -${clrRST}" ; exitSTTS="247" ; }
    printf "  %-28s%-18s%s\n" "baseLclSRCDir" "${STATUS}" "${optsDRS[baseLclSRCDir]}"
  fi
    # -------------------------------------------------------------- #
    # compiler to use
    if [[ "${optsSRC[compSRC]}" == "clang" || "${optsSRC[compSRC]}" == "gcc" ]]
    then
      printf "  %-28s%-18s%s\n" "compSRC" "${STATUS}" "${optsSRC[compSRC]}"
    else
      { STATUS="${clrRED}ERROR  - only gcc or clang are allowed -${clrRST}" ; exitSTTS="246" ; }
      printf "  %-28s%-18s%s\n" "compSRC" "${STATUS}" "${optsDRS[compSRC]}"
    fi
    # -------------------------------------------------------------- #
    # name of directory to clone into
    if [ ! -z "${optsSRC[gitNameSRC]}" ]
    then
      printf "  %-28s%-18s%s\n" "gitNameSRC" "${STATUS}" "${optsSRC[gitNameSRC]}"
    else
      { STATUS="${clrRED}ERROR  - cannot be empty -${clrRST}" ; exitSTTS="245" ; }
      printf "  %-28s%-18s%s\n" "gitNameSRC" "${STATUS}" "${optsDRS[gitNameSRC]}"
    fi
    # -------------------------------------------------------------- #
    # branch to clone
    STATUS="${clrGRN}OK${clrRST}"
    if [ -z "${optsSRC[gitBrnchSRC]}" ]
    then
      printf "  %-28s%-18s%s\n" "gitBrnchSRC" "${STATUS}" "(master)"
    else
      printf "  %-28s%-18s%s\n" "gitBrnchSRC" "${STATUS}" "${optsSRC[gitBrnchSRC]}"
    fi
  # if error is encounterd, stop now.
  if [ "${exitSTTS}" -ne "0" ]
  then
  echo -e "\n\n          ${clrRED}--- Fix errors before continuing ---${clrRST}\n\n"
    exit "${exitSTTS}"
  fi
  # ---------------------------------------------------------------- #
  # directories
  echo " -------------------------------------------------------------- directories --- "
  for ITEM in logDir
  do
    STATUS="${clrGRN}OK${clrRST}"
    eval [ ! -d "${optsDRS[$ITEM]}" ] && \
      { STATUS="${clrRED}ERROR${clrRST}" ; exitSTTS="245" ; }
    printf "  %-28s%-18s%s\n" "${ITEM}" "${STATUS}" "${optsDRS[$ITEM]}"
  done

  # cmake install path options
  echo " ------------------------------------------------------------ cmake options --- "
  # CMAKE_PREFIX_PATH
  STATUS="${clrGRN}OK${clrRST}"
  [ -z "${optsCMK[CMAKE_PREFIX_PATH]}" ] && \
    { STATUS="${clrRED}ERROR  - cannot be empty -${clrRST}" ; exitSTTS="239" ; }
  printf "  %-28s%-18s%s\n" "CMAKE_PREFIX_PATH" "${STATUS}" "${optsCMK[CMAKE_PREFIX_PATH]}"
  # CMAKE_INSTALL_BINDIR
  STATUS="${clrGRN}OK${clrRST}"
  [ -z "${optsCMK[CMAKE_INSTALL_BINDIR]}" ] && \
    { STATUS="${clrRED}ERROR  - cannot be empty -${clrRST}" ; exitSTTS="238" ; }
  printf "  %-28s%-18s%s\n" "CMAKE_INSTALL_BINDIR" "${STATUS}" "${optsCMK[CMAKE_INSTALL_BINDIR]}"
  # CMAKE_INSTALL_LIBDIR
  STATUS="${clrGRN}OK${clrRST}"
  [ -z "${optsCMK[CMAKE_INSTALL_LIBDIR]}" ] && \
    { STATUS="${clrRED}ERROR  - cannot be empty -${clrRST}" ; exitSTTS="237" ; }
  printf "  %-28s%-18s%s\n" "CMAKE_INSTALL_LIBDIR" "${STATUS}" "${optsCMK[CMAKE_INSTALL_LIBDIR]}"
  # CMAKE_INSTALL_DATAROOTDIR
  STATUS="${clrGRN}OK${clrRST}"
  [ -z "${optsCMK[CMAKE_INSTALL_DATAROOTDIR]}" ] && \
    { STATUS="${clrRED}ERROR  - cannot be empty -${clrRST}" ; exitSTTS="236" ; }
  printf "  %-28s%-18s%s\n" "CMAKE_INSTALL_DATAROOTDIR" "${STATUS}" "${optsCMK[CMAKE_INSTALL_DATAROOTDIR]}"
  # CMAKE_INSTALL_DOCDIR
  STATUS="${clrGRN}OK${clrRST}"
  [ -z "${optsCMK[CMAKE_INSTALL_DOCDIR]}" ] && \
    { STATUS="${clrRED}ERROR  - cannot be empty -${clrRST}" ; exitSTTS="235" ; }
  printf "  %-28s%-18s%s\n" "CMAKE_INSTALL_DOCDIR" "${STATUS}" "${optsCMK[CMAKE_INSTALL_DOCDIR]}"
  # CMAKE_INSTALL_LOCALEDIR
  STATUS="${clrGRN}OK${clrRST}"
  [ -z "${optsCMK[CMAKE_INSTALL_LOCALEDIR]}" ] && \
    { STATUS="${clrRED}ERROR  - cannot be empty -${clrRST}" ; exitSTTS="234" ; }
  printf "  %-28s%-18s%s\n" "CMAKE_INSTALL_LOCALEDIR" "${STATUS}" "${optsCMK[CMAKE_INSTALL_LOCALEDIR]}"
  # CMAKE_INSTALL_MANDIR
  STATUS="${clrGRN}OK${clrRST}"
  [ -z "${optsCMK[CMAKE_INSTALL_MANDIR]}" ] && \
    { STATUS="${clrRED}ERROR  - cannot be empty -${clrRST}" ; exitSTTS="233" ; }
  printf "  %-28s%-18s%s\n" "CMAKE_INSTALL_MANDIR" "${STATUS}" "${optsCMK[CMAKE_INSTALL_MANDIR]}"
  # CMAKE_BUILD_TYPE
  STATUS="${clrGRN}OK${clrRST}"
  [[ "${optsCMK[CMAKE_BUILD_TYPE]}" =~ ^(Debug|Release|RelWithDebInfo)$ ]] || \
    { STATUS="${clrRED}ERROR${clrRST}" ; exitSTTS="232" ; }
  printf "  %-28s%-18s%s\n" "CMAKE_BUILD_TYPE" "${STATUS}" "${optsCMK[CMAKE_BUILD_TYPE]}"

  # cmake use options
  echo " -------------------------------------------------------------- use options --- "
  for key in "${!optsUSE[@]}"
  do
    STATUS="${clrGRN}OK${clrRST}"
    ITEM="${optsUSE[$key]}"
    [[ "${ITEM,,}" =~ ^on$ ]] ||  [[ "${ITEM,,}" =~ ^off$ ]] || \
      { STATUS="${clrRED}ERROR${clrRST}" ; exitSTTS="230" ; }
    printf "  %-28s%-18s%s\n" ${key} ${STATUS} ${optsUSE[$key]}
  done

  # cmake build options
  echo " ------------------------------------------------------------ build options --- "
  for key in "${!optsBLD[@]}"
  do
    STATUS="${clrGRN}OK${clrRST}"
    ITEM="${optsBLD[$key]}"
    [[ "${ITEM,,}" =~ ^on$ ]] ||  [[ "${ITEM,,}" =~ ^off$ ]] || \
      { STATUS="${clrRED}ERROR${clrRST}" ; exitSTTS="220" ; }
    printf "  %-28s%-18s%s\n" ${key} ${STATUS} ${optsBLD[$key]}
  done

  # run options  
  echo " ------------------------------------------------------------- run defaults --- "
  for key in "${!optsDFT[@]}"
  do
    STATUS="${clrGRN}OK${clrRST}"
    ITEM="${optsDFT[$key]}"
    [[ "${ITEM,,}" =~ ^[01]$ ]] || \
      { STATUS="${clrRED}ERROR${clrRST}" ; exitSTTS="210" ; }
    printf "  %-28s%-18s%s\n" ${key} ${STATUS} ${optsDFT[$key]}
  done

  #  cpu cores usage
  echo " -------------------------------------------------------------- cpu options --- "
  for key in "${!optsCRS[@]}"
  do
    STATUS="${clrGRN}OK${clrRST}"
    ITEM="${optsCRS[$key]}"
    [[ "${ITEM,,}" =~ ^([1-9][0-9]{1}|1[0-9]{2}|200)$ ]] || \
      { STATUS="${clrRED}ERROR${clrRST}" ; exitSTTS="200" ; }
    printf "  %-28s%-18s%s\n" ${key} ${STATUS} ${optsCRS[$key]}
  done
  echo " -------------------------------------------------------------------- ${clrBLU}$(date '+%H:%M')${clrRST} --- "
}

function _doShow ()
{
  echo " ---------------------------------------------------------------------- git --- "
  for key in "${!optsSRC[@]}"; do
      printf "  %-28s%-5s%s\n" ${key} ${optsSRC[$key]}
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
  
  echo " ------------------------------------------------------- system information --- "
  echo "  bash    $(bash --version | head -1)"
  echo "  git     $(git --version)"
  echo "  gcc     $(gcc --version | head -1)"
  echo "  cmake   $(cmake --version | head -1)"
  echo "  make    $(make --version | head -1)"
  echo "  ninja   $(ninja --version)"
  echo "  ccache  $(ccache --version | head -1)"
  echo "  $( uname -rv )"

  echo " ------------------------------------------------------ darktable cms tests --- "
  [ $(which darktable-cmstest) ] && darktable-cmstest | awk '{ print "  " $0 }'

  echo " ------------------------------------------------------- darktable cl tests --- "
  [ $(which darktable-cltest) ] && darktable-cltest | awk '{ print "  " $0 }'

  echo " -------------------------------------------------------------------- ${clrBLU}$(date '+%H:%M')${clrRST} --- "
}

# ------------------------------------------------------------------ #
# Function : Show error and exit
# Syntax   : _errHndlr
# ------------------------------------------------------------------ #
function _errHndlr ()
{
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

# -------------------------------------------------------- #
# some basic checks
[ "$EUID" -eq 0 ]      && _errHndlr "Basic checks" "Do not run as root user."
[ ! -f ${defCfgFile} ] && _errHndlr "Basic checks" "${defCfgFile} does not exist."
# -------------------------------------------------------- #
# congig files present
echo "  default configuration file  ${clrGRN}present${clrRST}"
if [ -s  ${usrCfgFile} ]
then
  echo "  user configuration file     ${clrGRN}present${clrRST}"
else
  echo "  user configuration file     ${clrBLU}! not present !${clrRST}"
fi
# -------------------------------------------------------- #
# parse cfg files
while IFS=$'\n' read -r OPTVAL
do
  # select appropriate lines
  [[ "${OPTVAL}" =~ ^#.*$ ]] && continue
  # select appropriate parts
  OPTVAL=${OPTVAL%% *}  # remove comment/empty part on same line
  OPTVAL=${OPTVAL//\"/} # strip double quotes
  cfgOPT=${OPTVAL%=*}   # select all before = (inclusive)
  cfgVal=${OPTVAL#*=}   # select all after = (inclusive)
  # store opt + val pair in appropriate arrays
  [[ ${cfgOPT} =~ SRC ]]         && optsSRC[${cfgOPT}]=${cfgVal}
  [[ ${cfgOPT} =~ SRCDir ]]         && optsDRS[${cfgOPT}]=${cfgVal}
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
# no opts given -> use -c (show configuration)
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
