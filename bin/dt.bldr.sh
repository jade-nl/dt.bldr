#!/bin/bash
# -------------------------------------------------------------------------- #
# Author       : Jacques Dekker / Jade_NL
# -------------------------------------------------------------------------- #
# Syntax       : dt.bldr.sh <options>
# Options      : -c          Clone files from git repository
#              : -p          Pull update from git repository
#              : -s          Stop if versions are the same
#              : -b          Build darktable
#              : -i          Install darktable
#              : -h/-?       Show help
# -------------------------------------------------------------------------- #
# Purpose      : 1) Clone or pull darktable from git repository
#              : 2) Build darktable
#              : 3) Build darktable
# -------------------------------------------------------------------------- #
# Dependencies : /opt/dt.bldr/cfg/dt.bldr.cfg  (default cfg file)
#              : /opt/dt.bldr/bin/dt.cfg.sh    (cfg file checker)
#              : git Version Control Systems needs to be installed
#              : sudo, if used for system wide installation
# -------------------------------------------------------------------------- #
# Changes      : nov 07 2019 - First build / outline             1.0.0-alpha
# -------------------------------------------------------------------------- #
# Copright     : Jacques Dekker
#              : CC BY-NC-SA 4.0
#              : https://creativecommons.org/licenses/by-nc-sa/4.0/
# -------------------------------------------------------------------------- #
#set -x
set -u
umask 026
# -------------------------------------------------------------------------- #
# --- Variables ---
# ------------------------------------------------------------------ #
# Script core related
scriptVersion="1.0.0-alpha"
scriptName="$(basename ${0})"
# script directories
scriptDir="/opt/dt.bldr"
binDir="${scriptDir}/bin"
cfgDir="${scriptDir}/cfg"
# script files
defCfgFile="${cfgDir}/dt.bldr.cfg"
usrCfgFile="$HOME/.config/dt.bldr/dt.bldr.cfg"
# colours
clrRST=$(tput sgr0)    # reset
clrBLK=$(tput setaf 0) # black
clrRED=$(tput setaf 1) # red
clrGRN=$(tput setaf 2) # green

## script misc
#cfgIsValid="1"
#ccacheIsUsed="no"
#sameVers="0"
#lrgDvdr=" ------------------------------------------------------------------ "
#smlDvdr=" -------------------------------------------------------------"
## input options
#argFetch="0"
#optBuild="0"
#optClone="0"
#optFetch="0"
#optInstall="0"
#optPull="0"
#optRemove="0"
#optStop="0"

# -------------------------------------------------------------------------- #
# --- Functions ---
# ------------------------------------------------------------------ #
# Function : Clone darktable
# Syntax   : 
# ------------------------------------------------------------------ #


# ------------------------------------------------------------------ #
# Function : Pull darktable
# Syntax   : 
# ------------------------------------------------------------------ #


# ------------------------------------------------------------------ #
# Function : Build darktable
# Syntax   : 
# ------------------------------------------------------------------ #


# ------------------------------------------------------------------ #
# Function : Install darktable
# Syntax   : 
# ------------------------------------------------------------------ #


# ------------------------------------------------------------------ #
# Function : Show progress
# Syntax   : _shwPrgrs
# ------------------------------------------------------------------ #
function _shwPrgrs ()
{
  spinParts="-\|/" ; cntr="0" ; ccld="0"
  while kill -0 $prcsPid 2>/dev/null
  do
    cntr=$(( (cntr+1) %4 ))
    printf "\r ${spinParts:$cntr:1} "
    sleep .3 ; ((ccld++))
  done
  wait ${prcsPid}
  if [[ "$?" != "0" || "${ccld}" -le "1" ]]
  then
    printf "\r - - - - - -> ${clrRED}An error occurred${clrRST}\n\n"
    echo   "              Stubbornly refusing to continue."
    echo   ""
    echo   "              Details are in :  ${cmkBldLog}"
    echo   ""
    exit 254
  fi
  printf "\r"
}

# ------------------------------------------------------------------ #
# Function : Show error and exit
# Syntax   : _errHndlr
# ------------------------------------------------------------------ #
function _errHndlr ()
{
  # ------------------
  # log error message.
  errorLocation="$1"
  errorMessage="$2"
  #----------
  # To screen
  echo "
    ${clrRED}A fatal error occured.${clrRST}

      Function : ${errorLocation}
      Error    : ${errorMessage}

    Exiting now.
${lrgDvdr}$(date '+%H:%M:%S') --
"
  exit 255
}








