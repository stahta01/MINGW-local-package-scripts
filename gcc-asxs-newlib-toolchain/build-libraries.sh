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

  # Install ASXX files
  mkdir -p "${MINGW_INSTALL_PREFIX}/${_target}/bin"
  cp -f ../binutils/ar         "${MINGW_INSTALL_PREFIX}/${_target}/bin/ar"
  cp -f ../binutils/as         "${MINGW_INSTALL_PREFIX}/${_target}/bin/as"
  cp -f ../binutils/ld         "${MINGW_INSTALL_PREFIX}/${_target}/bin/ld"
  cp -f ../binutils/ranlib.exe "${MINGW_INSTALL_PREFIX}/${_target}/bin/ranlib.exe"
  
  sed -i "s|@AS_PREFIX@|${MINGW_INSTALL_PREFIX}|" "${MINGW_INSTALL_PREFIX}/${_target}/bin/ar"
  sed -i "s|@AS_PREFIX@|${MINGW_INSTALL_PREFIX}|" "${MINGW_INSTALL_PREFIX}/${_target}/bin/as"
  sed -i "s|@AS_PREFIX@|${MINGW_INSTALL_PREFIX}|" "${MINGW_INSTALL_PREFIX}/${_target}/bin/ld"

  mkdir -p "${MINGW_INSTALL_PREFIX}/bin"
  mv asxmak/cygwin/exe/*.exe   "${MINGW_INSTALL_PREFIX}/bin/"
  cp -f ../binutils/ar         "${MINGW_INSTALL_PREFIX}/bin/${_target}-ar"
  cp -f ../binutils/as         "${MINGW_INSTALL_PREFIX}/bin/${_target}-as"
  cp -f ../binutils/ld         "${MINGW_INSTALL_PREFIX}/bin/${_target}-ld"
  mv    ../binutils/ranlib.exe "${MINGW_INSTALL_PREFIX}/bin/${_target}-ranlib.exe"

  sed -i "s|@AS_PREFIX@|${MINGW_INSTALL_PREFIX}|" "${MINGW_INSTALL_PREFIX}/bin/${_target}-ar"
  sed -i "s|@AS_PREFIX@|${MINGW_INSTALL_PREFIX}|" "${MINGW_INSTALL_PREFIX}/bin/${_target}-as"
  sed -i "s|@AS_PREFIX@|${MINGW_INSTALL_PREFIX}|" "${MINGW_INSTALL_PREFIX}/bin/${_target}-ld"

  echo "Build Newlib boot GCC"
  # Build cross-compiler just to compile newlib
  rm -rf "${_source_folder}/compiler-${MSYSTEM_CARCH}"
  mkdir -p "${_source_folder}/compiler-${MSYSTEM_CARCH}"

  cd $_source_folder

  if [[ ${VERSION_NEWLIB} != "git"  ]] ; then
    SRC_FOLDER_NEWLIB=../src-newlib
  else
    SRC_FOLDER_NEWLIB=${VCFOLDER_NEWLIB}
  fi
  if [[ ${VERSION_GCC} != "git"  ]] ; then
    SRC_FOLDER_GCC=../src-gcc
    BUILD_FOLDER_GCC=${_source_folder}/build-boot-gcc-${MSYSTEM_CARCH}
  else
    SRC_FOLDER_GCC=..
    BUILD_FOLDER_GCC=${VCFOLDER_GCC}/build-boot-gcc-${MSYSTEM_CARCH}
  fi

  rm -rf ${BUILD_FOLDER_GCC}
  mkdir -p ${BUILD_FOLDER_GCC} && \
  cd ${BUILD_FOLDER_GCC}

  mkdir -p ${_source_folder}/compiler-${MSYSTEM_CARCH}/m6809-unknown/bin
  cp ${MINGW_INSTALL_PREFIX}/${_target}/bin/* ${_source_folder}/compiler-${MSYSTEM_CARCH}/m6809-unknown/bin/
    #--enable-lite-exit                    \
    #--disable-newlib-global-atexit        \
    #--disable-newlib-atexit-dynamic-alloc \
    #--disable-isl-version-check \
    #--without-headers \

  ${SRC_FOLDER_GCC}/configure \
    --src=${SRC_FOLDER_GCC} \
    --build="${MINGW_CHOST}" \
    --host="${MINGW_CHOST}" \
    --target="${_target}" \
    --program-prefix="${_target}-" \
    --prefix="${_source_folder}/compiler-${MSYSTEM_CARCH}" \
    --with-sysroot="${_source_folder}/compiler-${MSYSTEM_CARCH}" \
    --enable-languages="c" \
    --enable-multilib \
    --enable-interwork \
    --enable-newlib-reent-small           \
    --disable-werror \
    --disable-nls \
    --disable-shared \
    --disable-threads \
    --disable-lto \
    --disable-libmudflap \
    --disable-newlib-supplied-syscalls    \
    --disable-newlib-fvwrite-in-streamio  \
    --disable-newlib-fseek-optimization   \
    --disable-newlib-wide-orient          \
    --disable-newlib-unbuf-stream-opt     \
    --disable-libffi \
    --disable-libgomp \
    --disable-libquadmath \
    --disable-libssp \
    --disable-libstdcxx-pch \
    --disable-libsanitizer \
    --disable-decimal-float \
    --disable-tls \
    --without-cloog \
    --with-system-zlib \
    --with-gnu-as --with-gnu-ld \
    --with-libelf \
    --with-newlib \
    --with-build-sysroot=${SRC_FOLDER_NEWLIB}/newlib/libc/include \
    --with-build-time-tools="${MINGW_INSTALL_PREFIX}/bin" \
    CPPFLAGS="-g -O0" || exit_with_msg "boot GCC configure failure" && \
  make -j1 all-gcc || exit_with_msg "boot GCC make failure" && \
  make -j1 install-gcc || exit_with_msg "boot GCC install failure"

    #--enable-newlib-io-pos-args \
    #--enable-newlib-io-c99-formats \
    #--enable-newlib-io-long-long \
    #--enable-newlib-io-float \

  echo "Build newlib"
  if [[ ${VERSION_NEWLIB} == "git" ]] ; then
    cd ${SRC_FOLDER_NEWLIB}
    # libtoolize --force --copy
    # aclocal
    # autoheader
    # automake-1.11 --add-missing --include-deps --copy
    # autoconf
  fi


  NEWLIB_CFLAGS+=" -g -ffunction-sections -fdata-sections"
  cd $_source_folder
  rm -rf build-newlib-${MSYSTEM_CARCH}; mkdir -p build-newlib-${MSYSTEM_CARCH} && \
  cd build-newlib-${MSYSTEM_CARCH}

  bootgccpath="${_source_folder}/compiler-${MSYSTEM_CARCH}/bin:${_source_folder}/compiler-${MSYSTEM_CARCH}/libexec/gcc/${_target}/4.3.6"

  PATH=${MINGW_PREFIX}/bin:${MINGW_PREFIX}/${MINGW_CHOST}/bin:/usr/bin \
  PATH="${bootgccpath}:${MINGW_INSTALL_PREFIX}/bin:${MINGW_INSTALL_PREFIX}/${_target}/bin:${PATH}" \
  export PATH;
  
  echo $PATH

  CC_FOR_TARGET="${MINGW_INSTALL_PREFIX}/bin/${_target}-gcc" \
  AR_FOR_TARGET="${MINGW_INSTALL_PREFIX}/bin/${_target}-ar" \
  LD_FOR_TARGET="${MINGW_INSTALL_PREFIX}/bin/${_target}-ld" \
  RANLIB_FOR_TARGET="${MINGW_INSTALL_PREFIX}/bin/${_target}-ranlib.exe" \
  CFLAGS="${NEWLIB_CFLAGS}" \
  ${SRC_FOLDER_NEWLIB}/configure \
    --enable-newlib-elix-level=1 \
    --build=${MINGW_CHOST} \
    --host=${MINGW_CHOST} \
    --target=${_target} \
    --program-prefix="${_target}-" \
    --prefix="${MINGW_INSTALL_PREFIX}" || exit_with_msg "newlib configure failure" && \
  make -j1 || exit_with_msg "newlib make failure" && \
  make -j1 install || exit_with_msg "newlib install failure"
