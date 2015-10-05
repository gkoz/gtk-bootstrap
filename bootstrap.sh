#!/bin/sh

set -e
set -u

MANIFEST="$1"

WD="$PWD"
BUILD="$WD/build"
PREFIX="$WD/local"

#export CPPFLAGS="-I$PREFIX/include"
#export LDFLAGS="-I$PREFIX/lib"
export LD_LIBRARY_PATH="$PREFIX/lib"
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
	make
	make install
}

for LIB in `cat "$MANIFEST"`; do
	echo Building "$LIB"...
	build "$LIB"
done
