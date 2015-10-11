#!/bin/sh

set -e
set -u
set -x

exec 0< /dev/null

MANIFEST="$1"

WD="$PWD"
BUILD="$WD/build"
PREFIX="$HOME/local"

export CPPFLAGS="-I$PREFIX/include"
export LD_LIBRARY_PATH="$PREFIX/lib"
export LDFLAGS="-L$PREFIX/lib"
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
	CFG_ARGS=`echo "$1" | awk ' \
		/dlfcn-win32/ { print "--enable-shared" } \
	'`
	if [ -x configure ]; then
		./configure --prefix="$PREFIX" $CFG_ARGS
	else
		./autogen.sh --prefix="$PREFIX" $CFG_ARGS
	fi
	make -j2
	make install
	cd "$WD"
}

for LIB in `cat "$WD/$MANIFEST"`; do
	echo
	echo '*************************************************************************************'
	echo "* Building $LIB"
	echo '*************************************************************************************'
	echo
	build "$LIB"
done

cd "$PREFIX/.."
tar cJf "$WD/deps.txz" local
