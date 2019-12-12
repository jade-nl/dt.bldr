#!/bin/bash
# -------------------------------------------------------------------------- #
# https://github.com/lensfun/lensfun
# -------------------------------------------------------------------------- #
set -e
set -u
umask 026
LANG=C; LC_ALL=C; export LANG LC_ALL

# get lensfun
cd /home/jade/Git
rm -rf lensfun
git clone git@github.com:lensfun/lensfun.git

# build lensfun
cd /home/jade/Git/lensfun
rm -rf build
mkdir build
cd build

#cmake -DCMAKE_INSTALL_PREFIX="/home/jade/.local/lensfun" \
#      -DCMAKE_INSTALL_LIBDIR="/home/jade/.local/lib" \
cmake -DCMAKE_INSTALL_PREFIX="/home/jade/.local" \
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

# install lensfun
rm -f /home/jade/.local/bin/{lensfun*,g-lensfun*,lenstool}
rm -f /home/jade/.local/lib/liblensfun*
rm -f /home/jade/.local/lib/pkgconfig/lensfun.pc
rm -rf /home/jade/.local/include/lensfun
rm -rf /home/jade/.local/lib/python2.7/site-packages/lensfun*
rm -rf /home/jade/.local/share/lensfun
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

