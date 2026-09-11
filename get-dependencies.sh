#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake          \
    openal         \
    qt6-base       \
    qt6-tools      \
    sdl3           \
    sfml           \
    vulkan-headers \
    zip

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano ffmpeg-mini libdecor-mini x265-mini

echo "Building VisualBoyAdvance-M..."
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
      -DENABLE_QT=ON \
      -DENABLE_WX=OFF \
      -DENABLE_FFMPEG=TRUE \
      -DBUILD_TESTING=OFF
cmake --build build -j$(nproc)
cmake --install build
