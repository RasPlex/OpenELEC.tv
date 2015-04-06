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
PKG_VERSION="368c899f5a1e2404e28fbbd1bca9218961cc193e"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://code.google.com/p/google-breakpad/"
PKG_URL="https://github.com/RasPlex/$PKG_NAME/archive/$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz https://linux-syscall-support.googlecode.com/svn/trunk/lss/linux_syscall_support.h"
PKG_DEPENDS_HOST="toolchain"
PKG_DEPENDS_TARGET="toolchain breakpad:host"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="breakpad: An open-source multi-platform crash reporting system"
PKG_LONGDESC="breakpad: An open-source multi-platform crash reporting system"

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_HOST="--enable-selftest"
PKG_CONFIGURE_OPTS_TARGET="--disable-processor --disable-tools"

post_unpack() {
  mkdir -p $PKG_BUILD/src/third_party/lss
  cp -PRf $SOURCES/$PKG_NAME/linux_syscall_support.h $PKG_BUILD/src/third_party/lss
}

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
}
