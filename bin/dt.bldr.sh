#!/bin/bash
# -------------------------------------------------------------------------- #
# Author       : Jacques D. / Jade_NL
# -------------------------------------------------------------------------- #
# Syntax       : dt.bldr.sh <options>
# Options      : -c          Clone files from git repository
#              : -p          Pull update from git repository
#              : -s          Stop if versions are the same
#              : -C file     Use file as configuration. This forces the
#                            -b and -i to be set also.
#              : -b          Build darktable
#              : -i          Install darktable
#              : -m          Merge branch using fixed dt.ext.branch.cfg
#              : -M file/URL Merge branch specifying input file or URL
#              : -t          Download the integration tests
#              : -h/-?       Show help
# -------------------------------------------------------------------------- #
# Purpose      : 1) Clone or pull darktable from git repository
#              :    - Optionally merge external branch
#              : 2) Build darktable
#              : 3) Install darktable
# -------------------------------------------------------------------------- #
# Dependencies : /opt/dt.bldr/cfg/dt.bldr.cfg             (default cfg file)
#              : git Version Control Systems
#              : sudo, for non-local installations
# -------------------------------------------------------------------------- #
#              : dec 12 2019                                           1.0.0
#              : jan 02 2020                                           1.1.0
#              : jan 05 2020                                           1.2.0
#              : may 28 2020                                           1.3.0
#              : may 28 2020                                           1.4.0
#              : may 30 2020                                           1.5.0
#              : jun 24 2020                                           1.6.0
#              : jun 28 2020  Code cleanup                             1.6.1
#              : jul 14 2020  Fix minor screen output mishap           1.6.2
#              : oct 10 2020  Added build options                      1.6.3
#              : oct 15 2020  Fixed rawspeed init in pull part         1.6.4
#              : oct 17 2020  Minor cosmetic fix                       1.6.5
#              : nov 14 2020  Added set compiler option                1.7.0
#              : nov 15 2020  Streamlined the compiler option          1.7.1
#              : jan 15 2021  Make sure cloned repo is 100% clean
#                             Disable integration test downloads       1.7.2
#              : nov 16 2021  Removed obsolete CMake option            1.7.3
#              : mar 16 2022  Removed obsolete github option           1.7.4
#              : apr 01 2022  Made merging more flexible               1.7.5
#              : apr 03 2022  CFG files can be given on command line   2.0.0
#              : oct 26 2022  Include HEIF, ISOBMFF and JXL support    2.1.0
#              : oct 26 2022  Include ICU, LIBRAW and PORTMIDI support 2.1.1
#              : oct 26 2022  Fixed a deleted char in help section     2.1.2
#              : oct 13 2023  Fixed versioning change issue            2.1.3
#              : oct 15 2023  Fixed "Ignore extra path.." issue        2.1.4
#              : jun 07 2025  Git: added --recursive to submodule      2.1.5
#              : jun 07 2025  Cleanup now unused cmake options         2.1.6
#              : jun 09 2025  Added SDL2, INTERNAL_LIBRAW
#                                   and E_COLORED_OUTPUT               2.1.7
#              : jun 09 2025  Added PATH check/warning
#                             Removed dt.cfg.sh references
#                             Force b and i options with -C option
#                             Code cleanup                             2.1.8
#              : jun 13 2025  -M now excepts a file or URL             2.1.9
#              : jun 14 2025  Merging silently removes existing branch 2.1.10
# -------------------------------------------------------------------------- #
# Copyright    : GNU General Public License v3.0
#              : https://www.gnu.org/licenses/gpl-3.0.txt
# -------------------------------------------------------------------------- #
#set -x
set -u
umask 026
# Set sane environment
LANG=POSIX; LC_ALL=POSIX; export LANG LC_ALL
# -------------------------------------------------------------------------- #
# --- Variables ---
# ------------------------------------------------------------------ #
# Script core related
scriptVersion="2.1.10"
scriptName="$(basename "${0}")"
# script directories
scriptDir="/opt/dt.bldr"
cfgDir="${scriptDir}/cfg"
usrBaseDir="$HOME/.local"
logDir="/opt/dt.bldr/log"
baseGitSrcDir=""
baseLclSrcDir=""
# script files
defCfgFile="${cfgDir}/dt.bldr.cfg"
usrCfgFile="${usrBaseDir}/cfg/dt.bldr.cfg"
usrMergeInput="${usrBaseDir}/cfg/dt.ext.branch.cfg"
# colours
clrRST=$(tput sgr0)    # reset
clrRED=$(tput setaf 1) # red
clrGRN=$(tput setaf 2) # green
clrBLU=$(tput setaf 4) # blue
# input options
urlRegex=""
optBuild="0"
optClone="0"
optHelp="0"
optHelp="0"
optInstall="0"
optMerge="0"
optPull="0"
optStop="0"
optTest="0"
dfltClone=""
dfltPull=""
dfltBuild=""
dfltInstall=""
dfltNinja=""
dfltStop=""
dfltTest=""
# script misc
lrgDvdr=" ------------------------------------------------------------------ "
sudoToken=""
instToken=""
gitVrsn="n/a"
curVrsn="n/a"
equVrsn="0"
ttlBldTime="0"
baseSrcDir=""
dtGitDir=""
vrbMsg=""
gitSRC=""
useSRC=""
lclSRC=""
tmpUniqID="$(date "+%N")"
# -------------------------------------------------------------------------- #
# --- Functions ---
# ------------------------------------------------------------------ #
# Function : Parse configuration files
# Purpose  : Set default options to use based on default and personal
#            configuration file(s)
# ------------------------------------------------------------------ #
function _parseCfgs ()
{
  # parse default system wide configuration file
  source "${defCfgFile}"
  # parse user defined configuration file
  [ -f "${usrCfgFile}" ] && source "${usrCfgFile}"
}
# ------------------------------------------------------------------ #
# Function : Clone darktable
# Purpose  : 1) Clone darktable remote repository into local directory
#            2) Initialize and update submodule (rawspeed)
# ------------------------------------------------------------------ #
function _gitDtClone ()
{
  # remove current files/dirs first
  [ -d "${dtGitDir}" ] && find "${dtGitDir}" -mindepth 1 -delete
  # clone dt
  cd ${baseSrcDir} 2>/dev/null || _errHndlr "_gitDtClone" "${baseSrcDir} No such directory."
  git clone "${gitSRC}" >> "${bldLog}" 2>&1 &
  prcssPid="$!" ; txtStrng="clone   - cloning darktable"
  _shwPrgrs
  # enter repository
  cd "${dtGitDir}" || _errHndlr "_gitDtClone" "Cannot cd into ${dtGitDir} directory"
  # make sure repository is clean
  git clean -d -f -x >> "${bldLog}" 2>&1 || _errHndlr "_gitDtClone" "cleaning repository"

  # disable integration test downloads (unless asked for)
  if [ "${optTest}" -eq "0" ]
  then
    printf "\\r          - disabling integration tests"
    git config submodule.src/tests/integration.update none  >> "${bldLog}" 2>&1 || _errHndlr "_gitDtClone" "disable integration test"
    printf "\\r          - disabling integration tests %sOK%s\\n" "${clrGRN}" "${clrRST}"
  else
    printf "\\r          - integration tests are not disabled \\n"
  fi
  # initialize rawspeed
  printf "\\r          - initializing and updating rawspeed"
  git submodule init >> "${bldLog}" 2>&1 || _errHndlr "_gitDtClone" "submodule init"
  # update rawspeed
  git submodule update --recursive >> "${bldLog}" 2>&1 || _errHndlr "_gitDtClone" "submodule update"
  printf "\\r          - initializing and updating rawspeed %sOK%s\\n" "${clrGRN}" "${clrRST}"
  # get dt version from repo
  _getDtGitVrsn
}

