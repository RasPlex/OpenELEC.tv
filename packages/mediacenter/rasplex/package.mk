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

PKG_NAME="rasplex"
PKG_VERSION="rasplex-dev-oe5"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://www.rasplex.com"
PKG_URL="https://github.com/RasPlex/plex-home-theatre/archive/$PKG_VERSION/rasplex-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain ninja:host boost Python zlib bzip2 systemd pciutils lzo pcre swig:host libass enca curl rtmpdump fontconfig fribidi tinyxml libjpeg-turbo libpng tiff freetype jasper libogg libcdio libmodplug libmpeg2 taglib libxml2 libxslt yajl sqlite libvorbis ffmpeg libshairplay libsamplerate flac SDL_mixer lame breakpad"
PKG_DEPENDS_HOST="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="mediacenter"
PKG_SHORTDESC="rasplex: The Plex Home Theater port for the Raspberry Pi mini computer"
PKG_LONGDESC="Simply put, RasPlex lets you turn your TV into a Smart TV. Similar to the AppleTV, but completely free and open source, RasPlex is basically a set-top box that lets you play content from your computer or smartphone to your TV."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

# configure GPU drivers and dependencies:
  get_graphicdrivers

# for dbus support
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET dbus"

# needed for hosttools (Texturepacker)
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET lzo:host SDL:host SDL_image:host rasplex:host"

if [ "$DISPLAYSERVER" = "x11" ]; then
# for libX11 support
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libX11 libXext libdrm"
# for libXrandr support
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libXrandr"
fi

if [ ! "$OPENGL" = "no" ]; then
# for OpenGL (GLX) support
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $OPENGL glu glew"
fi

if [ "$OPENGLES_SUPPORT" = yes ]; then
# for OpenGL-ES support
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $OPENGLES"
fi

if [ "$SDL_SUPPORT" = yes ]; then
# for SDL support
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET SDL2"
fi

if [ "$ALSA_SUPPORT" = yes ]; then
# for ALSA support
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET alsa-lib"
fi

if [ "$PULSEAUDIO_SUPPORT" = yes ]; then
# for PulseAudio support
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET pulseaudio"
fi

if [ "$ESPEAK_SUPPORT" = yes ]; then
# for espeak support
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET espeak"
fi

if [ "$CEC_SUPPORT" = yes ]; then
# for CEC support
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libcec"
fi

if [ "$KODI_SCR_RSXS" = yes ]; then
# for RSXS Screensaver support
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libXt libXmu"
# fix build of RSXS Screensaver support if not using libiconv
  export jm_cv_func_gettimeofday_clobber=no
fi

