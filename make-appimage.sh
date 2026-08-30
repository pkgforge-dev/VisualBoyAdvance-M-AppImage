#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q vbam-git | awk '{print $2; exit}')
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/visualboyadvance-m.svg
export DESKTOP=/usr/share/applications/visualboyadvance-m.desktop
export STARTUPWMCLASS=visualboyadvance-m
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1

# Deploy dependencies
quick-sharun /usr/bin/visualboyadvance-m

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --simple-test ./dist/*.AppImage
