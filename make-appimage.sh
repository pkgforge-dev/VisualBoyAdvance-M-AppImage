#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/visualboyadvance-m/visualboyadvance-m/2d66d614555cd9093014e6fc5a0514061f0d9e88/src/art/vbam256.svg
export DESKTOP=/usr/share/applications/visualboyadvance-m-qt.desktop
export STARTUPWMCLASS=visualboyadvance-m-qt
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1
export APPNAME=VisualBoyAdvance-M

# Deploy dependencies
quick-sharun /usr/bin/visualboyadvance-m-qt /usr/lib/libopenal.so*

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --simple-test ./dist/*.AppImage