if [ "$FAAC_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET faac"
fi

if [ "$KODI_BLURAY_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libbluray"
fi

if [ "$AVAHI_DAEMON" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET avahi nss-mdns"
fi

if [ "$KODI_MYSQL_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET mysql"
fi

if [ "$KODI_AIRPLAY_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libplist"
fi

if [ "$KODI_AIRTUNES_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libshairplay"
fi

if [ "$KODI_NFS_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libnfs"
fi

if [ "$KODI_SAMBA_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET samba"
fi

if [ "$KODI_WEBSERVER_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libmicrohttpd"
fi

if [ "$KODI_SSHLIB_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libssh"
fi

if [ ! "$KODIPLAYER_DRIVER" = default ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET $KODIPLAYER_DRIVER"

  if [ "$KODIPLAYER_DRIVER" = bcm2835-driver ]; then
    BCM2835_INCLUDES="-I$SYSROOT_PREFIX/usr/include/interface/vcos/pthreads/ \
                      -I$SYSROOT_PREFIX/usr/include/interface/vmcs_host/linux"
    KODI_CFLAGS="$KODI_CFLAGS $BCM2835_INCLUDES"
    KODI_CXXFLAGS="$KODI_CXXFLAGS $BCM2835_INCLUDES"
  fi
fi

if [ "$VDPAU_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libvdpau"
fi

if [ "$VAAPI_SUPPORT" = yes ]; then
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET libva-intel-driver"
fi

export CXX_FOR_BUILD="$HOST_CXX"
export CC_FOR_BUILD="$HOST_CC"
export CXXFLAGS_FOR_BUILD="$HOST_CXXFLAGS"
export CFLAGS_FOR_BUILD="$HOST_CFLAGS"
export LDFLAGS_FOR_BUILD="$HOST_LDFLAGS"

export PYTHON_VERSION="2.7"
export PYTHON_CPPFLAGS="-I$SYSROOT_PREFIX/usr/include/python$PYTHON_VERSION"
export PYTHON_LDFLAGS="-L$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION -lpython$PYTHON_VERSION"
export PYTHON_SITE_PKG="$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION/site-packages"
export ac_python_version="$PYTHON_VERSION"

unpack() {
  mkdir -p $BUILD/$PKG_NAME-$PKG_VERSION
  tar xzf $SOURCES/$PKG_NAME/$PKG_NAME-$PKG_VERSION.tar.gz -C $BUILD/$PKG_NAME-$PKG_VERSION --strip-components=1
}

configure_host() {
  cmake -G Ninja ../tools/TexturePacker
}

make_host() {
  ninja
}

makeinstall_host() {
  cp -PR TexturePacker $ROOT/$TOOLCHAIN/bin
}

pre_configure_target() {
# kodi fails to build with LTO optimization if build without GOLD support
  [ ! "$GOLD_SUPPORT" = "yes" ] && strip_lto

# Todo: kodi segfaults on exit when building with LTO support
  strip_lto

  export CFLAGS="$CFLAGS $KODI_CFLAGS -g"
  export CXXFLAGS="$CXXFLAGS $KODI_CXXFLAGS -g"
  export LIBS="$LIBS -lz"
}

configure_target() {
# dont use some optimizations because of build problems
  LDFLAGS=`echo $LDFLAGS | sed -e "s|-Wl,--as-needed||"`

# strip compiler optimization
  strip_lto

# configure the build
  export PKG_CONFIG_PATH=$SYSROOT_PREFIX/usr/lib/pkgconfig
  
if [ "$OPENELEC_VERSION" = devel ]; then
    CMAKE_BUILD_TYPE="Debug"
else
    CMAKE_BUILD_TYPE="Release"
fi

if [ $PROJECT = "RPi" -o $PROJECT = "RPi2" ]; then
  export PYTHON_EXEC="$SYSROOT_PREFIX/usr/bin/python2.7"
  cmake -G Ninja -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
        -DENABLE_PYTHON=ON \
        -DEXTERNAL_PYTHON_HOME="$SYSROOT_PREFIX/usr" \
        -DPYTHON_EXEC="$PYTHON_EXEC" \
        -DSWIG_EXECUTABLE=`which swig` \
        -DSWIG_DIR="$ROOT/$BUILD/toolchain" \
        -DCMAKE_PREFIX_PATH="$SYSROOT_PREFIX" \
        -DCMAKE_LIBRARY_PATH="$SYSROOT_PREFIX/usr/lib" \
        -DCMAKE_INCLUDE_PATH="$SYSROOT_PREFIX/usr/include;$SYSROOT_PREFIX/usr/include/interface/vmcs_host/linux;$SYSROOT_PREFIX/usr/include/interface/vcos/pthreads;$SYSROOT_PREFIX/usr/include/python2.7;$SYSROOT_PREFIX/usr/lib/dbus-1.0/include" \
        -DCOMPRESS_TEXTURES=OFF \
        -DENABLE_DUMP_SYMBOLS=ON \
        -DENABLE_AUTOUPDATE=ON \
        -DTARGET_PLATFORM=RPI \
        -DRPI_PROJECT=$PROJECT \
        -DCMAKE_INSTALL_PREFIX=/usr/lib/plexht \
        -DCMAKE_BUILD_TYPE=$CMAKE_BUILD_TYPE \
        ..
else
  exit 1
fi
}

make_target() {
# setup skin dir from default skin
  SKIN_DIR="skin.`tolower $SKIN_DEFAULT`"

# setup default skin inside the sources
  sed -i -e "s|skin.confluence|$SKIN_DIR|g" $ROOT/$PKG_BUILD/xbmc/settings/Settings.h

  ninja -j$CONCURRENCY_MAKE_LEVEL

# generate breakpad symbols
  ninja plex/CMakeFiles/PlexHomeTheater_symbols

# Strip the executable now that we have our breakpad symbols
  $STRIP plex/plexhometheater
}

makeinstall_target() {
  DESTDIR=$INSTALL ninja install

  rm -rf $INSTALL/usr/lib/plexht/bin/lib
  rm -rf $INSTALL/usr/lib/plexht/bin/include
  rm -rf $INSTALL/usr/lib/plexht/bin/*.so
  mv -f $INSTALL/usr/lib/plexht/bin/* $INSTALL/usr/lib/plexht/
  rm -rf $INSTALL/usr/lib/plexht/bin
  mkdir -p $INSTALL/usr/share/XBMC
  mv -f $INSTALL/usr/lib/plexht/share/XBMC/* $INSTALL/usr/share/XBMC/
  mkdir -p $INSTALL/usr/lib/plexht/addons

  mkdir -p $INSTALL/usr/lib/plexht
    cp $PKG_DIR/scripts/plexht-config $INSTALL/usr/lib/plexht
    cp $PKG_DIR/scripts/plexht-hacks $INSTALL/usr/lib/plexht
    cp $PKG_DIR/scripts/plexht-sources $INSTALL/usr/lib/plexht

  mkdir -p $INSTALL/usr/lib/openelec
    cp $PKG_DIR/scripts/systemd-addon-wrapper $INSTALL/usr/lib/openelec

  mkdir -p $INSTALL/usr/bin
    cp $PKG_DIR/scripts/cputemp $INSTALL/usr/bin
      ln -sf cputemp $INSTALL/usr/bin/gputemp
    cp $PKG_DIR/scripts/setwakeup.sh $INSTALL/usr/bin
    cp ../tools/EventClients/Clients/XBMC\ Send/xbmc-send.py $INSTALL/usr/bin/xbmc-send

  if [ ! "$KODI_SCR_RSXS" = yes ]; then
    rm -rf $INSTALL/usr/share/XBMC/addons/screensaver.rsxs.*
  fi

  if [ ! "$KODI_VIS_PROJECTM" = yes ]; then
    rm -rf $INSTALL/usr/share/XBMC/addons/visualization.projectm
  fi

  rm -rf $INSTALL/usr/share/applications
  rm -rf $INSTALL/usr/share/icons
  rm -rf $INSTALL/usr/share/XBMC/addons/service.xbmc.versioncheck
  rm -rf $INSTALL/usr/share/xsessions

  mkdir -p $INSTALL/usr/share/XBMC/addons
    cp -R $PKG_DIR/config/os.openelec.tv $INSTALL/usr/share/XBMC/addons
    $SED "s|@OS_VERSION@|$OS_VERSION|g" -i $INSTALL/usr/share/XBMC/addons/os.openelec.tv/addon.xml
	
# fix skin.plex
  mv $INSTALL/usr/share/XBMC/addons/skin.plex/Colors $INSTALL/usr/share/XBMC/addons/skin.plex/colors
  mv $INSTALL/usr/share/XBMC/addons/skin.plex/Sounds $INSTALL/usr/share/XBMC/addons/skin.plex/sounds
  mv $INSTALL/usr/share/XBMC/addons/skin.plex/Media $INSTALL/usr/share/XBMC/addons/skin.plex/media
  TexturePacker -input $INSTALL/usr/share/XBMC/addons/skin.plex/media/ \
                -output Textures.xbt \
                -dupecheck \
                -use_none
  rm -rf $INSTALL/usr/share/XBMC/addons/skin.plex/media
  mkdir -p $INSTALL/usr/share/XBMC/addons/skin.plex/media
    cp Textures.xbt $INSTALL/usr/share/XBMC/addons/skin.plex/media

  mkdir -p $INSTALL/usr/lib/python"$PYTHON_VERSION"/site-packages/xbmc
    cp -R ../tools/EventClients/lib/python/* $INSTALL/usr/lib/python"$PYTHON_VERSION"/site-packages/xbmc

# install project specific configs
  mkdir -p $INSTALL/usr/share/XBMC/config
    if [ -f $PROJECT_DIR/$PROJECT/rasplex/guisettings.xml ]; then
      cp -R $PROJECT_DIR/$PROJECT/rasplex/guisettings.xml $INSTALL/usr/share/XBMC/config
    fi

    if [ -f $PROJECT_DIR/$PROJECT/rasplex/sources.xml ]; then
      cp -R $PROJECT_DIR/$PROJECT/rasplex/sources.xml $INSTALL/usr/share/XBMC/config
    fi

  mkdir -p $INSTALL/usr/share/XBMC/system/
    if [ -f $PROJECT_DIR/$PROJECT/rasplex/advancedsettings.xml ]; then
      cp $PROJECT_DIR/$PROJECT/rasplex/advancedsettings.xml $INSTALL/usr/share/XBMC/system/
    else
      cp $PKG_DIR/config/advancedsettings.xml $INSTALL/usr/share/XBMC/system/
    fi

  if [ "$KODI_EXTRA_FONTS" = yes ]; then
    mkdir -p $INSTALL/usr/share/XBMC/media/Fonts
      cp $PKG_DIR/fonts/*.ttf $INSTALL/usr/share/XBMC/media/Fonts
  fi
}

post_install() {
# link default.target to plexht.target
  ln -sf plexht.target $INSTALL/usr/lib/systemd/system/default.target

# for compatibility
  ln -sf plexht.target $INSTALL/usr/lib/systemd/system/kodi.target
  ln -sf plexht.service $INSTALL/usr/lib/systemd/system/kodi.service
  ln -sf plexht.target $INSTALL/usr/lib/systemd/system/xbmc.target
  ln -sf plexht.service $INSTALL/usr/lib/systemd/system/xbmc.service

# enable default services
  enable_service plexht-autostart.service
  enable_service plexht-cleanlogs.service
  enable_service plexht-hacks.service
  enable_service plexht-sources.service
  enable_service plexht-halt.service
  enable_service plexht-poweroff.service
  enable_service plexht-reboot.service
  enable_service plexht-waitonnetwork.service
  enable_service plexht.service
  enable_service plexht-lirc-suspend.service
}
