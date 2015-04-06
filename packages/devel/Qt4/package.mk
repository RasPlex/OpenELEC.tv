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

PKG_NAME="Qt4"
PKG_VERSION="4.8.6"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://qt-project.org"
PKG_URL="http://download.qt.io/archive/qt/4.8/${PKG_VERSION}/qt-everywhere-opensource-src-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain glib zlib libressl libpng"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="Qt for Embedded Linux"
PKG_LONGDESC="Qt for Embedded Linux"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

if [ "$KODIPLAYER_DRIVER" = "bcm2835-driver" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET bcm2835-driver"
fi

TARGET_CONFIGURE_OPTS=""
PKG_CONFIGURE_OPTS_TARGET="-verbose \
                    -prefix /usr \
                    -hostprefix ${SYSROOT_PREFIX}/usr \
                    -sysroot ${SYSROOT_PREFIX} \
                    -release \
                    -opensource \
                    -confirm-license \
                    -fast \
                    -no-accessibility \
                    -no-sql-sqlite \
                    -no-qt3support \
                    -no-xmlpatterns \
                    -no-multimedia \
                    -no-audio-backend \
                    -no-phonon \
                    -no-phonon-backend \
                    -no-svg \
                    -no-webkit \
                    -no-javascript-jit \
                    -no-script \
                    -no-scripttools \
                    -no-gif \
                    -no-libtiff \
                    -no-libmng \
                    -no-libjpeg \
                    -no-rpath \
                    -no-nis \
                    -no-cups \
                    -no-pch \
                    -no-dbus \
                    -no-freetype \
                    -no-opengl \
                    -no-openvg \
                    -force-pkg-config \
                    -little-endian \
                    -embedded $TARGET_ARCH \
                    -xplatform qws/linux-openelec-g++ \
                    -device-option CROSS_COMPILE=$TARGET_PREFIX \
                    -device-option TARGET_CFLAGS=\\\"\$TARGET_CFLAGS\\\" \
                    -device-option TARGET_CXXFLAGS=\\\"\$TARGET_CXXFLAGS\\\" \
                    -device-option TARGET_LDFLAGS=\\\"\$TARGET_LDFLAGS\\\" \
                    -optimized-qmake \
                    -make libs"

unpack() {
  rm -rf $PKG_BUILD
  mkdir -p $PKG_BUILD
  tar xzf $SOURCES/$PKG_NAME/qt-everywhere-opensource-src-${PKG_VERSION}.tar.gz -C $PKG_BUILD --strip-components=1
}

pre_configure_target() {
# Qt4 fails to build in subdirs
  cd $ROOT/$PKG_BUILD
    rm -rf .$TARGET_NAME

# setup Qt4 env vars
  unset CC CXX AR OBJCOPY STRIP CFLAGS CXXFLAGS CPPFLAGS LDFLAGS LD RANLIB
  export TARGET_PREFIX TARGET_CFLAGS TARGET_CXXFLAGS TARGET_LDFLAGS
  export PKG_CONFIG_PATH="$TARGET_PKG_CONFIG_LIBDIR"
}

post_makeinstall_target() {
  mkdir -p $INSTALL/usr/lib
    cp -P $SYSROOT_PREFIX/usr/lib/libQtCore.so* $INSTALL/usr/lib
    cp -P $SYSROOT_PREFIX/usr/lib/libQtNetwork.so* $INSTALL/usr/lib
    cp -P $SYSROOT_PREFIX/usr/lib/libQtGui.so* $INSTALL/usr/lib
}
