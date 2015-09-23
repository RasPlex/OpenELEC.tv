################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="hyperion"
PKG_VERSION="c8a2fe8b6b1becaf518c861e75fa78af40f810cd"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/tvdzwan/hyperion"
PKG_URL="https://github.com/tvdzwan/hyperion/archive/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain ninja:host Python libusb protobuf Qt4"
PKG_PRIORITY="optional"
PKG_SECTION="graphics"
PKG_SHORTDESC="hyperion: ambilent daemon"
PKG_LONGDESC="hyperion: samples video frames and drives an LED backlight ring to provide an ambient view of the image rendered"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

if [ "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libX11"
fi

configure_target() {
if [ "$DEBUG" = yes ]; then
  CMAKE_BUILD_TYPE="Debug"
else
  CMAKE_BUILD_TYPE="Release"
fi

if [ "$KODIPLAYER_DRIVER" = "bcm2835-driver" ]; then
  cmake -G Ninja -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
        -DCMAKE_INSTALL_PREFIX="/usr" \
        -DQT_QMAKE_EXECUTABLE="${SYSROOT_PREFIX}/usr/bin/qmake" \
        -DENABLE_WS2812BPWM=ON \
        -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
        ..
elif [ "$DISPLAYSERVER" = "x11" ]; then
  cmake -G Ninja -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
        -DCMAKE_INSTALL_PREFIX="/usr" \
        -DQT_QMAKE_EXECUTABLE="${SYSROOT_PREFIX}/usr/bin/qmake" \
        -DENABLE_DISPMANX=OFF \
        -DENABLE_X11=ON \
        -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
        ..
else
  exit 0
fi
}

make_target() {
  ninja -j$CONCURRENCY_MAKE_LEVEL
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
    cp -PRv bin/hyperiond $INSTALL/usr/bin
    cp -PRv bin/hyperion-remote $INSTALL/usr/bin
    cp -PRv bin/hyperion-v4l2 $INSTALL/usr/bin

if [ "$KODIPLAYER_DRIVER" = "bcm2835-driver" ]; then
    cp -PRv bin/dispmanx2png $INSTALL/usr/bin
    cp -PRv bin/gpio2spi $INSTALL/usr/bin
elif [ "$DISPLAYSERVER" = "x11" ]; then
    cp -PRv bin/hyperion-x11 $INSTALL/usr/bin
fi

  mkdir -p $INSTALL/usr/share/hyperion/effects
    cp -PRv ../effects/* $INSTALL/usr/share/hyperion/effects

  mkdir -p $INSTALL/usr/share/services
    cp -PRv $PKG_DIR/default.d/*.json $INSTALL/usr/share/services
}

post_install() {
  enable_service hyperion-defaults.service
  enable_service hyperion.service
}