# temp function
function _SHOWINFO ()
{
echo "logUserDir                 ${logUserDir}"
echo "baseGitDir                 ${baseGitDir}"
echo ""
echo "CMAKE_PREFIX_PATH          ${CMAKE_PREFIX_PATH}"
echo "USE_CAMERA_SUPPORT         ${USE_CAMERA_SUPPORT}"
echo "USE_COLORD                 ${USE_COLORD}"
echo "USE_DARKTABLE_PROFILING    ${USE_DARKTABLE_PROFILING}"
echo "USE_FLICKR                 ${USE_FLICKR}"
echo "USE_GRAPHICSMAGICK         ${USE_GRAPHICSMAGICK}"
echo "USE_KWALLET                ${USE_KWALLET}"
echo "USE_LENSFUN                ${USE_LENSFUN}"
echo "USE_LIBSECRET              ${USE_LIBSECRET}"
echo "USE_MAP                    ${USE_MAP}"
echo "USE_NLS                    ${USE_NLS}"
echo "USE_OPENEXR                ${USE_OPENEXR}"
echo "USE_OPENJPEG               ${USE_OPENJPEG}"
echo "USE_OPENMP                 ${USE_OPENMP}"
echo "USE_UNITY                  ${USE_UNITY}"
echo "USE_WEBP                   ${USE_WEBP}"
echo "USE_XMLLINT                ${USE_XMLLINT}"
echo "USE_LUA                    ${USE_LUA}"
echo "DONT_USE_INTERNAL_LUA      ${DONT_USE_INTERNAL_LUA}"
echo "USE_OPENCL                 ${USE_OPENCL}"
echo ""
echo "TESTBUILD_OPENCL_PROGRAMS  ${TESTBUILD_OPENCL_PROGRAMS}"
echo "CUSTOM_CFLAGS              ${CUSTOM_CFLAGS}"
echo "BINARY_PACKAGE_BUILD       ${BINARY_PACKAGE_BUILD}"
echo "BUILD_BATTERY_INDICATOR    ${BUILD_BATTERY_INDICATOR}"
echo "BUILD_CMSTEST              ${BUILD_CMSTEST}"
echo "BUILD_CURVE_TOOLS          ${BUILD_CURVE_TOOLS}"
echo "BUILD_NOISE_TOOLS          ${BUILD_NOISE_TOOLS}"
echo "BUILD_PRINT                ${BUILD_PRINT}"
echo "BUILD_RS_IDENTIFY          ${BUILD_RS_IDENTIFY}"
echo "BUILD_TESTS                ${BUILD_TESTS}"
echo "BUILD_USERMANUAL           ${BUILD_USERMANUAL}"
echo ""
echo "CMAKE_BUILD_TYPE           ${CMAKE_BUILD_TYPE}"
echo "CMAKE_FLAGS                ${CMAKE_FLAGS}"
echo ""
echo "dfltClone     ${dfltClone}"
echo "dfltPull      ${dfltPull}"
echo "dfltStop      ${dfltStop}"
echo "dfltBuild     ${dfltBuild}"
echo "dfltInstall   ${dfltInstall}"
echo "dfltCmake     ${dfltCmake}"
echo ""
echo "crsAprch      ${crsAprch}"
echo "makeOpts      ${makeOpts}"
echo ""
echo "optClone      ${optClone}"
echo "optPull       ${optPull}"
echo "optStop       ${optStop}"
echo "optBuild      ${optBuild}"
echo "optInstall    ${optInstall}"
echo "optFetch      ${optFetch}"
echo "argFetch      ${argFetch}"
}
# -------------------------------------------------------------------------- #
# --- Main ---
# -------------------------------------------------------------------------- #
clear
echo ""
echo "${lrgDvdr}$(date '+%H:%M:%S') -- "
# -------------------------------------------------------------------------- #
# parse configuration file
# ------------------------------------------------------------------ #
echo "$(date '+%H:%M:%S') - Setting up environment." > "${logScriptFile}"
# parse sensible default configuration file
echo " - parsing sensible defaults" >> "${logScriptFile}"
. ${cfgScriptFile}
# check and parse user defined configuration file
if [ -f "${HOME}/.config/dt.bldr/dt.bldr.cfg" ]
then
  # parse user defined
  . $HOME/.config/dt.bldr/dt.bldr.cfg
  # perform basic checks checks
  lineCnt="$(egrep -cv "^#" $HOME/.config/dt.bldr/dt.bldr.cfg)"
  [ "${lineCnt}" -eq "42" ] || cfgIsValid="0"
  # check and possibly create base directories
  # log directory
  if [ ! -d "${logUserDir}" ]
  then
    # create logUserDir?
    read -p "${logUserDir} not found!  Create? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ "${REPLY}" =~ ^[Yy]$ ]]
    then
      mkdir -m 750 "${logUserDir}"
      cfgIsValid="0"
    fi  
  fi
  # git directory
  if [ ! -d "${baseGitDir}" ]
  then
    # create baseGitDir?
    read -p "${logUserDir} not found!  Create? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ "${REPLY}" =~ ^[Yy]$ ]]
    then
      mkdir -m 750 "${logUserDir}"
      cfgIsValid="0"
    fi
  fi
  # are we good?
  if [ "${cfgIsValid}" -eq "1" ]
  then 
    # valid user defined configuration file found
    cfgScriptFile="${HOME}/.config/dt.bldr/dt.bldr.cfg"
    echo " - parsed user defined" >> "${logScriptFile}"
  else
    # no valid user defined configuration file found
    echo " - user defined cfg file isn't valid" >> "${logScriptFile}"
    echo "  User defined configuration file is invalid!"
    echo "  Using sensible and safe defaults instead."
    # parse to overwrite possible invalid user file entries
    . ${cfgScriptFile}
  fi
