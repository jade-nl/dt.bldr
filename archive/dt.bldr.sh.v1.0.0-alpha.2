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
#              : nov 10 2019  Options processing and help      1.0.0-alpha.1
#              : nov 18 2019  Start setting up main functions  1.0.0-alpha.2
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
scriptVersion="1.0.0-alpha.2"
scriptName="$(basename ${0})"
# script directories
scriptDir="/opt/dt.bldr"
binDir="${scriptDir}/bin"
cfgDir="${scriptDir}/cfg"
# -> logDir : parsed from cfg file
# script files
defCfgFile="${cfgDir}/dt.bldr.cfg"
usrCfgFile="$HOME/.local/cfg/dt.bldr.cfg"
cfgChkr="${binDir}/dt.cfg.sh -c"
# colours
clrRST=$(tput sgr0)    # reset
clrBLK=$(tput setaf 0) # black
clrRED=$(tput setaf 1) # red
clrGRN=$(tput setaf 2) # green
clrBLU=$(tput setaf 4) # blue
# script misc
lrgDvdr=" ------------------------------------------------------------------ "
instMthd="LOC"
# input options
optBuild="0"
optClone="0"
optInstall="0"
optPull="0"
optStop="0"
sameVrsn=""

# -------------------------------------------------------------------------- #
# --- Functions ---
# ------------------------------------------------------------------ #
# Function : Clone darktable
# Purpose  : 1) Clone darktable remote repository into local directory
#            2) Initialize and update submodule (rawspeed)
# Syntax   : _gitDtClone
# ------------------------------------------------------------------ #
function _gitDtClone ()
{
  echo "${lrgDvdr}${clrBLU}$(date '+%H:%M:%S')${clrRST} -- "
  # remove current files/dirs first
  [ -d ${dtGitDir} ] && find ${dtGitDir} -mindepth 1 -delete
  # clone dt
  cd ${baseGitDir}
  git clone git://github.com/darktable-org/darktable.git >/dev/null  2>&1 &
  prcssPid="$!" ; txtStrng="clone - cloning into darktable"
  _shwPrgrs
  # initialize rawspeed
  printf "\r  clone - initializing and updating rawspeed .. "
  cd ${dtGitDir}
  git submodule init >/dev/null 2>&1 || _errHndlr "_gitDtClone" "submodule init"
  # update rawspeed
  git submodule update >/dev/null 2>&1 || _errHndlr "_gitDtClone" "submodule update"
  printf "\r  clone - initializing and updating rawspeed ${clrGRN}OK${clrRST}\n"
  # version info
  vrsnInfo="cloned version          :"
  _getDtVrsn
}

# ------------------------------------------------------------------ #
# Function : Pull darktable
# Purpose  : 1) Incorporate changes from remote repository into local branch
#            2) Update submodules (rawspeed)
# Syntax   : _gitDtPull
# ------------------------------------------------------------------ #
function _gitDtPull ()
{
  echo "${lrgDvdr}${clrBLU}$(date '+%H:%M:%S')${clrRST} -- "
  cd ${dtGitDir}
  # pull dt
  git pull >/dev/null 2>&1 &
  prcssPid="$!" ; txtStrng="pull - incorporating remote changes"
  _shwPrgrs
  # update rawspeed
  printf "\r  pull - updating rawspeed .. "
  git submodule update >/dev/null 2>&1 || _errHndlr "_gitDtPull" "submodule update"
  printf "\r  pull - updating rawspeed ${clrGRN}OK${clrRST}\n"
  # version info
  vrsnInfo="pulled version          :"
  _getDtVrsn
}

