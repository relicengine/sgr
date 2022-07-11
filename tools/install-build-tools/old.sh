#!/bin/bash


# /mingw32/bin/libwinpthread-1.dll

###################################################################
# Global Variables
###################################################################
# Versioning, Folder Names and URLs
BINUTILS_VERSION="2.28"
BINUTILS_FULL_NAME="binutils-${BINUTILS_VERSION}"
BINUTILS_ARCHIVE="${BINUTILS_FULL_NAME}.tar.gz"
BINUTILS_URL="https://ftp.gnu.org/gnu/binutils/${BINUTILS_ARCHIVE}"
GCC_VERSION="6.5.0"
GCC_FULL_NAME="gcc-${GCC_VERSION}"
GCC_ARCHIVE="${GCC_FULL_NAME}.tar.gz"
GCC_URL="https://gcc.gnu.org/pub/gcc/releases/${GCC_FULL_NAME}/${GCC_ARCHIVE}"
GCC_TOOLCHAIN_NAME="m68k-elf-toolchain"
BEBBO_GCC_FULL_NAME="bebbo-gcc"
BEBBO_GCC_URL="https://github.com/bebbo/gcc"
BEBBO_GCC_TOOLCHAIN_NAME="m68k-amigaos-toolchain"

# Source Paths
ROOT_PATH="${PWD}"
BINUTILS_SOURCE_PATH="${ROOT_PATH}/${BINUTILS_FULL_NAME}"
GCC_SOURCE_PATH="${ROOT_PATH}/${GCC_FULL_NAME}"
BEBBO_GCC_SOURCE_PATH="${ROOT_PATH}/${BEBBO_GCC_FULL_NAME}"

# Build Paths
BUILD_DIR="${ROOT_PATH}/build"
BINUTILS_BUILD_PATH="${BUILD_DIR}/${BINUTILS_FULL_NAME}"
GCC_BUILD_PATH="${BUILD_DIR}/${GCC_FULL_NAME}"
BEBBO_GCC_BUILD_PATH="${BUILD_DIR}/${BEBBO_GCC_FULL_NAME}"

# Install Paths
GCC_INSTALL_PATH="${ROOT_PATH}/${GCC_TOOLCHAIN_NAME}"
BEBBO_GCC_INSTALL_PATH="${ROOT_PATH}/${BEBBO_GCC_TOOLCHAIN_NAME}"

# OS Specific bin Paths
BIN_PATH="" # The bin path to copy install tools too. Decided later down the script.
WINDOWS32_BIN_PATH="${ROOT_PATH}/../../build-tools/windows/x86"
WINDOWS64_BIN_PATH="${ROOT_PATH}/../../build-tools/windows/x86-64"
MACOS_BIN_PATH="${ROOT_PATH}/../../build-tools/macOS"
UBUNTU_BIN_PATH="${ROOT_PATH}/../../build-tools/ubuntu"

# OS Specific lib Paths
LIB_PATH="" # The bin path to copy install tools too. Decided later down the script.
WINDOWS_LIB_PATH="${ROOT_PATH}/lib/build-tools/windows"
MACOS_LIB_PATH="${ROOT_PATH}/lib/build-tools/macOS"
UBUNTU_LIB_PATH="${ROOT_PATH}/lib/build-tools/ubuntu"

# OS Specific Bebbo Module Paths
BEBBO_PATH=""
WINDOWS32_BEBBO_PATH="${ROOT_PATH}/bebbo-modules/windows/x86"
WINDOWS64_BEBBO_PATH="${ROOT_PATH}/bebbo-modules/windows/x86-64"
MACOS_BEBBO_PATH="${ROOT_PATH}/bebbo-modules/macOS"
UBUNTU_BEBBO_PATH="${ROOT_PATH}/bebbo-modules/ubuntu"

# Other
EXE_EXTENSION="" #Will be set later
GCC_PROGRAM_PREFIX="m68k-elf-"
BEBBO_GCC_PROGRAM_PREFIX="m68k-amigaos-"
CPU="m68000"
NPROC="6" # Number of processors to build with
IS_WINDOWS="false"
IS_MACOS="false"
IS_UBUNTU="false"

