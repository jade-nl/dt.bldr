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
# Changes      : nov 07 2019  First build / outline              1.0.0-alpha
#              : nov 08 2019  Options processing and help      1.0.0-alpha.1
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
scriptVersion="1.0.0-alpha.1"
scriptName="$(basename ${0})"
# script directories
scriptDir="/opt/dt.bldr"
binDir="${scriptDir}/bin"
cfgDir="${scriptDir}/cfg"
# -> logUserDir : parsed from cfg file
# script files
defCfgFile="${cfgDir}/dt.bldr.cfg"
usrCfgFile="$HOME/.local/cfg/dt.bldr.cfg"
cfgChkr="${binDir}/dt.cfg.sh -c"
# colours
clrRST=$(tput sgr0)    # reset
clrBLK=$(tput setaf 0) # black
clrRED=$(tput setaf 1) # red
clrGRN=$(tput setaf 2) # green
# script misc
lrgDvdr=" ------------------------------------------------------------------ "
# input options
optBuild="0"
optClone="0"
optInstall="0"
optPull="0"
optStop="0"
#sameVers="0"
#smlDvdr=" -------------------------------------------------------------"

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
  echo "   ${clrRED}A fatal error occured.${clrRST}

     Problem : ${errorLocation}
     Error   : ${errorMessage}

   Exiting now.
${lrgDvdr}$(date '+%H:%M:%S') --
"
  exit 255
}

# ------------------------------------------------------------------ #
# Function : Show help and exit
# Syntax   : _shwHelp
# ------------------------------------------------------------------ #
function _shwHelp ()
{
  clear
  cat <<EOF
${lrgDvdr}$(date '+%H:%M:%S') -- 
 Version : ${scriptVersion}
 ------------------------------------------------------------------------------
 Syntax
  : dt.bldr.sh <options>
 ------------------------------------------------------------------------------
 Options
  : -c     Clone files from repository to ${baseGitDir}
  : -p     Pull updates from repository to ${dktbGitDir}
  : -s     Stop processing if installed version and cloned
            or pulled versions are the same.
  : -b     Build darktable (see General below)
  : -i     Install darktable to ${CMAKE_PREFIX_PATH}
  : -h/-?  Show this output
 ------------------------------------------------------------------------------
 Current settings are:

  - General

    Script base directory ....... ${scriptDir} 
    Default Cfg file ............ ${defCfgFile}
    USer Cfg file ............... ${usrCfgFile}
    Script log file ............. ${logUserDir}
    Build logfile ............... ${cmkBldLog}

  - GIT

    Base git directory .......... ${baseGitDir}
    darktable git directory ..... ${dktbGitDir}

  - Build and Install

    Prefix (install) path ....... ${CMAKE_PREFIX_PATH}

    CMAKE_BUILD_TYPE ............ ${CMAKE_BUILD_TYPE}

    CMAKE_C_FLAGS ............... ${CMAKE_FLAGS}
    CMAKE_CXX_FLAGS ............. ${CMAKE_FLAGS}
    CUSTOM_CFLAGS  .............. ${CUSTOM_CFLAGS}

    USE_CAMERA_SUPPORT .......... ${USE_CAMERA_SUPPORT}
    USE_COLORD .................. ${USE_COLORD}
    USE_DARKTABLE_PROFILING ..... ${USE_DARKTABLE_PROFILING}
    USE_FLICKR .................. ${USE_FLICKR}
    USE_GRAPHICSMAGICK .......... ${USE_GRAPHICSMAGICK}
    USE_KWALLET ................. ${USE_KWALLET}
    USE_LENSFUN ................. ${USE_LENSFUN}
    USE_LIBSECRET ............... ${USE_LIBSECRET}
    USE_LUA ..................... ${USE_LUA}
    DONT_USE_INTERNAL_LUA ....... ${DONT_USE_INTERNAL_LUA}
    USE_MAP ..................... ${USE_MAP}
    USE_NLS ..................... ${USE_NLS}
    USE_OPENCL .................. ${USE_OPENCL}
    USE_OPENEXR ................. ${USE_OPENEXR}
    USE_OPENJPEG ................ ${USE_OPENJPEG}
    USE_OPENMP .................. ${USE_OPENMP}
    USE_UNITY ................... ${USE_UNITY}
    USE_WEBP .................... ${USE_WEBP}
    USE_XMLLINT ................. ${USE_XMLLINT}

    BUILD_BATTERY_INDICATOR ..... ${BUILD_BATTERY_INDICATOR}
    BUILD_CMSTEST ............... ${BUILD_CMSTEST}
    BUILD_CURVE_TOOLS ........... ${BUILD_CURVE_TOOLS}
    BUILD_NOISE_TOOLS ........... ${BUILD_NOISE_TOOLS}
    BUILD_PRINT ................. ${BUILD_PRINT}
    BUILD_RS_IDENTIFY ........... ${BUILD_RS_IDENTIFY}
    BUILD_TESTS ................. ${BUILD_TESTS}
    BUILD_USERMANUAL ............ ${BUILD_USERMANUAL}

    BINARY_PACKAGE_BUILD ........ ${BINARY_PACKAGE_BUILD}
    TESTBUILD_OPENCL_PROGRAMS.... ${TESTBUILD_OPENCL_PROGRAMS}

    Use ninja ................... ${ninjaIsUsed}

EOF
exit 0

}






