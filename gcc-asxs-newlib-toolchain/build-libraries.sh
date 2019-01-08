####
#
# Run this script from the MSys2 MinGW32 command shell
#
# ${CARCH} does not work from the MSys2 MinGW32 command shell
#   Use ${MSYSTEM_CARCH} instead.
#
####

# import custom-settings.sh file
  source custom-settings.sh

# Helper macros to help make tasks easier #
exit_with_msg() {
    echo $1
    exit 1
}

  echo "Build ASXS"
  cd "${_source_folder}/src-asxs/asxv5pxx"

  # Temp work around till I find a better place for fix
  cp -f ../binutils/zlibarch.h asxxmisc/zlibarch.h
  make -C asxmak/cygwin/build clean
  make -C asxmak/cygwin/build as6809 aslink aslib
  make -C ../binutils clean
  make -C ../binutils

  #echo "Build Newlib boot GCC"
  ## Build cross-compiler just to compile newlib
  #rm -rf "${_source_folder}/compiler-${MSYSTEM_CARCH}"
  #mkdir -p "${_source_folder}/compiler-${MSYSTEM_CARCH}"
  #cd $_source_folder
  #rm -rf build-boot-gcc-${MSYSTEM_CARCH}
  #mkdir -p build-boot-gcc-${MSYSTEM_CARCH} && \
  #cd build-boot-gcc-${MSYSTEM_CARCH}

    #--enable-lite-exit                    \
    #--disable-newlib-global-atexit        \
    #--disable-newlib-atexit-dynamic-alloc \
    #--disable-isl-version-check \
    #--without-headers \

  if [[ ${VERSION_NEWLIB} != "git"  ]] ; then
    SRC_FOLDER_NEWLIB=../src-newlib
  else
    SRC_FOLDER_NEWLIB=${VCFOLDER_NEWLIB}
  fi

  #../src-gcc/configure \
    #--build="${MINGW_CHOST}" \
    #--host="${MINGW_CHOST}" \
    #--target="${_target}" \
    #--program-prefix="${_target}-" \
    #--prefix="${_source_folder}/compiler-${MSYSTEM_CARCH}" \
    #--with-sysroot="${_source_folder}/compiler-${MSYSTEM_CARCH}" \
    #--enable-languages="c" \
    #--enable-multilib \
    #--enable-interwork \
    #--enable-newlib-reent-small           \
    #--disable-werror \
    #--disable-nls \
    #--disable-shared \
    #--disable-threads \
    #--disable-lto \
    #--disable-libmudflap \
    #--disable-newlib-supplied-syscalls    \
    #--disable-newlib-fvwrite-in-streamio  \
    #--disable-newlib-fseek-optimization   \
    #--disable-newlib-wide-orient          \
    #--disable-newlib-unbuf-stream-opt     \
    #--disable-libffi \
    #--disable-libgomp \
    #--disable-libquadmath \
    #--disable-libssp \
    #--disable-libstdcxx-pch \
    #--disable-libsanitizer \
    #--disable-decimal-float \
    #--disable-tls \
    #--without-cloog \
    #--with-system-zlib \
    #--with-gnu-as --with-gnu-ld \
    #--with-libelf \
    #--with-newlib \
    #--with-build-sysroot=${SRC_FOLDER_NEWLIB}/newlib/libc/include \
    #--with-build-time-tools="${MINGW_INSTALL_PREFIX}/bin" \
    #CPPFLAGS="-g -O0" || exit_with_msg "boot GCC configure failure" && \
  #make -j1 all-gcc || exit_with_msg "boot GCC make failure" && \
  #make -j1 install-gcc || exit_with_msg "boot GCC install failure"

    #--enable-newlib-io-pos-args \
    #--enable-newlib-io-c99-formats \
    #--enable-newlib-io-long-long \
    #--enable-newlib-io-float \

  echo "Build newlib"
  if [[ ${VERSION_NEWLIB} == "git" ]] ; then
    cd ${SRC_FOLDER_NEWLIB}
    libtoolize --force --copy
    aclocal
    autoheader
    automake --add-missing --include-deps --copy
    autoconf
  fi

  bootgccpath="${_source_folder}/compiler-${MSYSTEM_CARCH}/bin"
  NEWLIB_CFLAGS+=" -g -ffunction-sections -fdata-sections"
  cd $_source_folder
  rm -rf build-newlib-${MSYSTEM_CARCH}
  mkdir -p build-newlib-${MSYSTEM_CARCH} && cd build-newlib-${MSYSTEM_CARCH}
  ${SRC_FOLDER_NEWLIB}/configure \
    --build=${MINGW_CHOST} \
    --host=${MINGW_CHOST} \
    --target=${_target} \
    --program-prefix="${_target}-" \
    --prefix="${MINGW_INSTALL_PREFIX}" \
    CFLAGS="${NEWLIB_CFLAGS}" \
    PATH="${bootgccpath}:${MINGW_INSTALL_PREFIX}/bin:${MINGW_INSTALL_PREFIX}/${_target}/bin:${PATH}" || exit_with_msg "newlib configure failure" && \
  make -j1 PATH="${bootgccpath}:${MINGW_INSTALL_PREFIX}/bin:${MINGW_INSTALL_PREFIX}/${_target}/bin:${PATH}" || exit_with_msg "newlib make failure" && \
  make -j1 install PATH="${bootgccpath}:${MINGW_INSTALL_PREFIX}/bin:${MINGW_INSTALL_PREFIX}/${_target}/bin:${PATH}" || exit_with_msg "newlib install failure"