# ------------------------------------------------------------------ #
# Function : Pull darktable
# Purpose  : 1) Incorporate changes from remote repository into local branch
#            2) Update submodules (rawspeed)
# ------------------------------------------------------------------ #
function _gitDtPull ()
{
  cd "${dtGitDir}"  2>/dev/null || _errHndlr "_gitDtPull" "${dtGitDir} No such directory."
  [ "$(ls -A)" ] || _errHndlr "_gitDtPull" "git directory is empty"
  # pull dt
  git pull >> "${bldLog}" 2>&1 &
  prcssPid="$!" ; txtStrng="pull    - incorporating remote changes"
  _shwPrgrs
  # initialize rawspeed
  printf "\\r          - initialize rawspeed"
  git submodule init >> "${bldLog}" 2>&1 || _errHndlr "_gitDtPull" "submodule init"
  # update rawspeed
  printf "\\r          - updating rawspeed"
  git submodule update --recursive >> "${bldLog}" 2>&1 || _errHndlr "_gitDtPull" "submodule update"
  printf "\\r          - updating rawspeed %sOK%s\\n" "${clrGRN}" "${clrRST}"
  # get dt version from repo
  _getDtGitVrsn
}

# ------------------------------------------------------------------ #
# Function : Merge forked
# Purpose  : Merge specific branch from a forked darktable into master
# ------------------------------------------------------------------ #
function _gitDtMerge ()
{
  printf "\\r  merge   - merging fork "
  cd "${dtGitDir}"  2>/dev/null || _errHndlr "_gitDtMerge" "${dtGitDir} No such directory."
  [ "$(ls -A)" ] || _errHndlr "_gitDtMerge" "git directory is empty"
  # check if already merged into master: silently delete before re-merging
  git branch --merged master | grep -q "${FRK_BRNCH}" && git branch -d "${FRK_BRNCH}" >> "${bldLog}"
  # set up remote, forked repo
  git remote add "${tmpUniqID}" "${FRK_GIT}" >> "${bldLog}" 2>&1 || _errHndlr "_gitDtMerge" "Unable to add remote"
  git remote update >> "${bldLog}" 2>&1 || _errHndlr "_gitDtMerge" "Unable to update remote"
  # create, checkout and merge wanted (remote) branch
  git branch "${FRK_BRNCH}" >> "${bldLog}" 2>&1 || _errHndlr "_gitDtMerge" "Unable to switch branch"
  git checkout >> "${bldLog}" 2>&1 "${FRK_BRNCH}" > /dev/null 2>&1
  git merge -m "merging" --allow-unrelated-histories "${tmpUniqID}/${FRK_BRNCH}" >> "${bldLog}" 2>&1 || _errHndlr "_gitDtMerge" "Unable to temporarily merge"
  # merge into darktable master
  git checkout master >> "${bldLog}" 2>&1 || _errHndlr "_gitDtMerge" "Unable to switch branch"
  git merge -m "${FRK_BRNCH}" "${FRK_BRNCH}" >> "${bldLog}" 2>&1 || _errHndlr "_gitDtMerge" "Unable to merge"
  printf "\\r  merge   - merging fork %sOK%s\\n" "${clrGRN}" "${clrRST}"
}

