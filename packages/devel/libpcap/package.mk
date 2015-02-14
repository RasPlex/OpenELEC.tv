################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="libpcap"
PKG_VERSION="1.3.0"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.tcpdump.org/"
PKG_URL="http://www.tcpdump.org/release/libpcap-${PKG_VERSION}.tar.gz"
PKG_DEPENDS="toolchain"
PKG_DEPENDS_TARGET="toolchain libusb"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="system interface for user-level packet capture"
PKG_LONGDESC="libpcap (Packet CAPture) provides a portable framework for low-level network monitoring. Applications include network statistics collection, security monitoring, network debugging, etc."
PKG_IS_ADDON="no"

PKG_AUTORECONF="yes"


configure_target() {
  sed -i -e 's/ac_cv_linux_vers=unknown/ac_cv_linux_vers=2/' $ROOT/$PKG_BUILD/configure

  LIBS="-lpthread" \
  ac_cv_header_libusb_1_0_libusb_h=no \
  $ROOT/$PKG_BUILD/configure \
         --host=$TARGET_NAME \
         --build=$HOST_NAME \
         --prefix=/usr \
         --disable-shared \
         --with-pcap=linux \
         --disable-bluetooth \
         --disable-can \
         --disable-canusb
}
