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

PKG_NAME="ninja"
PKG_VERSION="1.6.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE=""
PKG_SITE="http://martine.github.io/ninja/"
PKG_URL="https://github.com/martine/ninja/archive/v$PKG_VERSION/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST=""
PKG_PRIORITY="optional"
PKG_SECTION="toolchain/devel"
PKG_SHORTDESC="ninja: Ninja is a small build system with a focus on speed."
PKG_LONGDESC="Ninja is a small build system with a focus on speed."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

export CC=$LOCAL_CC

make_host() {
  ./configure.py --bootstrap
}

makeinstall_host() {
  mkdir -p $ROOT/$TOOLCHAIN/bin
    cp ninja $ROOT/$TOOLCHAIN/bin
}
