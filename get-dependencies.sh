#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake          \
    gettext        \
    libxss         \
    openal         \
    sdl3           \
    sfml           \
    wxwidgets-gtk3

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ffmpeg-mini libdecor-mini

# Comment this out if you need an AUR package
#PRE_BUILD_CMDS='sed -i "s/-Wno-dev)/-Wno-dev\\n              -DCMAKE_CXX_FLAGS=\\"-Wno-error=attributes\\")/" ./PKGBUILD' make-aur-package vbam-git

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
#
# if [ "${DEVEL_RELEASE-}" = 1 ]; then
# 	nightly build steps
# else
# 	regular build steps
# fi
echo "Building Visual Boy Advance - M..."
echo "---------------------------------------------------------------"
REPO="https://github.com/visualboyadvance-m/visualboyadvance-m"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --depth 1 "$REPO" ./visualboyadvance-m
echo "$VERSION" > ~/version

cmake -B build -S ./visualboyadvance-m \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_INSTALL_SYSCONFDIR=/etc \
      -DCMAKE_SKIP_RPATH=TRUE \
      -DENABLE_FFMPEG=TRUE \
      -DBUILD_TESTING=OFF
cmake --build build -j$(nproc)
cmake --install build
