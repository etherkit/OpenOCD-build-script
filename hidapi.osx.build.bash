#!/bin/bash -ex

if [[ ! -d hidapi ]] ;
then
	git clone git://github.com/arduino/hidapi.git
fi

cd hidapi
./bootstrap
cd -

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p hidapi-build
cd hidapi-build

if [[ x$USE_LOCAL_LIBUSB == xyes ]];
then
	CC=o32-clang ../hidapi/configure --prefix=$PREFIX \
		libusb_CFLAGS="-I${PREFIX}/include/libusb-1.0" \
		libusb_LIBS="-L${PREFIX}/lib -lusb-1.0" \
		--enable-static --disable-shared \
		--build=i686-pc-linux-gnu --host=i386-apple-darwin15
else
	CC=o32-clang ../hidapi/configure --prefix=$PREFIX \
		--enable-static --disable-shared \
		--build=i686-pc-linux-gnu --host=i386-apple-darwin15
fi

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="2"
fi

nice -n 10 make -j $MAKE_JOBS

make install
