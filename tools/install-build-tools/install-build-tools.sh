#!/bin/bash

###################################################################
# Global Variables
###################################################################
# Versions
BINUTILS_VERSION="2.28"
GCC_VERSION="6.5.0"

# Package names
BINUTILS_FULL_NAME="binutils-${BINUTILS_VERSION}"
GCC_FULL_NAME="gcc-${GCC_VERSION}"

# Archive file names
BINUTILS_ARCHIVE="${BINUTILS_FULL_NAME}.tar.gz"
GCC_ARCHIVE="${GCC_FULL_NAME}.tar.gz"

# Archive URLs
BINUTILS_URL="https://ftp.gnu.org/gnu/binutils/${BINUTILS_ARCHIVE}"
GCC_URL="https://gcc.gnu.org/pub/gcc/releases/${GCC_FULL_NAME}/${GCC_ARCHIVE}"

# Build-tool names
GCC_TOOLCHAIN_NAME="m68k-elf-toolchain"

# Install paths
GCC_PREFIX="$(pwd)/${GCC_TOOLCHAIN_NAME}"

# OS variables
IS_WINDOWS="false"
IS_MACOS="false"
IS_LINUX="false"

# OS specific paths
WINDOWS32_INSTALL_PATH="$(pwd)/../../build-tools/windows/x86"
WINDOWS64_INSTALL_PATH="$(pwd)/../../build-tools/windows/x86-64"
MACOS_INSTALL_PATH="$(pwd)/../../build-tools/macOS"
LINUX_INSTALL_PATH="$(pwd)/../../build-tools/linux"
WINDOWS32_BEBBO_PATH="$(pwd)/bebbo-modules/windows/x86"
WINDOWS64_BEBBO_PATH="$(pwd)/bebbo-modules/windows/x86-64"
MACOS_BEBBO_PATH="$(pwd)/bebbo-modules/macOS"
LINUX_BEBBO_PATH="$(pwd)/bebbo-modules/linux"

# Required DLL paths
LIBWINPTHREAD_NAME="libwinpthread-1.dll"
LIBICONV_NAME="libiconv-2.dll"
LIBWINPTHREAD32_PATH="/mingw32/bin/${LIBWINPTHREAD_NAME}"
LIBWINPTHREAD64_PATH="/mingw64/bin/${LIBWINPTHREAD_NAME}"
LIBICONV32_PATH="/mingw32/bin/${LIBICONV_NAME}"
LIBICONV64_PATH="/mingw64/bin/${LIBICONV_NAME}"

# Decided paths (Values determined later based based on OS)
PLATFORM_INSTALL_PATH=""
BEBBO_PATH=""
LIBWINPTHREAD_PATH=""
LIBICONV_PATH=""

# Others
EXE_SUFFIX="" #Will become ".exe" later if the build system is Windows

# Determine OS type
if echo "${OSTYPE}" | grep -q "msys"; then
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
    echo -e "\t2. MSYS 32-bit and/or 64-bit version depending on which architecture you want to build for."
    echo -e "\t3. Update MSYS version(s) using: 'pacman -Syu'. Perform this twice!"
    echo -e "\t4. Install build tools using: 'pacman -S --needed base-devel mingw-w64-x86_64-toolchain msys2-devel msys2-runtime-devel!'."
    echo -e "\t5. Install other necessary MSYS packages using: 'pacman -S git base-devel gcc flex gmp-devel mpc-devel mpfr-devel ncurses-devel rsync autoconf automake'."
    echo -e "\t6. If installation seems to be giving trouble with Microsoft Visual C++ Runtime you may need to install Visual Studio."
    echo -e "\t7. Build the tools in the MINGW shell x86 shell for 32-bit Windows and x64 shell for 64-bit Windows."
elif [ "${IS_MACOS}" = "true" ]; then
    echo -e "\t1. Xcode command line tools. (xcode-select --install)"
    echo -e "\t2. GCC toolchain. Installed easiest through the Homebrew package manager. (brew install gcc)"
    echo -e "\t3. wget command. Installed easiest through Homebrew. (brew install wget)"
else
    echo -e "\t1. GCC toolchain. Best installed through apt, advanced package manager. (sudo apt install build-essential)"
fi

# Final Warning
echo ""
echo "NOTE: These are only basic prerequisits. Knowledge of building compilers is required before running this script."
echo "Do you wish to continue running this script? (y/n)"
read YES_NO
if [ "${YES_NO}" != "y" ]; then 
    exit 
fi
echo ""

###################################################################
# Create Folders for Builds
###################################################################
mkdir -p "build/${BINUTILS_FULL_NAME}"
mkdir -p "build/${GCC_FULL_NAME}"
mkdir -p "${GCC_TOOLCHAIN_NAME}"

###################################################################
# Download, Build and Install Binutils
###################################################################
# Download binutils and extract
wget "${BINUTILS_URL}"
tar -xf "${BINUTILS_ARCHIVE}"

