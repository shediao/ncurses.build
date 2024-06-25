#!/usr/bin/env bash

script_dir="$(cd $(dirname $0) && pwd)"

build_dir="$script_dir/build"
install_dir="$script_dir/install"

rm -rf "$build_dir"
rm -rf "$install_dir"
mkdir -p "$build_dir"
mkdir -p "$install_dir"

export CC=$script_dir/gcc-11.2.0/bin/gcc
export CXX=$script_dir/gcc-11.2.0/bin/g++
export CFLAGS="-static-libgcc"
export CXXFLAGS="-static-libstdc++"
export LDFLAGS="-static-libgcc -static-libstdc++"

run() { echo "$*"; "$@"; }

cd "$build_dir" || exit 1
../configure \
  --prefix="$install_dir" \
  --with-termlib \
  --with-fallbacks="unknown,xterm,xterm-256color,vt100,vt340,vt400,screen,screen-256color,rxvt,rxvt-256color,iTerm.app,iTerm2.app" \
  --without-ada \
  --without-cxx \
  --without-cxx-binding \
  --disable-db-install \
  --without-manpages \
  --without-progs \
  --without-tests \
  --without-curses-h \
  --with-build-cc=$CC \
  --with-build-cflags="$CFLAGS" \
  --with-build-ldflags="$LDFLAGS" \
  --without-shared \
  --with-normal \
  --without-debug \
  --without-profile \
  --without-cxx-shared \
  --disable-database || exit 1

  #--enable-widec \

run make -j $(nproc --all) || exit 1

run make install || exit 1

