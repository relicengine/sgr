#!/bin/bash

#pacman -S --needed base-devel mingw-w64-x86_64-toolchain msys2-devel msys2-runtime-devel

wget https://ftp.gnu.org/gnu/binutils/binutils-2.28.tar.gz
tar -xf binutils-2.28.tar.gz
mkdir build
cd build
mkdir binutils-2.28
cd binutils-2.28
../../binutils-2.28/configure --prefix=/home/Matthew/tools/m68k-elf-toolchain --target=m68k-elf --disable-werror --disable-nls --disable-threads --disable-multilib --enable-libssp --enable-lto --enable-languages=c --program-prefix=m68k-elf-
make -j 12
make install
cd ..
mkdir gcc-6.5.0
cd ..
wget https://gcc.gnu.org/pub/gcc/releases/gcc-6.5.0/gcc-6.5.0.tar.gz
tar -xf gcc-6.5.0.tar.gz
cd gcc-6.5.0
./contrib/download_prerequisites
cd ..
cd m68k-elf-toolchain
cd bin
export PATH=$(pwd):$PATH
cd ..
cd ..
cd build
cd gcc-6.5.0
../../gcc-6.5.0/configure --prefix=/home/Matthew/tools/m68k-elf-toolchain --target=m68k-elf --program-prefix=m68k-elf- --enable-languages=c --enable-obsolete --enable-lto --disable-threads --disable-libmudflap --disable-libgomp --disable-nls --disable-werror --disable-libssp --disable-shared --disable-multilib --disable-libgcj --disable-libstdcxx --disable-gcov --without-headers --without-included-gettext --with-cpu=m68000
make -j 12
make install
