#!/bin/bash
# -------------------------------------------------------------------------- #
# https://github.com/gphoto/libgphoto2
# https://github.com/gphoto/gphoto2
# -------------------------------------------------------------------------- #
set -e
set -u
umask 026
LANG=C; LC_ALL=C; export LANG LC_ALL
LCLDIR="${LCLDIR}"
GITDIR="${LCLDIR}/git"
# -------------------------------------------------------- #
# libgphoto2
# -------------------------------------------------------- #
# get libgphoto2
cd ${GITDIR}
rm -rf libgphoto2
git clone git@github.com:gphoto/libgphoto2

# configure libgphoto2
cd ${GITDIR}/libgphoto2

autoreconf -is
#./configure --prefix="${LCLDIR}/libgphoto2" \
./configure --prefix="${LCLDIR}" \
            --disable-nls

# build and check libgphoto2
make
make check

# remove previous and  install new libgphoto2
rm -f ${LCLDIR}/bin/gphoto2-config
rm -f ${LCLDIR}/bin/gphoto2-port-config
rm -f ${LCLDIR}/share/man/man3/libgphoto2*
rm -rf ${LCLDIR}/share/doc/libgphoto2*
rm -rf ${LCLDIR}/share/libgphoto2*
rm -rf ${LCLDIR}/lib/libgphoto2*
rm -f ${LCLDIR}/lib/udev/check-ptp-camera
rm -rf ${LCLDIR}/include/gphoto2

make install

# -------------------------------------------------------- #
# gphoto2
# -------------------------------------------------------- #
# get gphoto2
cd ${GITDIR}
rm -rf gphoto2
git clone git@github.com:gphoto/gphoto2

# configure gphoto2
cd ${GITDIR}/gphoto2
autoreconf -is
./configure --prefix="${LCLDIR}/gphoto2" \
            --libdir="${LCLDIR}/lib" \
            --disable-nls

# build and check gphoto2
make
make check

# remove previous and install new gphoto2
rm -f ${LCLDIR}/bin/gphoto2
rm -rf ${LCLDIR}/gphoto2
make install

exit 0

# -------------------------------------------------------------------------- #
# End
#
# Add to dt.git.sh:

# newest gphoto2 + libgphoto2
GPHOTO2_INCLUDE_DIR="/home/jade/.local/include/"
GPHOTO2_LIBRARY="//home/jade/.locallib/libgphoto2.so"
GPHOTO2_PORT_LIBRARY="//home/jade/.locallib/libgphoto2_port.so"

        -DGPHOTO2_INCLUDE_DIR="${GPHOTO2_INCLUDE_DIR}" \
        -DGPHOTO2_LIBRARY="${GPHOTO2_LIBRARY}" \
        -DGPHOTO2_PORT_LIBRARY="${GPHOTO2_PORT_LIBRARY}" \
