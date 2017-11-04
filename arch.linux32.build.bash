#!/bin/bash -ex

export CFLAGS="-m32"
export CXXFLAGS="-m32"
export HIDAPI_LDFLAGS="-lhidapi-libusb"
export LDFLAGS="-static -m32"

./clean.bash
rm -rf objdir

./libusb.linux32.build.bash
USE_LOCAL_LIBUSB=yes ./hidapi.linux32.build.bash
./openocd.linux32.build.bash

if [[ -f objdir/bin/openocd ]] ;
then
	strip --strip-all objdir/bin/openocd
	mv objdir/bin/openocd objdir/bin/openocd.bin
	cp launchers/openocd.linux objdir/bin/openocd
	chmod +x objdir/bin/openocd
fi

ARCH=`gcc -v 2>&1 | awk '/Target/ { print $2 }'`

rm -rf OpenOCD-0.9.0-dev-arduino
rm -f OpenOCD-0.9.0-dev-arduino-$ARCH.tar.bz2
mv objdir OpenOCD-0.9.0-dev-arduino
tar cfvj OpenOCD-0.9.0-dev-arduino-$ARCH.tar.bz2 OpenOCD-0.9.0-dev-arduino
