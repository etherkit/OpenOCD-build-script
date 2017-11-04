#!/bin/bash -ex

#if [[ ! -f libusb-compat-0.1.4.tar.bz2 ]] ;
#if [[ ! -f v0.1.6-rc2.tar.gz ]] ;
if [[ ! -d libusb-compat-0.1 ]] ;
then
	#wget http://downloads.sourceforge.net/project/libusb/libusb-compat-0.1/libusb-compat-0.1.4/libusb-compat-0.1.4.tar.bz2
    #wget https://github.com/libusb/libusb-compat-0.1/archive/v0.1.6-rc2.tar.gz
    git clone https://github.com/etherkit/libusb-compat-0.1.git
fi

#tar xfv libusb-compat-0.1.4.tar.bz2
#tar xfv v0.1.6-rc2.tar.gz

#cd libusb-compat-0.1-0.1.6-rc2
cd libusb-compat-0.1
./bootstrap.sh
cd -

mkdir -p objdir
cd objdir
PREFIX=`pwd`
cd -

mkdir -p libusb-compat-build
cd libusb-compat-build

#../libusb-compat-0.1.4/configure \
../libusb-compat-0.1/configure \
	LIBUSB_1_0_CFLAGS=-I${PREFIX}/include/libusb-1.0 \
	LIBUSB_1_0_LIBS="-L${PREFIX}/lib -lusb-1.0" \
	--prefix=$PREFIX \
    --build=i686-pc-linux-gnu --host=i686-w64-mingw32

#	--disable-shared \

if [ -z "$MAKE_JOBS" ]; then
	MAKE_JOBS="4"
fi

nice -n 10 make -j $MAKE_JOBS

make install

