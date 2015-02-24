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
PKG_VERSION="2a77b551c5b504f4ce9b0a179d4c20eaf6128f6b"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="OSS"
PKG_SITE="https://github.com/tvdzwan/hyperion"
PKG_URL="https://github.com/tvdzwan/hyperion/archive/$PKG_VERSION/hyperion-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="graphics"
PKG_SHORTDESC="hyperion: ambilent daemon"
PKG_LONGDESC="hyperion: samples video frames and drives an LED backlight ring to provide an ambient view of the image rendered"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

unpack() {
  rm -rf $BUILD/$PKG_NAME-$PKG_VERSION
  mkdir -p $BUILD/$PKG_NAME-$PKG_VERSION
  if [ -f $SOURCES/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz ]; then
    tar xzf $SOURCES/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz -C $BUILD/$PKG_NAME-$PKG_VERSION --strip-components=1
  else
    tar xzf $SOURCES/$PKG_NAME/service.openelec.settings-$PKG_VERSION.tar.gz -C $BUILD/$PKG_NAME-$PKG_VERSION --strip-components=1
  fi

}

hack() {
  oldpwd=`pwd`

  cd $ROOT/$BUILD/$PKG_NAME-$PKG_VERSION
  mkdir dist
  cd dist

  wget https://raw.githubusercontent.com/tvdzwan/hyperion/master/deploy/hyperion.tar.gz
  wget https://raw.githubusercontent.com/tvdzwan/hyperion/master/deploy/hyperion.deps.openelec-rpi.tar.gz
  tar -xvpf hyperion.tar.gz
  mkdir deps
  cd deps
  tar -xvpf ../hyperion.deps.openelec-rpi.tar.gz
  cd ..

  cd $oldpwd
}


configure_target() {
  echo "STUB"
}

make_target() {
  hack
}

makeinstall_target() {
  oldpwd=`pwd`

  cd $ROOT/$BUILD/$PKG_NAME-$PKG_VERSION/dist

  mkdir -p $INSTALL/usr/lib/
  mkdir -p $INSTALL/usr/bin/
  mkdir -p $INSTALL/usr/local/
  mkdir -p $INSTALL/etc/hyperion/

# copy the files
  cp deps/* $INSTALL/usr/lib/
  cp hyperion/bin/* $INSTALL/usr/bin/
  cp hyperion/effects/* $INSTALL/etc/hyperion/
  cp $PKG_DIR/config/hyperion.config.json $INSTALL/etc/
  cp $PKG_DIR/scripts/hyperion-wrapper $INSTALL/usr/local/

  cd $oldpwd
}

post_makeinstall_target() {
  echo "STUB"
}

post_install() {

# enable default services
  enable_service hyperion.service

}