###################################################################
# Warning Message
###################################################################
echo "
WARNING: This script is used to build the compiler tools for SGSL. 
By default, these build tools were already built on a computer with the proper 
enviroment and prerequisites. Do not try to run this script unless you have 
experience building compiler toolchains. Otherwise, it my render SGSL useless.
------------------------------------------------------------------------------"
echo "Do you wish to continue running this script? (y/n)"
read YES_NO
if [ "${YES_NO}" != "y" ]; then
    exit 
fi
echo ""

###################################################################
# Set OS Booleans
###################################################################
if echo "${OSTYPE}" | grep -q "msys"; then
    IS_WINDOWS="true"
elif echo "${OSTYPE}" | grep -q "darwin"; then
    IS_MACOS="true"
elif echo "${OSTYPE}" | grep -q "linux"; then
    IS_UBUNTU="true"
else
    echo "Your Operating System, ${OSTYPE}, does not seem to be supported by SGR. Quitting."
    exit
fi

###################################################################
# Output Required Prerequisites for OS
###################################################################
echo "Prerequisites for ${OSTYPE}:"

# Prerequisites
if [ "${IS_WINDOWS}" = "true" ]; then
    echo -e "\t1. MSYS software distribution and building platform."
    echo -e "\t2. Update MSYS using: 'pacman -Syu'."
    echo -e "\t3. Proper MSYS Development Packages: 'pacman -S git base-devel gcc flex gmp-devel mpc-devel mpfr-devel ncurses-devel rsync autoconf automake'."
    echo -e "\t4. GCC toolchain. Best installed through: 'pacman -S gcc'."
    echo -e "\t5. wget command. Installed easiest: 'pacman -S git base-devel wget'."
elif [ "${IS_MACOS}" = "true" ]; then
    echo -e "\t1. Xcode command line tools. (xcode-select --install)"
    echo -e "\t2. GCC toolchain. Installed easiest through the Homebrew package manager. (brew install gcc)"
    echo -e "\t3. wget command. Installed easiest through Homebrew. (brew install wget)"
    echo -e "\t4. git command. Installed easiest through Homebrew. (brew install git)"
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
# Prepare OS-dependant Variables
###################################################################
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
# Download and Install Binutils
###################################################################
mkdir -p "${BINUTILS_BUILD_PATH}"
mkdir -p "${GCC_INSTALL_PATH}"

wget "${BINUTILS_URL}"

echo "Unzipping ${BINUTILS_ARCHIVE} ..."
tar -xf "${BINUTILS_ARCHIVE}"

cd "${BINUTILS_BUILD_PATH}"
"${BINUTILS_SOURCE_PATH}/configure" --prefix="${GCC_INSTALL_PATH}" --target=m68k-elf --disable-werror --disable-nls --disable-threads --disable-multilib --enable-libssp --enable-lto --enable-languages=c --program-prefix="${GCC_PROGRAM_PREFIX}"
make -j "${NPROC}"
make install
cd "${ROOT_PATH}"

# Add the Binutils Binaries to PATH to Build GCC
export PATH="${GCC_INSTALL_PATH}/bin:${PATH}"

###################################################################
# Download and Install GCC (m68k-elf)
###################################################################
mkdir -p "${GCC_BUILD_PATH}"

wget "${GCC_URL}"

echo "Unzipping ${GCC_ARCHIVE} ..."
tar -xf "${GCC_ARCHIVE}"

cd "${GCC_SOURCE_PATH}"
./contrib/download_prerequisites

cd "${GCC_BUILD_PATH}"
"${GCC_SOURCE_PATH}/configure" --prefix="${GCC_INSTALL_PATH}" --target=m68k-elf --program-prefix="${GCC_PROGRAM_PREFIX}" --enable-languages=c --enable-obsolete --enable-lto --disable-threads --disable-libmudflap --disable-libgomp --disable-nls --disable-werror --disable-libssp --disable-shared --disable-multilib --disable-libgcj --disable-libstdcxx --disable-gcov --without-headers --without-included-gettext --with-cpu="${CPU}"
make -j "${NPROC}"
make install
cd "${ROOT_PATH}"

###################################################################
# Install Bebbo GCC (m68k-amigaos)
###################################################################
<<comment
mkdir -p "${BEBBO_GCC_BUILD_PATH}"