# temp function
function _SHOWINFO ()
{
echo "baseGitDir                 ${baseGitDir}"
echo "dktbGitDir                 ${dktbGitDir}"
echo "logUserDir                 ${logUserDir}"
echo "cmkBldLog                  ${cmkBldLog}"
echo "scrptLog                   ${scrptLog}"
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
echo "ninjaIsUsed   ${ninjaIsUsed}"
echo "cmakeGen      ${cmakeGen}"
echo ""
echo "crsAprch      ${crsAprch}"
echo "makeOpts      ${makeOpts}"  
echo ""
echo "curVers       ${curVers}"
echo ""
echo "optClone      ${optClone}"
echo "optPull       ${optPull}"
echo "optStop       ${optStop}"
echo "optBuild      ${optBuild}"
echo "optInstall    ${optInstall}"
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
# check config file(s)
${cfgChkr} >/dev/null 2>&1
[ "$?" -eq "0" ] || \
  _errHndlr "Configuration file(s)" \
            "Content not valid.  Run dt.cfg.sh -c for details"
# parse default configuration file
. ${defCfgFile}
# check and parse user defined configuration file
[ -f "${usrCfgFile}" ] && . ${usrCfgFile}
# -------------------------------------------------------------------------- #
# set extra variables based on configurations file
# ------------------------------------------------------------------ #
dktbGitDir="${baseGitDir}/darktable"
cmkBldLog="${logUserDir}/dt.build.log"
scrptLog="${logUserDir}/dt.script.log"
[ "${CMAKE_FLAGS}" = "" ] && CMAKE_FLAGS="[not set]"
# -------------------------------------------------------------------------- #
# cmake vs ninja : use ninja if available and cmake not forced
# ------------------------------------------------------------------ #
echo "$(date '+%H:%M:%S') - Is ninja available" > "${scrptLog}"
if  [ `which ninja` ]
then
  if [ "${dfltCmake}" -eq "0" ]
  then
    echo " - ninja will be used" >> "${scrptLog}"
    ninjaIsUsed="yes" ; cmakeGen="Ninja"
  else
    echo " - cmake forced, ninja will not be used" >> "${scrptLog}"
    ninjaIsUsed="no" ; cmakeGen="Unix Makefiles"
  fi
else
  echo " - cmake will be used" >> "${scrptLog}"
  ninjaIsUsed="no" ; cmakeGen="Unix Makefiles"
fi
# -------------------------------------------------------------------------- #
# --- set amount of cores ---
# ------------------------------------------------------------------ #
nmbrCores="$(printf %.0f $(echo "scale=2 ;$(nproc)/100*${crsAprch}" | bc ))"
makeOpts="-j ${nmbrCores}"
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
echo "$(date '+%H:%M:%S') - Options processing" >> "${scrptLog}"
# any options give
if [ "$#" -eq "0" ]
then
  echo " - no options are found" >> "${scrptLog}"
  # use default from cfg
  optClone="${dfltClone}"
  optPull="${dfltPull}"
  optStop="${dfltStop}"
  optBuild="${dfltBuild}"
  optInstall="${dfltInstall}"
else
  echo " - options are found" >> "${scrptLog}"
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
      h) _shwHelp ;;
     \?) _shwHelp ;;
    esac
  done
fi

_SHOWINFO ; exit # <-- temporary check + exit

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


echo -e "${lrgDvdr}$(date '+%H:%M:%S') -- \n\n"
exit 0
# -------------------------------------------------------------------------- #
# End
