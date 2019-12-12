#!/bin/bash
# -------------------------------------------------------------------------- #
# Author       : Jacques D. / Jade_NL
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
#              : 3) Install darktable
# -------------------------------------------------------------------------- #
# Dependencies : /opt/dt.bldr/cfg/dt.bldr.cfg  (default cfg file)
#              : /opt/dt.bldr/bin/dt.cfg.sh    (cfg file checker)
#              : git Version Control Systems needs to be installed
#              : sudo, if used for system wide installation
# -------------------------------------------------------------------------- #
# Changes      : nov 07 2019  First build / outline              1.0.0-alpha
#              : nov 10 2019  Options processing and help      1.0.0-alpha.1
#              : nov 18 2019  Start setting up main functions  1.0.0-alpha.2
#              : nov 19 2019  Fixed install and build functions   1.0.0-beta
#              : dec 02 2019  Added partial git url flexibility 1.0.0-beta.1
#              : dec 03 2019  Code cleanup                      1.0.0-beta.2
#                             Changed some variable names
#                             Fixed some minor layout issue's
#                             Changed wording output to screen
#                             Fixed skip issue
# -------------------------------------------------------------------------- #
# Copright     : GNU General Public License v3.0
#              : https://www.gnu.org/licenses/gpl-3.0.txt
# -------------------------------------------------------------------------- #
#set -x
set -u
umask 026
# -------------------------------------------------------------------------- #
# --- Variables ---
# ------------------------------------------------------------------ #
# Script core related
scriptVersion="1.0.0-beta.2"
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
clrRED=$(tput setaf 1) # red
clrGRN=$(tput setaf 2) # green
clrBLU=$(tput setaf 4) # blue
# script misc
lrgDvdr=" ------------------------------------------------------------------ "
sudoToken=""
gitVrsn="n/a"
curVrsn="n/a"
totBldTime="0"
# input options
optBuild="0"
optClone="0"
optInstall="0"
optPull="0"
optStop="0"

# -------------------------------------------------------------------------- #
# --- Functions ---
# ------------------------------------------------------------------ #
# Function : Clone darktable
# Purpose  : 1) Clone darktable remote repository into local directory
#            2) Initialize and update submodule (rawspeed)
# ------------------------------------------------------------------ #
function _gitDtClone ()
{
  # remove current files/dirs first
  [ -d ${dtGitDir} ] && find ${dtGitDir} -mindepth 1 -delete
  # clone dt
  cd ${baseRepDir}
  git clone git://github.com/darktable-org/darktable.git >/dev/null  2>&1 &
  prcssPid="$!" ; txtStrng="clone   - cloning darktable"
  _shwPrgrs
  # initialize rawspeed
  printf "\r          - initializing and updating rawspeed .. "
  cd ${dtGitDir}
  git submodule init >/dev/null 2>&1 || _errHndlr "_gitDtClone" "submodule init"
  # update rawspeed
  git submodule update >/dev/null 2>&1 || _errHndlr "_gitDtClone" "submodule update"
  printf "\r          - initializing and updating rawspeed ${clrGRN}OK${clrRST}\n"
  _getDtGitVrsn
}

# ------------------------------------------------------------------ #
# Function : Pull darktable
# Purpose  : 1) Incorporate changes from remote repository into local branch
#            2) Update submodules (rawspeed)
# ------------------------------------------------------------------ #
function _gitDtPull ()
{
  cd ${dtGitDir}
  # pull dt
  git pull >/dev/null 2>&1 &
  prcssPid="$!" ; txtStrng="pull    - incorporating remote changes"
  _shwPrgrs
  # update rawspeed
  printf "\r          - updating rawspeed .. "
  git submodule update >/dev/null 2>&1 || _errHndlr "_gitDtPull" "submodule update"
  printf "\r          - updating rawspeed ${clrGRN}OK${clrRST}\n"
  _getDtGitVrsn
}

# ------------------------------------------------------------------ #
# Function : Build darktable
# Purpose  : Building darktable, as normal user
# ------------------------------------------------------------------ #
function _gitDtBuild ()
{
  cd ${dtGitDir}
  # check same versions if optStop is set
  if [ "${optStop}" == "1" ]
  then
    _getDtGitVrsn
    if [ "${curVrsn}" == "${gitVrsn}" ]
    then
      echo "  build   - ${clrBLU}skipping${clrRST} : installed and repo version are the same"
      return
    fi
  fi
  # create and enter clean build environment
  rm -rf build > /dev/null 2>&1
  mkdir build
  cd build
set +x
  # start timer
  strtBldTime=$(date +%s)
  # run cmake
  cmake -DCMAKE_INSTALL_PREFIX="${CMAKE_PREFIX_PATH}" \
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
  prcssPid="$!" ; txtStrng="build   - configuring darktable using cmake"
  _shwPrgrs
  # run make/ninja
  ${makeBin} ${makeOpts} >> ${scrptLog} 2>&1 &
  prcssPid="$!" ; txtStrng="        - building darktable using ${makeBin}"
  _shwPrgrs
  # stop timer
  endBldTime=$(date +%s)
  totBldTime=$(($endBldTime - $strtBldTime))
  _getDtGitVrsn
}

