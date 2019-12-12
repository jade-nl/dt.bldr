#!/bin/bash
# -------------------------------------------------------------------------- #
# https://github.com/gphoto/libgphoto2
# https://github.com/gphoto/gphoto2
# -------------------------------------------------------------------------- #
set -e
set -u
umask 026
LANG=C; LC_ALL=C; export LANG LC_ALL
# -------------------------------------------------------- #
# libgphoto2
# -------------------------------------------------------- #
# get libgphoto2
cd /home/jade/Git
rm -rf libgphoto2
git clone git@github.com:gphoto/libgphoto2

# configure libgphoto2
cd /home/jade/Git/libgphoto2

autoreconf -is
#./configure --prefix="/home/jade/.local/libgphoto2" \
./configure --prefix="/home/jade/.local" \
            --disable-nls

# build and check libgphoto2
make
make check

# install libgphoto2
rm -f /home/jade/.local/bin/gphoto2-config
rm -f /home/jade/.local/bin/gphoto2-port-config
rm -f /home/jade/.local/share/man/man3/libgphoto2*
rm -rf /home/jade/.local/share/doc/libgphoto2*
rm -rf /home/jade/.local/share/libgphoto2*
rm -rf /home/jade/.local/lib/libgphoto2*
rm -f /home/jade/.local/lib/udev/check-ptp-camera
rm -rf /home/jade/.local/include/gphoto2

make install

# -------------------------------------------------------- #
# gphoto2
# -------------------------------------------------------- #
# get gphoto2
cd /home/jade/Git
rm -rf gphoto2
git clone git@github.com:gphoto/gphoto2

# configure gphoto2
cd /home/jade/Git/gphoto2
autoreconf -is
./configure --prefix="/home/jade/.local/gphoto2" \
            --libdir="/home/jade/.local/lib" \
            --disable-nls

# build and check gphoto2
make
make check

# install gphoto2
rm -f /home/jade/.local/bin/gphoto2
rm -rf /home/jade/.local/gphoto2
make install

exit 0

# -------------------------------------------------------------------------- #
# End
#
# Add to dt.git.sh:

# newest gphoto2 + libgphoto2
GPHOTO2_INCLUDE_DIR="/home/jade/.local/include/"
GPHOTO2_LIBRARY="/home/jade/.local/lib/libgphoto2.so"
GPHOTO2_PORT_LIBRARY="/home/jade/.local/lib/libgphoto2_port.so"

        -DGPHOTO2_INCLUDE_DIR="${GPHOTO2_INCLUDE_DIR}" \
        -DGPHOTO2_LIBRARY="${GPHOTO2_LIBRARY}" \
        -DGPHOTO2_PORT_LIBRARY="${GPHOTO2_PORT_LIBRARY}" \