# ------------------------------------------------------------------ #
# Function : Build darktable
# Purpose  : Building darktable, as normal user
# ------------------------------------------------------------------ #
function _gitDtBuild ()
{
  cd "${dtGitDir}" 2>/dev/null || _errHndlr "_gitDtBuild" "${dtGitDir} No such directory."
  # check same versions if optStop is set
  if [ "${optStop}" -eq "1" ]
  then
    _getDtGitVrsn
    if [[ "${curVrsn}" == "${gitVrsn}" ]]
    then
      echo "  build   - ${clrBLU}skipping${clrRST} : installed and git version are the same"
      equVrsn="1"
      return
    fi
  fi
  # set compiler to use
  if [[ "${compSRC}" == "clang" ]]
  then
    export CC=clang
    export CXX=clang++
  else
    # use the default compiler
    export CC=gcc
    export CXX=g++
  fi

  # create and enter clean build environment
  rm -rf build > /dev/null 2>&1
  mkdir build || _errHndlr "_gitDtBuild" "Cannot create build directory"
  cd build || _errHndlr "_gitDtBuild" "Cannot cd into build directory"
  # start timer
  strtBldTime=$(date +%s)
  # run cmake
  cmake -DCMAKE_INSTALL_PREFIX="${CMAKE_PREFIX_PATH}" \
        -DCMAKE_INSTALL_BINDIR="${CMAKE_INSTALL_BINDIR}" \
        -DCMAKE_INSTALL_LIBDIR="${CMAKE_INSTALL_LIBDIR}" \
        -DCMAKE_INSTALL_DATAROOTDIR="${CMAKE_INSTALL_DATAROOTDIR}" \
        -DCMAKE_INSTALL_DOCDIR="${CMAKE_INSTALL_DOCDIR}" \
        -DCMAKE_INSTALL_LOCALEDIR="${CMAKE_INSTALL_LOCALEDIR}" \
        -DCMAKE_INSTALL_MANDIR="${CMAKE_INSTALL_MANDIR}" \
        -DCMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE}" \
        -DCMAKE_VERBOSE_MAKEFILE:BOOL="${CMAKE_VERBOSE_MAKEFILE}" \
        -DUSE_AVIF="${USE_AVIF}" \
        -DUSE_CAMERA_SUPPORT="${USE_CAMERA_SUPPORT}" \
        -DUSE_COLORD="${USE_COLORD}" \
        -DUSE_DARKTABLE_PROFILING="${USE_DARKTABLE_PROFILING}" \
        -DUSE_GMIC="${USE_GMIC}" \
        -DUSE_GRAPHICSMAGICK="${USE_GRAPHICSMAGICK}" \
        -DUSE_HEIF="${USE_HEIF}" \
        -DUSE_ICU="${USE_ICU}" \
        -DUSE_IMAGEMAGICK="${USE_IMAGEMAGICK}" \
        -DUSE_ISOBMFF="${USE_ISOBMFF}" \
        -DUSE_JXL="${USE_JXL}" \
        -DUSE_KWALLET="${USE_KWALLET}" \
        -DUSE_LIBRAW="${USE_LIBRAW}" \
        -DUSE_LIBSECRET="${USE_LIBSECRET}" \
        -DUSE_LUA="${USE_LUA}" \
        -DUSE_MAP="${USE_MAP}" \
        -DUSE_OPENCL="${USE_OPENCL}" \
        -DUSE_OPENEXR="${USE_OPENEXR}" \
        -DUSE_OPENJPEG="${USE_OPENJPEG}" \
        -DUSE_OPENMP="${USE_OPENMP}" \
        -DUSE_PORTMIDI="${USE_PORTMIDI}" \
        -DUSE_SDL2="${USE_SDL2}" \
        -DUSE_UNITY="${USE_UNITY}" \
        -DUSE_WEBP="${USE_WEBP}" \
        -DUSE_XCF="${USE_XCF}" \
        -DUSE_XMLLINT="${USE_XMLLINT}" \
        -DDONT_USE_INTERNAL_LUA="${DONT_USE_INTERNAL_LUA}" \
        -DDONT_USE_INTERNAL_LIBRAW="${DONT_USE_INTERNAL_LIBRAW}" \
        -DCUSTOM_CFLAGS="${CUSTOM_CFLAGS}" \
        -DFORCE_COLORED_OUTPUT="${FORCE_COLORED_OUTPUT}" \
        -DBUILD_CMSTEST="${BUILD_CMSTEST}" \
        -DBUILD_CURVE_TOOLS="${BUILD_CURVE_TOOLS}" \
        -DBUILD_NOISE_TOOLS="${BUILD_NOISE_TOOLS}" \
        -DBUILD_PRINT="${BUILD_PRINT}" \
        -DBUILD_RS_IDENTIFY="${BUILD_RS_IDENTIFY}" \
        -DBINARY_PACKAGE_BUILD="${BINARY_PACKAGE_BUILD}" \
        -DTESTBUILD_OPENCL_PROGRAMS="${TESTBUILD_OPENCL_PROGRAMS}" \
        -DCMAKE_C_FLAGS="${CMAKE_FLAGS}" \
        -DCMAKE_CXX_FLAGS="${CMAKE_FLAGS}" \
        -G "${cmakeGen}" \
        .. >> "${bldLog}" 2>&1 &
  prcssPid="$!" ; txtStrng="build   - configuring darktable using cmake"
  _shwPrgrs
  # run make/ninja
  # DO NOT DOUBLE QUOTE ${makeOpts}
  ${makeBin} ${makeOpts} >> "${bldLog}" 2>&1 &
  prcssPid="$!" ; txtStrng="        - building darktable using ${makeBin}${vrbMsg}"
  _shwPrgrs
  # stop timer
  endBldTime=$(date +%s)
  ttlBldTime=$((endBldTime - strtBldTime))
  # get dt version from repo
  _getDtGitVrsn
}

