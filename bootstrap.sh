#!/bin/sh

set -e
set -u

MANIFEST="$1"

WD="$PWD"
BUILD="$WD/build"
PREFIX="$WD/local"

export CPPFLAGS="-I$PREFIX/include"
export LD_LIBRARY_PATH="$PREFIX/lib"
export LDFLAGS="-I$PREFIX/lib"
export PATH="$PREFIX/bin:$PATH"
export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig"

mkdir -p "$PREFIX"

build() {
	rm -rf "$BUILD"
	mkdir "$BUILD"
	cd "$BUILD"
	curl -L "$1" > dist.x
	tar -xf dist.x --strip-components=1
	rm dist.x
	./configure --prefix="$PREFIX"
	make -j2
	make install
	cd "$WD"
}

for LIB in `cat "$MANIFEST"`; do
	echo
	echo '*************************************************************************************'
	echo "* Building $LIB"
	echo '*************************************************************************************'
	echo
	build "$LIB"
done
