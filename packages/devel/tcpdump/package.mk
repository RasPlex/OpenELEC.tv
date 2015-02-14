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

PKG_NAME="tcpdump"
PKG_VERSION="4.5.1"
PKG_REV=""
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="http://www.tcpdump.org/"
PKG_URL="https://github.com/the-tcpdump-group/tcpdump/archive/tcpdump-$PKG_VERSION.tar.gz"
PKG_DEPENDS_HOST="toolchain libpcap"
PKG_DEPENDS_TARGET="toolchain libpcap"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="Dump and trace packets"
PKG_LONGDESC="packet dump lib"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


unpack() {
	tar -xpf $ROOT/sources/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz -C $ROOT/$BUILD/
	mv $ROOT/$BUILD/$PKG_NAME-$PKG_NAME-$PKG_VERSION/ $ROOT/$BUILD/$PKG_NAME-$PKG_VERSION
	touch $ROOT/$BUILD/$PKG_NAME-$PKG_VERSION/.openelec-unpack
}

configure_target() {
	cd $ROOT/$PKG_BUILD
	autoconf
	ac_cv_linux_vers=2 $ROOT/$PKG_BUILD/configure --host=$TARGET_NAME \
            --target=$TARGET_NAME \
            --with-pcap=linux
}
