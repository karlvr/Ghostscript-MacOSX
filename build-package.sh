#!/bin/bash

if [ ! -d "cups" ]; then
	echo "Must run this script from inside the Ghostscript distribution being built"
	exit 1
fi

if [ ! -d "/opt/X11" ]; then
	echo "XQuartz is not installed"
	exit 1
fi

WD=${PWD##*/}
REV=${WD/ghostscript-/}
VERSION=${REV%-*}

PACKAGE_CONFIG="../Ghostscript.pkgproj"
/usr/local/bin/packagesutil --file "${PACKAGE_CONFIG}" set package-1 version "$VERSION"

if [ -d "jpeg" -a ! -h "jpeg" ]; then
	rm -r jpeg
fi
if [ -d "lcms" -a ! -h "lcms" ]; then
	rm -r lcms
fi
if [ -d "libpng" -a ! -h "libpng" ]; then
	rm -r libpng
fi
if [ -d "tiff" -a ! -h "tiff" ]; then
	rm -r tiff
fi

if [ ! -h "jpeg" ]; then
	brew install libjpeg && \
	curl -O http://www.ijg.org/files/jpegsrc.v8d.tar.gz && \
	tar zxf jpegsrc.v8d.tar.gz && \
	ln -s jpeg-8d jpeg && \
	pushd jpeg && \
	./configure --disable-shared && \
	make && \
	popd
fi

if [ ! -h "tiff" ]; then
	brew install libtiff && \
	curl -O http://download.osgeo.org/libtiff/tiff-4.0.3.tar.gz && \
	tar zxf tiff-4.0.3.tar.gz && \
	ln -s tiff-4.0.3 tiff && \
	pushd tiff && \
	./configure --disable-shared && \
	make && \
	popd	
fi

if [ ! -h "lcms" ]; then
	brew install lcms && \
	curl -OL http://sourceforge.net/projects/lcms/files/lcms/1.19/lcms-1.19.tar.gz && \
	tar zxf lcms-1.19.tar.gz && \
	ln -s lcms-1.19 lcms && \
	pushd lcms && \
	./configure --disable-shared && \
	make && \
	popd
fi

if [ ! -h "libpng" ]; then
	brew install libpng && \
	curl -OL http://downloads.sf.net/project/libpng/libpng15/older-releases/1.5.14/libpng-1.5.14.tar.gz && \
	tar zxf libpng-1.5.14.tar.gz && \
	ln -s libpng-1.5.14 libpng && \
	pushd libpng && \
	./configure --disable-shared && \
	make && \
	popd
fi


export PKG_CONFIG_PATH=/usr/X11/lib/pkgconfig

./configure --prefix=/opt/Ghostscript CFLAGS=-mmacosx-version-min=10.5 && \
sudo rm -rf /opt/Ghostscript && \
make && \
sudo make install

otool -L /opt/Ghostscript/bin/gs | grep "/usr/local" > /dev/null
if [ $? == 0 ]; then
	echo "*** FAIL gs links to /usr/local"
	exit 1
fi

/usr/local/bin/packagesbuild "${PACKAGE_CONFIG}"
#mv "../../build/Ghostscript.pkg" "../../build/Ghostscript-$REV.pkg"
/usr/bin/productsign --sign "Developer ID Installer" "../build/Ghostscript.pkg" "../build/Ghostscript-$REV.pkg"
/bin/rm "../build/Ghostscript.pkg"
/usr/bin/zip "../build/Ghostscript-$REV.pkg.zip" "../build/Ghostscript-$REV.pkg"