# ------------------------------------------------------------------ #
# Function : Install darktable
# Purpose  : Install darktable locally or system-wide depending on cfg
# ------------------------------------------------------------------ #
function _gitDtInstall ()
{
  # check same versions if optStop is set
  if [ "${optStop}" -eq "1" ]
  then
    _getDtGitVrsn
    if [[ "${curVrsn}" == "${gitVrsn}" ]]
    then
      echo "  install - ${clrBLU}skipping${clrRST} : installed and git version are the same"
      equVrsn="1"
      return
    fi
  fi
  cd "${dtGitDir}/build" 2>/dev/null || _errHndlr "_gitDtInstall" "${dtGitDir}/build No such directory"
  # remove previously installed version.
  tput sc
  [ -d "${CMAKE_PREFIX_PATH}" ] && ${sudoToken} rm -rf "${CMAKE_PREFIX_PATH}"/*
  # set env if it is a non-local install
  if [ ! -z ${sudoToken} ]
  then
    umask 022
    instToken="sudo"
    tput rc ; tput ed
  fi
  # install using make/ninja
  ${sudoToken} "${makeBin}" install >> "${bldLog}" 2>&1 &
  prcssPid="$!" ; txtStrng="install - installing darktable using make"
  _shwPrgrs
  # restore if system install
  [ ! -z ${sudoToken} ] && umask 026 && instToken=""
  # get dt version from repo
  _getDtGitVrsn
}

# ------------------------------------------------------------------ #
# Function : Get darktable version
# Purpose  : Get dt version from local source
# ------------------------------------------------------------------ #
function _getDtGitVrsn ()
{
  # remote or local
  if [[ "${useSRC}" == "git" ]]
  then
  # remote (git is used)
    gitVrsn=$( cd "${dtGitDir}" || _errHndlr "_getDtGitVrsn" "Unable to cd"
               git describe | \
               sed -e 's/release-//' -e 's/[~+]/-/g' )
  else
  # local (tarball is used)
    gitVrsn="$(echo ${lclSRC} | \
               sed -e 's/darktable-\(.*\).tar.xz/\1/' -e 's/[~+]/-/g')"
  fi
}

# ------------------------------------------------------------------ #
# Function : Show progress
# Purpose  : Show an indicator to indicate progress is being made
# ------------------------------------------------------------------ #
function _shwPrgrs ()
{
  spnPrts="-\\|/" ; cntr="0" ; ccld="0"
  while ${instToken} kill -0 $prcssPid 2>/dev/null
  do
    cntr=$(( (cntr+1) %4 ))
    printf "\\r  %s %s%s%s   " "${txtStrng}" "${clrGRN}" "${spnPrts:$cntr:1}" "${clrRST}"
    sleep .3 ; ((ccld++))
  done
  wait ${prcssPid}
  if [[ "$?" != "0" || "${ccld}" -le "1" ]]
  then
    printf "\\n\\n  - - - -> %sAn error occurred%s\\n\\n" "${clrRED}" "${clrRST}"
    echo   "           Stubbornly refusing to continue."
    echo   ""
    echo   "           Details are in :  ${bldLog}"
    echo   ""
    exit 254
  fi
  printf "\\r  ${txtStrng} %sOK%s\\n" "${clrGRN}" "${clrRST}"
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
  echo -e "\\n  ${clrRED}A fatal error occurred.${clrRST}

   Script      : ${scriptName} (${scriptVersion})
   Problem     : ${errorLocation}
   Description : ${errorMessage}

  ${clrRED}Exiting now.${clrRST}
${lrgDvdr}${clrRED}$(date '+%H:%M:%S') --${clrRST}
"
  exit 255
}

# ------------------------------------------------------------------ #
# Function : Show help
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
 Syntax    dt.bldr.sh <options>
 ------------------------------------------------------------------------------
 Options
  : -c           Clone files from repository to ${baseSrcDir}
  : -p           Pull updates from repository to ${dtGitDir}
  : -s           Stop processing if installed version and cloned
                  or pulled versions are the same.
  : -C file      Use file as configuration. This forces the
  :              -b and -i to be set also.
  : -b           Build darktable (see General below)
  : -i           Install darktable to ${CMAKE_PREFIX_PATH}

  : -m           Merge branch using fixed dt.ext.branch.cfg
  : -M file/URL  Merge branch specifying input file or URL
  : -t           Download the integration tests

  : -h/-?        Show this output

  Starting without any options set will trigger the default run options.
 ------------------------------------------------------------------------------
  - General
    Script base directory ....... ${scriptDir} 
    Default Cfg file ............ ${defCfgFile}
    USer Cfg file ............... ${usrCfgFile}
    Script/Build log file ....... ${logDir}

  - Source
    Source used ................. ${useSRC}
    GIT source .................. ${gitSRC}
    Local GIT directory ......... ${baseGitSrcDir}
    Tarball ..................... ${lclSRC}
    Local tarball directory ..... ${baseLclSrcDir}

  - Build and Install
    Compiler being used ......... ${compSRC}
    Prefix (install) path ....... ${CMAKE_PREFIX_PATH}
    Bindir path ................. ${CMAKE_INSTALL_BINDIR}
    Libdir path ................. ${CMAKE_INSTALL_LIBDIR}
    Datarootdir path ............ ${CMAKE_INSTALL_DATAROOTDIR}
    Docdir path ................. ${CMAKE_INSTALL_DOCDIR}
    Localedir path .............. ${CMAKE_INSTALL_LOCALEDIR}
    Mandir path ................. ${CMAKE_INSTALL_MANDIR}
    Verbosity ................... ${CMAKE_VERBOSE_MAKEFILE}

    CMAKE_BUILD_TYPE ............ ${CMAKE_BUILD_TYPE}

    CMAKE_C_FLAGS ............... ${CMAKE_FLAGS}
    CMAKE_CXX_FLAGS ............. ${CMAKE_FLAGS}
    CUSTOM_CFLAGS  .............. ${CUSTOM_CFLAGS}

    USE_CAMERA_SUPPORT .......... ${USE_CAMERA_SUPPORT}
    USE_COLORD .................. ${USE_COLORD}
    USE_AVIF .................... ${USE_AVIF}
    USE_DARKTABLE_PROFILING ..... ${USE_DARKTABLE_PROFILING}
    USE_GMIC .................... ${USE_GMIC}
    USE_GRAPHICSMAGICK .......... ${USE_GRAPHICSMAGICK}
    USE_HEIF .................... ${USE_HEIF}
    USE_ICU ..................... ${USE_ICU}
    USE_IMAGEMAGICK ............. ${USE_IMAGEMAGICK}
    USE_ISOBMFF ................. ${USE_ISOBMFF}
    USE_JXL ..................... ${USE_JXL}
    USE_KWALLET ................. ${USE_KWALLET}
    USE_LIBSECRET ............... ${USE_LIBSECRET}
    USE_LIBRAW .................. ${USE_LIBRAW}
    USE_LUA ..................... ${USE_LUA}
    DONT_USE_INTERNAL_LUA ....... ${DONT_USE_INTERNAL_LUA}
    DONT_USE_INTERNAL_LIBRAW .... ${DONT_USE_INTERNAL_LIBRAW}
    USE_MAP ..................... ${USE_MAP}
    USE_OPENCL .................. ${USE_OPENCL}
    USE_OPENEXR ................. ${USE_OPENEXR}
    USE_OPENJPEG ................ ${USE_OPENJPEG}
    USE_OPENMP .................. ${USE_OPENMP}
    USE_PORTMIDI ................ ${USE_PORTMIDI}
    USE_SDL2 .................... ${USE_SDL2}
    USE_UNITY ................... ${USE_UNITY}
    USE_WEBP .................... ${USE_WEBP}
    USE_XCF ..................... ${USE_XCF}
    USE_XMLLINT ................. ${USE_XMLLINT}

    BUILD_CMSTEST ............... ${BUILD_CMSTEST}
    BUILD_CURVE_TOOLS ........... ${BUILD_CURVE_TOOLS}
    BUILD_NOISE_TOOLS ........... ${BUILD_NOISE_TOOLS}
    BUILD_PRINT ................. ${BUILD_PRINT}
    BUILD_RS_IDENTIFY ........... ${BUILD_RS_IDENTIFY}
    FORCE_COLORED_OUTPUT ........ ${FORCE_COLORED_OUTPUT}

    BINARY_PACKAGE_BUILD ........ ${BINARY_PACKAGE_BUILD}
    TESTBUILD_OPENCL_PROGRAMS.... ${TESTBUILD_OPENCL_PROGRAMS}

  - Default run options
    dfltClone ................... ${dfltClone}
    dfltPull .................... ${dfltPull}
    dfltBuild ................... ${dfltBuild}
    dfltInstall ................. ${dfltInstall}
    dfltNinja ................... ${dfltNinja}
    dfltStop .................... ${dfltStop}
    dfltTest .................... ${dfltTest}

${lrgDvdr}${clrBLU}$(date '+%H:%M:%S') --${clrRST} 
EOF
exit 0
}

# -------------------------------------------------------------------------- #
# --- Main ---
# -------------------------------------------------------------------------- #
clear
echo ""
strRunTime=$(date +%s)
echo "${lrgDvdr}${clrBLU}$(date '+%H:%M:%S')${clrRST} -- "
[ "$EUID" -eq "0" ] && _errHndlr "Main" "Do not run script as root user."

scrptLog="${logDir}/dt.script.$UID.$(date '+%Y.%m.%d.%H%M').log"
bldLog="${logDir}/dt.build.$UID.$(date '+%Y.%m.%d.%H%M').log"
echo "$(date '+%H:%M:%S') - Script starts" >> "${scrptLog}"

# -------------------------------------------------------------------------- #
# process options
# ------------------------------------------------------------------ #
echo " - options processing" >> "${scrptLog}"
# are any options given
if [ "$#" -eq "0" ]
then

  # No, parse configuration file(s)
  _parseCfgs

  # set default options from configuration file(s)
  echo " - no command line options are found" >> "${scrptLog}"
  optClone="${dfltClone}"
  optPull="${dfltPull}"
  optStop="${dfltStop}"
  optBuild="${dfltBuild}"
  optInstall="${dfltInstall}"
  optTest="${dfltTest}"

else

  echo " - options are found" >> "${scrptLog}"
  # process options
  while getopts ":cpsbiC:mM:th" OPTION
  do
    case "${OPTION}" in
      c) optClone="1" ;;
      p) optPull="1" ;;
      s) optStop="1" ;;
      b) optBuild="1" ;;
      i) optInstall="1" ;;
      C) usrCfgFile="${OPTARG}"
         optBuild="1"
         optInstall="1" ;;
      m) optMerge="1" ;;
      M) usrMergeInput="${OPTARG}"
         optMerge="1" ;;
      t) optTest="1" ;;
      h) optHelp="1" ;;
      ?) optHelp="1" ;;
    esac
  done
fi

# -------------------------------------------------------------------------- #
# parse configuration file(s)

_parseCfgs

# -------------------------------------------------------------------------- #
# set variables based on configurations file
# ------------------------------------------------------------------ #
# sudo is needed when installing dt in: /usr, /opt or /bin
[[ ${CMAKE_PREFIX_PATH} == /opt/* || \
   ${CMAKE_PREFIX_PATH} == /usr/* || \
   ${CMAKE_PREFIX_PATH} == /bin* ]] && sudoToken="sudo"

# verbose or not verbose
[[ "${CMAKE_VERBOSE_MAKEFILE},," =~ "ON" ]] && vrbMsg=" (verbose)"

# -------------------------------------------------------------------------- #
# cmake vs ninja : use ninja if available and cmake not forced
# ------------------------------------------------------------------ #
if  [ "$(command -v ninja)" ]
then
  if [ "${dfltNinja}" -eq "1" ]
  then
    echo " - ninja will be used" >> "${scrptLog}"
    cmakeGen="Ninja" ; makeBin="ninja"
    # CMAKE_VERBOSE_MAKEFILE cannot be used with ninja
    if [[ "${CMAKE_VERBOSE_MAKEFILE}" == "ON" ]]
    then
      echo " - ninja does not support make's verbose" >> "${scrptLog}"
      CMAKE_VERBOSE_MAKEFILE="OFF"
    fi
  else
    echo " - cmake forced, ninja will not be used" >> "${scrptLog}"
    cmakeGen="Unix Makefiles" ; makeBin="make"
  fi
else
  echo " - cmake will be used" >> "${scrptLog}"
  cmakeGen="Unix Makefiles" ; makeBin="make"
fi

# -------------------------------------------------------------------------- #
# --- set amount of cores ---
# ------------------------------------------------------------------ #
nmbrCores="$(printf %.0f "$(echo "scale=2 ;$(nproc)/100*${crsAprch}" | bc )")"
makeOpts="-j ${nmbrCores}"

# -------------------------------------------------------------------------- #
# get/set darktable version information (installed version)
# TODO - this only works for default CMAKE_PREFIX_PATH installs!
# ------------------------------------------------------------------ #
# set currently installed darktable version if available
[ -e "${CMAKE_PREFIX_PATH}/bin/darktable" ] && \
  [ -x "${CMAKE_PREFIX_PATH}/bin/darktable" ] && \
    curVrsn="$("${CMAKE_PREFIX_PATH}/bin/darktable" --version | \
    sed -e 's/this is //' -e 's/\-dirty//' -e 's/[~+]/-/g' | awk 'NR==1 { print $2 }')"

# -------------------------------------------------------------------------- #
# set env for remote (git) or local (tarball) source
# ------------------------------------------------------------------ #
echo " - source is: ${useSRC}" >> "${scrptLog}"
# source is remote
if [[ "${useSRC}" == "git" ]]
then
  # set dir names
  baseSrcDir="${baseGitSrcDir}"
  dtGitDir="${baseSrcDir}/darktable"
fi
# source is local
if [[ "${useSRC}" == "local" ]]
then
  if [[ "${optMerge}" -eq "1" ]]
  then
    echo "Mergin into stable tarball source is currently unsupported."
    echo "Exiting now....."
    exit 2
  fi
  fallThrough="1"
  # set dir names
  baseSrcDir="${baseLclSrcDir}"
  tempDir="darktable.temp"
  # no cloning or pulling
  optClone="0"
  optPull="0"
  # ---------------------------------------------------------------- #
  # only if -b / -i are used
  if [[ ${optBuild} -eq "1" || ${optInstall} -eq "1" ]]
  then
    echo " - setting up local source environment" >> "${scrptLog}"
    fallThrough="0"
  fi
  # ---------------------------------------------------------------- #
  # only if -b is used
  if [ ${optBuild="1"} -eq "1" ]
  then
    cd -P "${baseSrcDir}" >> "${scrptLog}" 2>&1 || _errHndlr "Set local env" "Cannot cd into ${baseSrcDir}."
    rm -rf "${tempDir}" >> "${scrptLog}" 2>&1
    mkdir "${tempDir}" >> "${scrptLog}" 2>&1
    # untar tarball
    tar xvf "${lclSRC}" \
        --directory="${tempDir}/" \
        --strip-components=1 >> "${scrptLog}" 2>&1 || _errHndlr "Set local env" "Cannot untar file."
    fallThrough="0"
  fi
  dtGitDir="${baseSrcDir}/${tempDir}/"
  [ "${fallThrough}" -eq "1" ] && echo "  nothing to do      ${clrBLU}no usable action(s) specified${clrRST}"
fi

# -------------------------------------------------------- #
# if optClone and optPull are both set optPull is discarded
[[ ${optClone="1"} -eq "1" && ${optPull} -eq "1" ]] && optPull="0"

# -------------------------------------------------------- #
# load cfg file or URL and set option when optMerge is requested
if [[ "${optMerge}" -eq "1" ]]
then
  # URL or file
  urlRegex='(https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'
  if [[ $usrMergeInput =~ $urlRegex ]]
  then 
  # URL
    FRK_GIT="$(echo "${usrMergeInput}" | sed 's%/tree.*%.git%')"
    FRK_BRNCH="${usrMergeInput##*/}"
  else
  # file
    if test -r "${usrMergeInput}" -a -f "${usrMergeInput}"
    then
      # parse file
      source "${usrMergeInput}"
    else
    # oops
     _errHndlr "Parsing merge configuration" "Cannot parse ${usrMergeInput}."
    fi
  fi
  # check/set sane fetch method for darktable origin
  # if only -m or -M file are given, set optClone to 1
  [ "${optClone}" = "0" ] && [ "${optPull}" = "0" ] && optClone="1"
  # force optStop to be off, initial versions are likely to be the same
  optStop="0"
