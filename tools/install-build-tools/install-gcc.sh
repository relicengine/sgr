#!/bin/bash

###################################################################
# Global Variables
###################################################################
# Toolchain name
GCC_TOOLCHAIN_NAME="m68k-elf-toolchain"

# Install paths
GCC_PREFIX="$(pwd)/${GCC_TOOLCHAIN_NAME}"

# OS variables
IS_WINDOWS="false"
IS_MACOS="false"
IS_LINUX="false"

# Others
LIBGCC="gcc-6.5.0"
LIBGCC_ARCHIVE="$LIBGCC.tar.gz"
LIBGCC_LINK="https://gcc.gnu.org/pub/gcc/releases/gcc-6.5.0/$LIBGCC_ARCHIVE"
TARGET="m68k-elf"
NPROC="6" #Change this to build GCC with more or less CPU cores!
SHELL_PATH="/bin/bash"

# Determine OS type
if echo "${OSTYPE}" | grep -q "cygwin"; then
    IS_WINDOWS="true"
elif echo "${OSTYPE}" | grep -q "darwin"; then
    IS_MACOS="true"
elif echo "${OSTYPE}" | grep -q "linux"; then
    IS_LINUX="true"
else
    echo "Your Operating System does not seem to be supported by SGR. Quitting."
    exit
fi

# Prepare macOS Variables (Assumes GCC is installed using brew package manager)
if [ "${IS_MACOS}" = "true" ]; then
    export CC=/usr/local/bin/gcc-11
    export CXX=/usr/local/bin/g++-11
    export CPP=/usr/local/bin/cpp-11
    export LD=/usr/local/bin/gcc-11
    alias c++=/usr/local/bin/c++-11
    alias g++=/usr/local/bin/g++-11
    alias gcc=/usr/local/bin/gcc-11
    alias cpp=/usr/local/bin/cpp-11
    alias ld=/usr/local/bin/gcc-11
    alias cc=/usr/local/bin/gcc-11
    SHELL_PATH="$(brew --prefix)/bin/bash"
fi


###################################################################
# Warning Message
###################################################################
echo "
WARNING: This script is used to build the compiler tools for the SGR.
By default, these build tools were already built on a computer with the proper 
enviroment and prerequisites. Do not try to run this script unless you have 
experience building compiler toolchains. Otherwise, it my render the SGR useless.
------------------------------------------------------------------------------"
echo "Do you wish to continue running this script? (y/n)"
read YES_NO
if [ "${YES_NO}" != "y" ]; then
    exit 
fi
echo ""


###################################################################
# Output Required Prerequisites for OS
###################################################################
echo "Prerequisites for ${OSTYPE}:"

# Prerequisites
if [ "${IS_WINDOWS}" = "true" ]; then
    echo -e "\t1. 64-bit version of Windows. Preferably Windows 10 but may work on other versions."
    echo -e "\t2. Cygwin 32-bit and/or 64-bit version depending on which architecture you want to build for."
    echo -e "\t3. Install wget on Cygwin through the installer."
    echo -e "\t4. Download apt-cyg: wget https://raw.githubusercontent.com/transcode-open/apt-cyg/master/apt-cyg."
    echo -e "\t5. Instal apt-cyg: install apt-cyg /bin."
    echo -e "\t6. Install prerequisites: apt-cyg install gcc-core gcc-g++ python git perl-Pod-Simple gperf patch automake make makedepend bison flex libncurses-devel python-devel gettext-devel libgmp-devel libmpc-devel libmpfr-devel rsync."
elif [ "${IS_MACOS}" = "true" ]; then
    echo -e "\t1. Xcode command line tools. (xcode-select --install)"
    echo -e "\t2. Brew package manager: https://brew.sh/."
    echo -e "\t3. wget command. Installed easiest through Homebrew. (brew install wget)"
    echo -e "\t4. Install prerequisites: brew install bash wget make lhasa gmp mpfr libmpc flex gettext gnu-sed texinfo gcc@11 make autoconf"
else
    echo -e "\tUbuntu: Install prerequisites: sudo apt install make wget git gcc g++ lhasa libgmp-dev libmpfr-dev libmpc-dev flex bison gettext texinfo ncurses-dev autoconf rsync libreadline-dev"
    echo -e "\tCentOS: Install prerequisites: sudo yum install wget gcc gcc-c++ python git perl-Pod-Simple gperf patch autoconf automake make makedepend bison flex ncurses-devel gmp-devel mpfr-devel libmpc-devel gettext-devel texinfo rsync readline-devel"
    echo -e "\tFedora: Install prerequisites: sudo dnf install wget gcc gcc-c++ python git perl-Pod-Simple gperf patch autoconf automake make makedepend bison flex ncurses-devel gmp-devel mpfr-devel libmpc-devel gettext-devel texinfo rsync readline-devel"
fi

# Final Warning
echo ""
echo "NOTE: These are only basic prerequisites. Knowledge of building compilers is required before running this script."
echo "Do you wish to continue running this script? (y/n)"
read YES_NO
if [ "${YES_NO}" != "y" ]; then 
    exit 
fi
echo ""


###################################################################
# Create Folders for Builds
###################################################################
mkdir -p "${GCC_TOOLCHAIN_NAME}"


###################################################################
# Download, Build and Install GCC and Binutils
###################################################################
git clone https://github.com/RetroRevivalGames/amiga-gcc
cd amiga-gcc
make -j "$NPROC" update binutils_BRANCH=devel1
make -j "$NPROC" gcc PREFIX="${GCC_PREFIX}" SHELL="${SHELL_PATH}" TARGET="$TARGET"
cd ..


###################################################################
# Download, Build and Install LIBGCC
###################################################################
if ! [ -f "$LIBGCC_ARCHIVE" ]; then
    wget "$LIBGCC_LINK"
fi
tar -xf "$LIBGCC_ARCHIVE"
if [ "${IS_MACOS}" = "true" ]; then
    cd "$LIBGCC"
    ./contrib/download_prerequisites
    cd ..
fi
mkdir -p "build/$LIBGCC"
cd "build/$LIBGCC"
"../../$LIBGCC/configure" --prefix="${GCC_PREFIX}" --target="$TARGET" --with-cpu=m68000 --enable-languages=c,c++,objc --enable-version-specific-runtime-libs --disable-libssp --disable-nls --disable-shared --disable-multilib
make -j "$NPROC" all-target-libgcc
make install-target-libgcc
cd "${GCC_PREFIX}/lib/gcc/$TARGET"
cp "6.5.0/libgcc.a" "6.5.0b"
rm -rf "6.5.0"
cd ../../../..
#make -j "$NPROC" all-target-libgcc CFLAGS_FOR_TARGET='-mregparm=4' CXXFLAGS_FOR_TARGET='-mregparm=4' GCC_FOR_TARGET="$GCC_PREFIX/bin/m68k-elf-gcc" CC_FOR_TARGET="$GCC_PREFIX/bin/m68k-elf-gcc" CXX_FOR_TARGET="$GCC_PREFIX/bin/m68k-elf-g++"
#make install-target-libgcc


###################################################################
# Zip the Toolchain for Storage in RRGamesCDN
###################################################################
tar --xz -cf "${GCC_TOOLCHAIN_NAME}".tar.xz "${GCC_TOOLCHAIN_NAME}"


###################################################################
# Clean up
###################################################################
rm -rf build
rm -rf "$LIBGCC_ARCHIVE"
rm -rf "$LIBGCC"
rm -rf amiga-gcc
rm -rf "${GCC_TOOLCHAIN_NAME}"