# ------------------------------------------------------------------ #
# Function : Install darktable
# Purpose  : Install darktable locally or system-wide depending on cfg
# ------------------------------------------------------------------ #
function _gitDtInstall ()
{
  if [ "${optStop}" == "1" ]
  then
    _getDtGitVrsn
    if [ "${curVrsn}" == "${gitVrsn}" ]
    then
      echo "  install - ${clrBLU}skipping${clrRST} : installed and repo version are the same"
      return
    fi
  fi
  cd ${dtGitDir}/build || _errHndlr "_gitDtInstall" "${dtGitDir}/build: directory doesn't exist"
  printf "\r  install - installing darktable using ${makeBin} .. "
  # remove previously installed version.
  [ -d ${CMAKE_PREFIX_PATH} ] && ${sudoToken} rm -rf ${CMAKE_PREFIX_PATH}/*
  # set normal permissions if system install
  [ ! -z ${sudoToken} ] && umask 022
  # install using make/ninja
  ${sudoToken} ${makeBin} install >> ${scrptLog} 2>&1 || _errHndlr "_gitDtInstall" "${sudoToken} ${makeBin} install"
  printf "\r  install - installing darktable using ${makeBin} ${clrGRN}OK${clrRST}\n"
  # restore restricted mode if system install
  [ ! -z ${sudoToken} ] && umask 026
  _getDtGitVrsn
}

# ------------------------------------------------------------------ #
# Function : Get darktable version
# Purpose  : Get dt version from local git repository
# ------------------------------------------------------------------ #
function _getDtGitVrsn ()
{
  gitVrsn=$( cd ${dtGitDir}
  git describe | sed -e 's/release-//' -e 's/[~+]/-/g' )
}

# ------------------------------------------------------------------ #
# Function : Show progress
# Purpose  : Show an indicator to indicate progress is being made
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
# Purpose  : Print error message to screen and exit
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

     Script      : ${scriptName} (${scriptVersion})
     Problem     : ${errorLocation}
     Description : ${errorMessage}

   Exiting now.
${lrgDvdr}${clrRED}$(date '+%H:%M:%S') --${clrRST}
"
  exit 255
}

# ------------------------------------------------------------------ #
# Function : Show help and exit
# Purpose  : Show help and exit
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
  : -c     Clone files from repository to ${baseRepDir}
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

    URL ......................... ${urlGit}
    Base git directory .......... ${baseRepDir}
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



# START # # # temp function # # # START #
function _SHOWINFO ()
{
echo "urlGit                     ${urlGit}"
echo "baseRepDir                 ${baseRepDir}"
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
echo "dfltNinja     ${dfltNinja}"
echo ""
echo "ninjaIsUsed   ${ninjaIsUsed}"
echo "cmakeGen      ${cmakeGen}"
echo ""
echo "crsAprch      ${crsAprch}"
echo "makeOpts      ${makeOpts}"  
echo ""
echo "curVrsn       ${curVrsn}"
echo "gitVrsn       ${gitVrsn}"
echo ""
echo "optClone      ${optClone}"
echo "optPull       ${optPull}"
echo "optStop       ${optStop}"
echo "optBuild      ${optBuild}"
echo "optInstall    ${optInstall}"
echo ""
echo "sudoToken     ${sudoToken}"
}
# END # # # temp function # # # END #


# -------------------------------------------------------------------------- #
# --- Main ---
# -------------------------------------------------------------------------- #
clear
echo ""
strRunTime=$(date +%s)
echo "${lrgDvdr}${clrBLU}$(date '+%H:%M:%S')${clrRST} -- "
[ "$EUID" -eq 0 ] && _errHndlr "Main" "Do not run script as root user."
# -------------------------------------------------------------------------- #
# parse configuration file
# ------------------------------------------------------------------ #
# check config file(s)
${cfgChkr} >/dev/null 2>&1
[ "$?" -eq "0" ] || \
  _errHndlr "Configuration file(s)" \
            "Content not valid.  Run dt.cfg.sh -c for details"
# parse default system wide configuration file
. ${defCfgFile}
# parse user defined configuration file
[ -f "${usrCfgFile}" ] && . ${usrCfgFile}
# -------------------------------------------------------------------------- #
# set extra variables based on configurations file
# ------------------------------------------------------------------ #
dtGitDir="${baseRepDir}/darktable"
scrptLog="${logDir}/dt.script.log"
[[ "${CMAKE_PREFIX_PATH}" != "$HOME"* ]] && sudoToken="sudo"
echo "$(date '+%H:%M:%S') - Script starts" > "${scrptLog}"
# -------------------------------------------------------------------------- #
# cmake vs ninja : use ninja if available and cmake not forced
# ------------------------------------------------------------------ #
if  [ `which ninja` ]
then
  if [ "${dfltNinja}" -eq "1" ]
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
# get/set darktable version information (installed version)
# ------------------------------------------------------------------ #
# set currently installed darktable version if available
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
[ "${optBuild}"   = "1" ] && _gitDtBuild
[ "${optInstall}" = "1" ] && _gitDtInstall
# -------------------------------------------------------- #
# show some information
endRunTime=$(date +%s) ; totRunTime=$(( $endRunTime - $strRunTime ))
echo "${lrgDvdr}${clrBLU}$(date '+%H:%M:%S')${clrRST} -- "
[ ${optBuild} -eq "1" ] && printf '%20s%02d:%02d:%02d\n' "  total build time   " $(($totBldTime/3600)) $(($totBldTime%3600/60)) $(($totBldTime%60))
printf '%20s%02d:%02d:%02d\n' "  total runtime      " $(($totRunTime/3600)) $(($totRunTime%3600/60)) $(($totRunTime%60))
echo "  installed version  ${curVrsn}"
echo "  git version        ${gitVrsn}"
# -------------------------------------------------------- #
# --- Cleanup ---
echo -e "${lrgDvdr}${clrBLU}$(date '+%H:%M:%S')${clrRST} -- \n"
echo "$(date '+%H:%M:%S') - Script ends" >> "${scrptLog}"

exit 0
# -------------------------------------------------------------------------- #
# End