fi

# -------------------------------------------------------- #
# act on actions
[ "${optClone}"   = "1" ] && _gitDtClone
[ "${optPull}"    = "1" ] && _gitDtPull
[ "${optMerge}"   = "1" ] && _gitDtMerge
[ "${optBuild}"   = "1" ] && _gitDtBuild
[ "${optInstall}" = "1" ] && _gitDtInstall
[ "${optHelp}"    = "1" ] && _shwHelp

# -------------------------------------------------------- #
# show some information
endRunTime=$(date +%s) ; ttlRnTime=$(( endRunTime - strRunTime ))
echo "${lrgDvdr}${clrBLU}$(date '+%H:%M:%S')${clrRST} -- "
[ ${optBuild} -eq "1" ] && printf '%20s%02d:%02d:%02d\n' "  total build time   " $((ttlBldTime/3600)) $((ttlBldTime%3600/60)) $((ttlBldTime%60))
printf '%20s%02d:%02d:%02d\n' "  total runtime      " $((ttlRnTime/3600)) $((ttlRnTime%3600/60)) $((ttlRnTime%60))
# set text output depending on version differences
if [[ ${optInstall} -eq "1" && ${equVrsn} -eq "0" ]]
then
  # source version is installed
  echo "  previous version   ${curVrsn}"
  echo "  installed version  ${gitVrsn}"
else
  # source version is not installed
  echo "  installed version  ${curVrsn}"
  printf '  %-10s%-9s%-15s\n' "${useSRC}" "version" "${gitVrsn}"
fi

# -------------------------------------------------------------------------- #
# is installed darktable part of PATH
if [[ "${optInstall}" -eq "1" ]]
then
  if [[ ! ":${PATH}:" == *":${CMAKE_PREFIX_PATH}/bin:"* ]]
  then
    echo "${lrgDvdr}${clrBLU}$(date '+%H:%M:%S')${clrRST} -- "
    echo "  ${CMAKE_PREFIX_PATH}/bin is not part of the current PATH environment"
  fi
fi
# -------------------------------------------------------------------------- #
# --- Exit ---
# -------------------------------------------------------------------------- #
echo -e "${lrgDvdr}${clrBLU}$(date '+%H:%M:%S')${clrRST} -- \\n"
echo "$(date '+%H:%M:%S') - Script ends" >> "${scrptLog}"

exit 0

# -------------------------------------------------------------------------- #
# End
