#!/bin/bash
# -------------------------------------------------------------------------- #
# https://github.com/Exiv2/exiv2
# -------------------------------------------------------------------------- #
set -e
set -u
umask 026
LANG=C; LC_ALL=C; export LANG LC_ALL
# -------------------------------------------------------------------------- #
# get exiv2
cd /home/jade/Git
rm -rf exiv2
git clone git@github.com:Exiv2/exiv2

# build exiv2
cd /home/jade/Git/exiv2
rm -rf build
mkdir build
cd build

cmake -DCMAKE_INSTALL_PREFIX="/home/jade/.local/exiv2"  \
      -DCMAKE_INSTALL_LIBDIR="/home/jade/.local/lib" \
      -DCMAKE_BUILD_TYPE="Release" \
      -DEXIV2_ENABLE_XMP="ON" \
      -DEXIV2_ENABLE_PNG="ON" \
      -DEXIV2_ENABLE_NLS="OFF" \
      -DEXIV2_ENABLE_LENSDATA="ON" \
      -DEXIV2_ENABLE_WEBREADY="ON" \
      -DEXIV2_ENABLE_CURL="ON" \
      -DEXIV2_BUILD_SAMPLES="OFF" \
      -DBUILD_WITH_CCACHE="OFF" \
      -G "Unix Makefiles" \
      ..

make

# install exiv2
rm -rf /home/jade/.local/exiv2
find /home/jade/.local/lib -name "*exiv2*" -exec rm -f {} \;

make install

exit 0

# -------------------------------------------------------------------------- #
# End

# Add to/edit .bashrc
export LD_LIBRARY_PATH="/home/jade/.local/lib:$LD_LIBRARY_PATH"

# Add to dt.git.local.sh:
EXIV2_INCLUDE_DIR="/home/jade/.local/exiv2/include"
EXIV2_LIBRARY="/home/jade/.local/exiv2/lib/libexiv2.so"

        -DEXIV2_INCLUDE_DIR="${EXIV2_INCLUDE_DIR}"
        -DEXIV2_LIBRARY="${EXIV2_LIBRARY}"