# ------------------------------------------------------------------ #
# Function : Build darktable
# Purpose  : Building darktable, as normal user
# Syntax   : _gitDtBuild
# ------------------------------------------------------------------ #
function _gitDtBuild ()
{
  echo "${lrgDvdr}${clrBLU}$(date '+%H:%M:%S')${clrRST} -- "
  cd ${dtGitDir}
  # create and enter clean build environment
  rm -rf build > /dev/null 2>&1
  mkdir build
  cd ${dtGitDir}/build
  # start timer
  strtBldTime=$(date +%s)
  # run cmake
  cmake -DCMAKE_PREFIX_PATH="${CMAKE_PREFIX_PATH}" \
        -DCMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE}" \
        -DUSE_CAMERA_SUPPORT="${USE_CAMERA_SUPPORT}" \
        -DUSE_COLORD="${USE_COLORD}" \
        -DUSE_DARKTABLE_PROFILING="${USE_DARKTABLE_PROFILING}" \
        -DUSE_FLICKR="${USE_FLICKR}" \
        -DUSE_GRAPHICSMAGICK="${USE_GRAPHICSMAGICK}" \
        -DUSE_KWALLET="${USE_KWALLET}" \
        -DUSE_LENSFUN="${USE_LENSFUN}" \
        -DUSE_LIBSECRET="${USE_LIBSECRET}" \
        -DUSE_MAP="${USE_MAP}" \
        -DUSE_NLS="${USE_NLS}" \
        -DUSE_OPENEXR="${USE_OPENEXR}" \
        -DUSE_OPENJPEG="${USE_OPENJPEG}" \
        -DUSE_OPENMP="${USE_OPENMP}" \
        -DUSE_UNITY="${USE_UNITY}" \
        -DUSE_WEBP="${USE_WEBP}" \
        -DUSE_XMLLINT="${USE_XMLLINT}" \
        -DUSE_LUA="${USE_LUA}" \
        -DDONT_USE_INTERNAL_LUA="${DONT_USE_INTERNAL_LUA}" \
        -DUSE_OPENCL="${USE_OPENCL}" \
        -DCUSTOM_CFLAGS="${CUSTOM_CFLAGS}" \
        -DBUILD_BATTERY_INDICATOR="${BUILD_BATTERY_INDICATOR}" \
        -DBUILD_CMSTEST="${BUILD_CMSTEST}" \
        -DBUILD_CURVE_TOOLS="${BUILD_CURVE_TOOLS}" \
        -DBUILD_NOISE_TOOLS="${BUILD_NOISE_TOOLS}" \
        -DBUILD_PRINT="${BUILD_PRINT}" \
        -DBUILD_RS_IDENTIFY="${BUILD_RS_IDENTIFY}" \
        -DBUILD_TESTS="${BUILD_TESTS}" \
        -DBUILD_USERMANUAL="${BUILD_USERMANUAL}" \
        -DBINARY_PACKAGE_BUILD="${BINARY_PACKAGE_BUILD}" \
        -DTESTBUILD_OPENCL_PROGRAMS="${TESTBUILD_OPENCL_PROGRAMS}" \
        CMAKE_C_FLAGS="${CMAKE_FLAGS}" \
        CMAKE_CXX_FLAGS="${CMAKE_FLAGS}" \
        -G "${cmakeGen}" \
        .. >> ${scrptLog} 2>&1 &
  prcssPid="$!" ; txtStrng="build - running cmake"
  _shwPrgrs
  # run make/ninja
  ${makeBin} ${makeOpts} >> ${scrptLog} 2>&1 &
  prcssPid="$!" ; txtStrng="build - running ${makeBin}"
  _shwPrgrs
  # stop timer
  endBldTime=$(date +%s)
  totBldTime=$(($endBldTime - $strtBldTime))
  
  
  # version info
  vrsnInfo="build version           :"
  _getDtVrsn

}

# ------------------------------------------------------------------ #
# Function : Install darktable
# Purpose  : Install darktable locally or system-wide depending on cfg
# Syntax   : _gitDtInstall
# ------------------------------------------------------------------ #
function _gitDtInstall ()
{
  echo "${lrgDvdr}${clrBLU}$(date '+%H:%M:%S')${clrRST} -- "
}

# ------------------------------------------------------------------ #
# Function : Get darktable version
# Syntax   : _getDtVrsn
# ------------------------------------------------------------------ #
function _getDtVrsn ()
{
  newVrsn=$( cd ${dtGitDir} ; git describe | sed -e 's/release-//' -e 's/[~+]/-/g' )
  vrsnInfo="${vrsnInfo}"
  [ "${curVrsn}" == "${newVrsn}" ] && sameVrsn="1"
}

# ------------------------------------------------------------------ #
# Function : Show progress
# Syntax   : _shwPrgrs
# ------------------------------------------------------------------ #
function _shwPrgrs ()
{
  spinParts="-\|/" ; cntr="0" ; ccld="0"
  while kill -0 $prcssPid 2>/dev/null
  do
    cntr=$(( (cntr+1) %4 ))
    printf "\r  ${txtStrng} ${clrGRN}${spinParts:$cntr:1}${clrRST}  "
    sleep .3 ; ((ccld++))
  done
  wait ${prcssPid}
  if [[ "$?" != "0" || "${ccld}" -le "1" ]]
  then
    printf "\r\r  - - - - - -> ${clrRED}An error occurred${clrRST}\n\n"
    echo   "              Stubbornly refusing to continue."
    echo   ""
    echo   "              Details are in :  ${scrptLog}"
    echo   ""
    exit 254
  fi
  printf "\r  ${txtStrng} ${clrGRN}OK${clrRST}\n"
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
  echo " ${clrRED}A fatal error occured.${clrRST}

     Problem : ${errorLocation}
     Error   : ${errorMessage}

   Exiting now.
${lrgDvdr}${clrRED}$(date '+%H:%M:%S') --${clrRST}
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
  [ "${CMAKE_FLAGS}" = "" ] && CMAKE_FLAGS="[not set]"
  cat <<EOF
${lrgDvdr}${clrBLU}$(date '+%H:%M:%S') --${clrRST} 
 ${scriptName} - version : ${scriptVersion}
 ------------------------------------------------------------------------------
 Syntax
  : dt.bldr.sh <options>
 ------------------------------------------------------------------------------
 Options
  : -c     Clone files from repository to ${baseGitDir}
  : -p     Pull updates from repository to ${dtGitDir}
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
    Script log file ............. ${logDir}

  - GIT

    Base git directory .......... ${baseGitDir}
    darktable git directory ..... ${dtGitDir}

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
${lrgDvdr}${clrBLU}$(date '+%H:%M:%S') --${clrRST} 
EOF
exit 0

}






