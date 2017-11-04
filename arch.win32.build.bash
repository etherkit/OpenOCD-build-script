#!/bin/bash -ex

export CFLAGS="-m32 -mno-ms-bitfields"
export CXXFLAGS="-m32"
export HIDAPI_LDFLAGS=-lhidapi
export LDFLAGS="-static"

./clean.bash
rm -rf objdir

./libusb.win32.build.bash
./libusb-compat-0.1.win32.build.bash
USE_LOCAL_LIBUSB=yes ./hidapi.win32.build.bash
USE_LOCAL_LIBUSB=yes ./openocd.win32.build.bash

if [[ -f objdir/bin/openocd.exe ]] ;
then
	strip --strip-all objdir/bin/openocd.exe
fi

ARCH=`gcc -v 2>&1 | awk '/Target/ { print $2 }'`

rm -rf OpenOCD-0.9.0-dev-arduino
rm -f OpenOCD-0.9.0-dev-arduino-$ARCH.tar.bz2
mv objdir OpenOCD-0.9.0-dev-arduino
tar cfvj OpenOCD-0.9.0-dev-arduino-$ARCH.tar.bz2 OpenOCD-0.9.0-dev-arduino

