#!/bin/bash
# -------------------------------------------------------------------------- #
# https://github.com/lensfun/lensfun
# -------------------------------------------------------------------------- #
set -e
set -u
umask 026
LANG=C; LC_ALL=C; export LANG LC_ALL
LCLDIR="/home/jade/.local"
GITDIR="${LCLDIR}/git"
# -------------------------------------------------------------------------- #
# get lensfun
cd ${GITDIR}
rm -rf lensfun
git clone git@github.com:lensfun/lensfun.git

# build lensfun
cd ${GITDIR}/lensfun
rm -rf build
mkdir build
cd build

#cmake -DCMAKE_INSTALL_PREFIX="${LCLDIR}/lensfun" \
#      -DCMAKE_INSTALL_LIBDIR="${LCLDIR}/lib" \
cmake -DCMAKE_INSTALL_PREFIX="${LCLDIR}" \
      -DCMAKE_BUILD_TYPE="Release" \
      -DINSTALL_HELPER_SCRIPTS="ON" \
      -DBUILD_STATIC="OFF" \
      -DBUILD_TESTS="OFF" \
      -DBUILD_LENSTOOL="ON" \
      -DBUILD_FOR_SSE="ON" \
      -DBUILD_FOR_SSE2="ON" \
      -DBUILD_DOC="OFF" \
      ..

make

# remove previous and install new lensfun
rm -f ${LCLDIR}/bin/{lensfun*,g-lensfun*,lenstool}
rm -f ${LCLDIR}/lib/liblensfun*
rm -f ${LCLDIR}/lib/pkgconfig/lensfun.pc
rm -rf ${LCLDIR}/include/lensfun
rm -rf ${LCLDIR}/lib/python2.7/site-packages/lensfun*
rm -rf ${LCLDIR}/share/lensfun

make install

sudo /sbin/ldconfig

exit 0

# -------------------------------------------------------------------------- #
# End

# Add to dt.git.sh
# newest lensfun version
LENSFUN_INCLUDE_DIR="/home/jade/.local/lensfun/include/lensfun"
LENSFUN_LIBRARY="/home/jade/.local/lib/liblensfun.so"

        -DLENSFUN_INCLUDE_DIR="${LENSFUN_INCLUDE_DIR}" \
        -DLENSFUN_LIBRARY="${LENSFUN_LIBRARY}" \

