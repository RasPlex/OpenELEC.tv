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

PKG_NAME="RasPlex-settings"
PKG_VERSION="rasplex-oe5"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="prop."
PKG_SITE="http://www.rasplex.com"
PKG_URL="https://github.com/RasPlex/service.openelec.settings/archive/$PKG_VERSION/service.openelec.settings-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python connman pygobject dbus-python"
PKG_PRIORITY="optional"
PKG_SECTION=""
PKG_SHORTDESC="RasPlex-settings: Settings dialog for RasPlex"
PKG_LONGDESC="RasPlex-settings: is a settings dialog for RasPlex"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

if [ "$DISPLAYSERVER" = "x11" ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET setxkbmap"
else
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET bkeymaps"
fi

unpack() {
  rm -rf $BUILD/$PKG_NAME-$PKG_VERSION
  mkdir -p $BUILD/$PKG_NAME-$PKG_VERSION
  tar xzf $SOURCES/$PKG_NAME/service.openelec.settings-$PKG_VERSION.tar.gz -C $BUILD/$PKG_NAME-$PKG_VERSION --strip-components=1
}

make_target() {
 : # nothing todo
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/share/XBMC/addons/service.openelec.settings
    cp -R * $INSTALL/usr/share/XBMC/addons/service.openelec.settings

  mkdir -p $INSTALL/usr/lib/openelec
    cp $PKG_DIR/scripts/* $INSTALL/usr/lib/openelec

#  # bluetooth is optional
#    if [ ! "$BLUETOOTH_SUPPORT" = yes ]; then
#      rm -f resources/lib/modules/bluetooth.py
#    fi

  python -Wi -t -B $ROOT/$TOOLCHAIN/lib/python2.7/compileall.py $INSTALL/usr/share/XBMC/addons/service.openelec.settings/resources/lib/ -f
  rm -rf `find $INSTALL/usr/share/XBMC/addons/service.openelec.settings/resources/lib/ -name "*.py"`

  python -Wi -t -B $ROOT/$TOOLCHAIN/lib/python2.7/compileall.py $INSTALL/usr/share/XBMC/addons/service.openelec.settings/oe.py -f
  rm -rf $INSTALL/usr/share/XBMC/addons/service.openelec.settings/oe.py
}

post_install() {
  enable_service backup-restore.service
  enable_service factory-reset.service
}