else
  # no user defined configuration file found
  echo " - no user defined cfg file found" >> "${logScriptFile}"
  echo "  No personalized configuration file found."
  echo "  Using sensible and safe defaults instead."
fi
# -------------------------------------------------------------------------- #
# set extra variables based on configurations file
# ------------------------------------------------------------------ #
dktbGitDir="${baseGitDir}/darktable"
cmkBldLog="${logUserDir}/dt.bldr.log"
# -------------------------------------------------------------------------- #
# cmake vs ninja : use ninja if available and cmake not forced
# ------------------------------------------------------------------ #
echo "$(date '+%H:%M:%S') - Is ninja available" >> "${logScriptFile}"
if  [ `which ninja` ]
then
  if [ "${dfltCmake}" -eq "0" ]
  then
    echo " - ninja will be used" >> "${logScriptFile}"
    cmakeGen="Ninja"
    ninjaIsUsed="yes"
  else
    echo " - cmake is forced, ninja will not be used" >> "${logScriptFile}"
    cmakeGen="Unix Makefiles"
    ninjaIsUsed="no"
    echo "  cmake is forced, not using ninja."
  fi
else
  echo " - cmake will be used" >> "${logScriptFile}"
  cmakeGen="Unix Makefiles"
  ninjaIsUsed="no"
fi
# -------------------------------------------------------------------------- #
# --- set amount of cores ---
# ------------------------------------------------------------------ #
numberCores="$(printf %.0f $(echo "scale=2 ;$(nproc)/100*${crsAprch}" | bc ))"
makeOpts="-j ${numberCores}"   # use all but one cores
# -------------------------------------------------------------------------- #
# get/set dt version information
# ------------------------------------------------------------------ #
newVers=""
curVers="n/a"
# set current darktable version if available
[ -e ${CMAKE_PREFIX_PATH}/bin/darktable ] && \
  [ -x ${CMAKE_PREFIX_PATH}/bin/darktable ] && \
    curVers="$(${CMAKE_PREFIX_PATH}/bin/darktable --version | \
    sed 's/[~+]/-/g' | awk 'NR==1 { print $4 }')"
# -------------------------------------------------------------------------- #
# process options, if any
# ------------------------------------------------------------------ #
_SHOWINFO
echo "$(date '+%H:%M:%S') - Options processing" >> "${logScriptFile}"
# any options give
if [ "${#}" -ne "0" ]
then
  echo " - options are found" >> "${logScriptFile}"
  # yes -> reset possibles to 0
  optClone="0"
  optPull="0"
  optStop="0"
  optBuild="0"
  optInstall="0"
  # process options
  while getopts ":cpsbih" OPTION
  do
    case "${OPTION}" in
      c) optClone="1" ;;
      p) optClone="0"     # p beats c if both are set
         optPull="1" ;;
      s) optStop="1" ;;
      b) optBuild="1" ;;
      i) optInstall="1" ;;
      h) echo "Do help" ;;
     \?) echo "Do help" ;;
      :) echo "Error: -${OPTARG} requires an argument."
         exit 128 ;;
    esac
  done
else
  echo " - no options are found" >> "${logScriptFile}"
fi
_SHOWINFO # <-- temporary check
# -------------------------------------------------------- #
# lets go already
[ "${optClone}"   = "1" ] && _gitClone
[ "${optPull}"    = "1" ] && _gitPull
# -------------------------------------------------------- #
# skip build/install if -s is set and versions are the same
if [[ "${optStop}" == "1" && "${sameVers}" == "1" ]]
then
  echo "$(date '+%H:%M:%S')   Versions are the same: Skipping Build/Install"
else
  [ "${optBuild}"   = "1" ] && _dtBuild
  [ "${optInstall}" = "1" ] && _dtInstall
fi
[ "${optFetch}"   = "1" ] && _dtFetch "${argFetch}"

# -------------------------------------------------------------------------- #
# End