# temp function
function _SHOWINFO ()
{
echo "baseGitDir                 ${baseGitDir}"
echo "dtGitDir                   ${dtGitDir}"
echo "logDir                     ${logDir}"
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
[ "${CMAKE_FLAGS}" = "" ] && S_CMAKE_FLAGS="[not set]"
echo "CMAKE_FLAGS                ${S_CMAKE_FLAGS}"
echo "CMAKE_CXX_FLAGS            ${S_CMAKE_FLAGS}"
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
echo "curVrsn       ${curVrsn}"
echo "newVrsn       ${newVrsn}"
echo ""
echo "optClone      ${optClone}"
echo "optPull       ${optPull}"
echo "optStop       ${optStop}"
echo "optBuild      ${optBuild}"
echo "optInstall    ${optInstall}"
echo ""
echo "instMthd      ${instMthd}"
}


# -------------------------------------------------------------------------- #
# --- Main ---
# -------------------------------------------------------------------------- #
clear
echo ""
strRunTime=$(date +%s)
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
dtGitDir="${baseGitDir}/darktable"
scrptLog="${logDir}/dt.script.log"
[[ "${CMAKE_PREFIX_PATH}" != "$HOME"* ]] && instMthd="SYS"
echo "$(date '+%H:%M:%S') - Script starts" > "${scrptLog}"
# -------------------------------------------------------------------------- #
# cmake vs ninja : use ninja if available and cmake not forced
# ------------------------------------------------------------------ #
if  [ `which ninja` ]
then
  if [ "${dfltCmake}" -eq "0" ]
  then
    echo " - ninja will be used" >> "${scrptLog}"
    ninjaIsUsed="YES" ; cmakeGen="Ninja" ; makeBin="ninja"
  else
    echo " - cmake forced, ninja will not be used" >> "${scrptLog}"
    ninjaIsUsed="NO" ; cmakeGen="Unix Makefiles" ; makeBin="make"
  fi
else
  echo " - cmake will be used" >> "${scrptLog}"
  ninjaIsUsed="NO" ; cmakeGen="Unix Makefiles" ; makeBin="make"
fi
# -------------------------------------------------------------------------- #
# --- set amount of cores ---
# ------------------------------------------------------------------ #
nmbrCores="$(printf %.0f $(echo "scale=2 ;$(nproc)/100*${crsAprch}" | bc ))"
makeOpts="-j ${nmbrCores}"
# -------------------------------------------------------------------------- #
# get/set dt version information
# ------------------------------------------------------------------ #
newVrsn=""
curVrsn="n/a"
# set current darktable version if available
[ -e ${CMAKE_PREFIX_PATH}/bin/darktable ] && \
  [ -x ${CMAKE_PREFIX_PATH}/bin/darktable ] && \
    curVrsn="$(${CMAKE_PREFIX_PATH}/bin/darktable --version | \
    sed 's/[~+]/-/g' | awk 'NR==1 { print $4 }')"
# -------------------------------------------------------------------------- #
# process options, if any
# ------------------------------------------------------------------ #
echo " - options processing" >> "${scrptLog}"
# are any options given
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

# -------------------------------------------------------- #
# act on actions
[ "${optClone}"   = "1" ] && _gitDtClone
[ "${optPull}"    = "1" ] && _gitDtPull
# -------------------------------------------------------- #
# skip build/install if -s is set and versions are the same
if [[ "${optStop}" == "1" && "${sameVrsn}" == "1" ]]
then
  echo "$(date '+%H:%M:%S')   Versions are the same: Skipping Build/Install"
else
  [ "${optBuild}"   = "1" ] && _gitDtBuild
  [ "${optInstall}" = "1" ] && _gitDtInstall
fi

# -------------------------------------------------------- #
# show some information
endRunTime=$(date +%s) ; totRunTime=$(( $endRunTime - $strRunTime ))
echo "${lrgDvdr}${clrBLU}$(date '+%H:%M:%S')${clrRST} -- "
[ ${optBuild} -eq "1" ] && printf '%27s%02d:%02d:%02d\n' "  total build time        : " $(($totBldTime/3600)) $(($totBldTime%3600/60)) $(($totBldTime%60))
printf '%27s%02d:%02d:%02d\n' "  total runtime           : " $(($totRunTime/3600)) $(($totRunTime%3600/60)) $(($totRunTime%60))
echo "  installed version       : ${curVrsn}"
echo "  ${vrsnInfo} ${newVrsn}"

# -------------------------------------------------------- #
# --- Cleanup ---
echo -e "${lrgDvdr}${clrBLU}$(date '+%H:%M:%S')${clrRST} -- \n"
echo "$(date '+%H:%M:%S') - Script ends" >> "${scrptLog}"

_SHOWINFO ; exit # <-- temporary check + exit

exit 0
# -------------------------------------------------------------------------- #
# End
