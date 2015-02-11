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

PKG_NAME="breakpad"
PKG_VERSION="master-update"
PKG_REV=""
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://code.google.com/p/google-breakpad/"
PKG_URL="https://github.com/plexinc/$PKG_NAME/archive/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz https://github.com/plexinc/breakpad-lss/archive/master/breakpad-lss-master.tar.gz"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain breakpad:host"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="breakpad: An open-source multi-platform crash reporting system"
PKG_LONGDESC="breakpad: An open-source multi-platform crash reporting system"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

unpack() {
  mkdir -p $BUILD/$PKG_NAME-$PKG_VERSION
  ls -al $SOURCES/$PKG_NAME/$PKG_NAME-*.tar.gz
  tar xzf $SOURCES/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz -C $BUILD/$PKG_NAME-$PKG_VERSION --strip-components=1
  tar xzf $SOURCES/$PKG_NAME/breakpad-lss-master.tar.gz -C $BUILD/$PKG_NAME-$PKG_VERSION/src/third_party/lss --strip-components=1
}

make_host() {
  make $PKG_MAKE_OPTS_TARGET
}

make_target() {
  make $PKG_MAKE_OPTS_TARGET
}

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC"
  export CXXFLAGS="$CXXFLAGS -fPIC"
  export LDFLAGS="$LDFLAGS -fPIC"
}

configure_target() {
if [ $PROJECT = "RPi" -o $PROJECT = "RPi2" ]; then
  cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
		-DCMAKE_PREFIX_PATH="$SYSROOT_PREFIX" \
		-DCMAKE_LIBRARY_PATH="$SYSROOT_PREFIX/usr/lib" \
		-DCMAKE_INCLUDE_PATH="$SYSROOT_PREFIX/usr/include;$SYSROOT_PREFIX/usr/include/interface/vmcs_host/linux;$SYSROOT_PREFIX/usr/include/interface/vcos/pthreads" \
		-DCMAKE_INSTALL_PREFIX=/usr \
		..
else
  cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
		-DCMAKE_PREFIX_PATH="$SYSROOT_PREFIX" \
		-DCMAKE_LIBRARY_PATH="$SYSROOT_PREFIX/usr/lib" \
		-DCMAKE_INCLUDE_PATH="$SYSROOT_PREFIX/usr/include" \
		-DCMAKE_INSTALL_PREFIX=/usr \
		..
fi
}

post_makeinstall_target() {
  cd ../src/client/linux
  find -type f -name \*.h -exec install -D {} $SYSROOT_PREFIX/usr/include/breakpad/client/linux/{} \;
}