git clone "${BEBBO_GCC_URL}" "${BEBBO_GCC_FULL_NAME}"

cd "${BEBBO_GCC_SOURCE_PATH}"
./contrib/download_prerequisites

cd "${BEBBO_GCC_BUILD_PATH}"
"${BEBBO_GCC_SOURCE_PATH}/configure" --prefix="${BEBBO_GCC_INSTALL_PATH}" --target=m68k-amigaos --program-prefix="${BEBBO_GCC_PROGRAM_PREFIX}" --enable-languages=c --enable-obsolete --enable-lto --disable-threads --disable-libmudflap --disable-libgomp --disable-nls --disable-werror --disable-libssp --disable-shared --disable-multilib --disable-libgcj --disable-libstdcxx --disable-gcov --without-headers --with-cpu="${CPU}"
make -j "${NPROC}"
make install
cd "${ROOT_PATH}"
comment

###################################################################
# Decide OS Specific Paths
###################################################################
# Decide the Proper bin Path Depending on OS
if [ "${IS_WINDOWS}" = "true" ]; then
    
    LIB_PATH="${WINDOWS_LIB_PATH}"

    if [ "$(arch)" = "x86_64" ]; then
        BIN_PATH="${WINDOWS64_BIN_PATH}"
        BEBBO_PATH="${WINDOWS64_BEBBO_PATH}"
    else
        BIN_PATH="${WINDOWS32_BIN_PATH}"
        BEBBO_PATH="${WINDOWS32_BEBBO_PATH}"
    fi
    
    EXE_EXTENSION=".exe"
elif [ "${IS_MACOS}" = "true" ]; then
    BIN_PATH="${MACOS_BIN_PATH}"
    LIB_PATH="${MACOS_LIB_PATH}"
    BEBBO_PATH="${MACOS_BEBBO_PATH}"
else
    BIN_PATH="${UBUNTU_BIN_PATH}"
    LIB_PATH="${UBUNTU_LIB_PATH}"
    BEBBO_PATH="${UBUNTU_BEBBO_PATH}"
fi

###################################################################
# Copy Bebbo GCC Modules to m68k-elf GCC
###################################################################
#cp "${BEBBO_GCC_INSTALL_PATH}/libexec/gcc/m68k-amigaos/6.5.0b/cc1" "${GCC_INSTALL_PATH}/libexec/gcc/m68k-elf/6.5.0/cc1"
#cp "${BEBBO_GCC_INSTALL_PATH}/libexec/gcc/m68k-amigaos/6.5.0b/lto1" "${GCC_INSTALL_PATH}/libexec/gcc/m68k-elf/6.5.0/lto1"
#cp "${BEBBO_GCC_INSTALL_PATH}/libexec/gcc/m68k-amigaos/6.5.0b/lto-wrapper" "${GCC_INSTALL_PATH}/libexec/gcc/m68k-elf/6.5.0/lto-wrapper"

cp "${BEBBO_PATH}/cc1${EXE_EXTENSION}" "${GCC_INSTALL_PATH}/libexec/gcc/m68k-elf/6.5.0/cc1${EXE_EXTENSION}"
cp "${BEBBO_PATH}/lto1${EXE_EXTENSION}" "${GCC_INSTALL_PATH}/libexec/gcc/m68k-elf/6.5.0/lto1${EXE_EXTENSION}"
cp "${BEBBO_PATH}/lto-wrapper${EXE_EXTENSION}" "${GCC_INSTALL_PATH}/libexec/gcc/m68k-elf/6.5.0/lto-wrapper${EXE_EXTENSION}"

# Create Paths and Copy Necessary Files
mkdir -p "${BIN_PATH}"
cp -r "${GCC_INSTALL_PATH}" "${BIN_PATH}"

###################################################################
# Clean up
###################################################################
rm -f "${ROOT_PATH}/${BINUTILS_ARCHIVE}"
rm -f "${ROOT_PATH}/${GCC_ARCHIVE}"
rm -rf "${BINUTILS_SOURCE_PATH}"
rm -rf "${GCC_SOURCE_PATH}"
rm -rf "${BEBBO_GCC_SOURCE_PATH}"
rm -rf "${BUILD_DIR}"
