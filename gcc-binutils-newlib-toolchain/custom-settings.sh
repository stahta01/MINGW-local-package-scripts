
#_target=mips-linux-gnu
#_target=mips-none-elf
#_target=mips-none-coff
#_target=h8500-none-elf
#_target=m6812-elf
#_target=m6812-none-elf
_target=arm-none-eabi


if [[ ${_target} == "i686-w64-mingw32" ]] ; then
  HOST_FOR_COMPILER=x86_64-w64-mingw32
  MINGW_GCC_COMMAND_PREFIX=x86_64-w64-mingw32-
else
  HOST_FOR_COMPILER=i686-w64-mingw32
  MINGW_GCC_COMMAND_PREFIX=i686-w64-mingw32-
fi


REPO_MINGW_LOCAL_PACKAGE_SCRIPTS=/C/repos/git/MINGW-local-package-scripts

_downloaded_files=${REPO_MINGW_LOCAL_PACKAGE_SCRIPTS}/downloaded-files

_source_folder=${REPO_MINGW_LOCAL_PACKAGE_SCRIPTS}/gcc-binutils-newlib-toolchain/src

MINGW_INSTALL_PREFIX="/usr/local"

VERSION_BINUTILS=2.19.1
VERSION_GCC=4.6.2
VERSION_NEWLIB=2.1.0


TAR_BASENAME_BINUTILS=binutils-${VERSION_BINUTILS}
TAR_BASENAME_NEWLIB=newlib-${VERSION_NEWLIB}
TAR_BASENAME_GCC=gcc-${VERSION_GCC}