# Configure binutils
cd "build/${BINUTILS_FULL_NAME}"
"../../${BINUTILS_FULL_NAME}/configure"     --prefix="${GCC_PREFIX}" \
                                            --target=m68k-elf \
                                            --disable-werror \
                                            --disable-nls \
                                            --disable-threads \
                                            --disable-multilib \
                                            --enable-libssp \
                                            --enable-lto \
                                            --enable-languages=c \
                                            --program-prefix=m68k-elf-

# Build and install binutils
make -j 6
make install

# Add GCC bin folder to path
cd "../../${GCC_TOOLCHAIN_NAME}/bin"
export PATH="$(pwd):${PATH}"
cd ../..

###################################################################
# Download, Build and Install GCC
###################################################################
# Download GCC and extract
wget "${GCC_URL}"
tar -xf "${GCC_ARCHIVE}"

# Download GCC prerequisites
cd "${GCC_FULL_NAME}"
./contrib/download_prerequisites

# Configure GCC
cd "../build/${GCC_FULL_NAME}"
"../../${GCC_FULL_NAME}/configure"          --prefix="${GCC_PREFIX}" \
                                            --target=m68k-elf \
                                            --program-prefix=m68k-elf- \
                                            --enable-languages=c \
                                            --enable-obsolete \
                                            --enable-lto \
                                            --disable-threads \
                                            --disable-libmudflap \
                                            --disable-libgomp \
                                            --disable-nls \
                                            --disable-werror \
                                            --disable-libssp \
                                            --disable-shared \
                                            --disable-multilib \
                                            --disable-libgcj \
                                            --disable-libstdcxx \
                                            --disable-gcov \
                                            --without-headers \
                                            --without-included-gettext \
                                            --with-cpu=m68000

# Build and Install GCC
make -j 6
make install

# Return to Root
cd ../..

###################################################################
# Decide OS Specific Install Paths
###################################################################
if [ "${IS_WINDOWS}" = "true" ]; then

    if [ "$(arch)" = "x86_64" ]; then
        PLATFORM_INSTALL_PATH="${WINDOWS64_INSTALL_PATH}"
        BEBBO_PATH="${WINDOWS64_BEBBO_PATH}"
        LIBWINPTHREAD_PATH="${LIBWINPTHREAD64_PATH}"
        LIBICONV_PATH="${LIBICONV64_PATH}"
    else
        PLATFORM_INSTALL_PATH="${WINDOWS32_INSTALL_PATH}"
        BEBBO_PATH="${WINDOWS32_BEBBO_PATH}"
        LIBWINPTHREAD_PATH="${LIBWINPTHREAD32_PATH}"
        LIBICONV_PATH="${LIBICONV32_PATH}"
    fi
    
    EXE_SUFFIX=".exe"
    
elif [ "${IS_MACOS}" = "true" ]; then
    PLATFORM_INSTALL_PATH="${MACOS_INSTALL_PATH}"
    BEBBO_PATH="${MACOS_BEBBO_PATH}"
else
    PLATFORM_INSTALL_PATH="${LINUX_INSTALL_PATH}"
    BEBBO_PATH="${LINUX_BEBBO_PATH}"
fi

###################################################################
# Copy the Bebbo GCC Modules
###################################################################
cp "${BEBBO_PATH}/cc1${EXE_SUFFIX}" "${GCC_PREFIX}/libexec/gcc/m68k-elf/${GCC_VERSION}/cc1${EXE_EXTENSION}"

###################################################################
# Copy Required DLLs (Windows)
###################################################################
if [ "${IS_WINDOWS}" = "true" ]; then
    cp "${LIBWINPTHREAD_PATH}" "${GCC_PREFIX}/bin/${LIBWINPTHREAD_NAME}"
    cp "${LIBICONV_PATH}" "${GCC_PREFIX}/bin/${LIBICONV_NAME}"
    cp "${LIBWINPTHREAD_PATH}" "${GCC_PREFIX}/libexec/gcc/m68k-elf/${GCC_VERSION}/${LIBWINPTHREAD_NAME}"
    cp "${LIBICONV_PATH}" "${GCC_PREFIX}/libexec/gcc/m68k-elf/${GCC_VERSION}/${LIBICONV_NAME}"
fi

###################################################################
# Copy Built Tools to Destination
###################################################################
mkdir -p "${PLATFORM_INSTALL_PATH}"
cp -r "${GCC_TOOLCHAIN_NAME}" "${PLATFORM_INSTALL_PATH}"

###################################################################
# Clean up
###################################################################
rm -rf "${BINUTILS_ARCHIVE}"
rm -rf "${GCC_ARCHIVE}"
rm -rf "${BINUTILS_FULL_NAME}"
rm -rf "${GCC_FULL_NAME}"
rm -rf build
rm -rf "${GCC_TOOLCHAIN_NAME}"
