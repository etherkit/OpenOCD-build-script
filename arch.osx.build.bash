#!/bin/bash -ex

export CFLAGS="-m64"
export CXXFLAGS="-m64"
#export HIDAPI_LDFLAGS="-lhidapi-libusb"
export HIDAPI_LDFLAGS="-lhidapi"
#export LDFLAGS="-L../lib"

./clean.bash
rm -rf objdir

./libusb.osx.build.bash
USE_LOCAL_LIBUSB=yes ./hidapi.osx.build.bash
./openocd.osx.build.bash

if [[ -f objdir/bin/openocd ]] ;
then
	x86_64-apple-darwin15-strip objdir/bin/openocd
	mv objdir/bin/openocd objdir/bin/openocd.bin
	cp launchers/openocd.linux objdir/bin/openocd
	chmod +x objdir/bin/openocd
fi

ARCH=`gcc -v 2>&1 | awk '/Target/ { print $2 }'`

rm -rf OpenOCD-0.9.0-dev-arduino
rm -f OpenOCD-0.9.0-dev-arduino-$ARCH.tar.bz2
mv objdir OpenOCD-0.9.0-dev-arduino
tar cfvj OpenOCD-0.9.0-dev-arduino-$ARCH.tar.bz2 OpenOCD-0.9.0-dev-arduino
