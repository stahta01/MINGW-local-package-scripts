####
#
####

# import custom-settings.sh file
  source custom-settings.sh

# Helper macros to help make tasks easier #
exit_with_msg() {
    echo $1
    exit 1
}

######## Old Code that I want to save Begin ########
  #cd $_source_folder
  #rm -rf build-gmp
  #mkdir -p build-gmp && cd build-gmp
  #../src-gmp/configure \
    #--build=${HOST_FOR_COMPILER} \
    #--host=${HOST_FOR_COMPILER} \
    #--prefix="${MINGW_INSTALL_PREFIX}/gmp" \
    #--disable-shared --enable-static \
    #CC=${MINGW_GCC_COMMAND_PREFIX}gcc.exe || exit_with_msg "gmp configure failure" && \
  #make -j1 || exit_with_msg "gmp make failure" && \
  #make -j1 install || exit_with_msg "gmp install failure"

  #cd $_source_folder
  #rm -rf build-mpfr
  #mkdir -p build-mpfr && cd build-mpfr
  #../src-mpfr/configure \
    #--build=${HOST_FOR_COMPILER} \
    #--host=${HOST_FOR_COMPILER} \
    #--prefix="${MINGW_INSTALL_PREFIX}/mpfr" \
    #--with-gmp="${MINGW_INSTALL_PREFIX}/gmp" \
    #--disable-shared --enable-static \
    #CC=${MINGW_GCC_COMMAND_PREFIX}gcc.exe || exit_with_msg "mpfr configure failure" && \
  #make -j1 || exit_with_msg "mpfr make failure" && \
  #make -j1 install || exit_with_msg "mpfr install failure"
######## Old Code that I want to save End ########

  # --build=the architecture of the build machine
  # --host=the architecture that you want the file to run on

  echo "Build binutils"
  cd $_source_folder
  rm -rf build-binutils
  mkdir -p build-binutils && cd build-binutils
  ../src-binutils/configure \
    --build=${HOST_FOR_COMPILER} \
    --host=${HOST_FOR_COMPILER} \
    --target="${_target}" \
    --program-prefix="${_target}-" \
    --prefix="${MINGW_INSTALL_PREFIX}" \
    --infodir="${MINGW_INSTALL_PREFIX}/${_target}/info" \
    --disable-werror \
    --disable-lto \
    --disable-nls \
    --disable-rpath \
    CC=${MINGW_GCC_COMMAND_PREFIX}gcc.exe \
    CFLAGS="${BINUTILS_CFLAGS}" || exit_with_msg "binutils configure failure" && \
  make -j1 || exit_with_msg "binutils make failure" && \
  make -j1 install || exit_with_msg "binutils install failure"

  echo "Build Newlib boot GCC"
  # Build cross-compiler just to compile newlib
  rm -rf "${_source_folder}/compiler"
  mkdir -p "${_source_folder}/compiler"
  cd $_source_folder
  rm -rf build-temp-gcc
  mkdir -p build-temp-gcc && \
  cd build-temp-gcc

    #--enable-lite-exit                    \
    #--disable-newlib-global-atexit        \
    #--disable-newlib-atexit-dynamic-alloc \
    #--disable-isl-version-check \
    #--without-headers \
    #--with-gmp="${MINGW_INSTALL_PREFIX}/gmp" \
    #--with-mpfr="${MINGW_INSTALL_PREFIX}/mpfr" \

  ../src-gcc/configure \
    --build=${HOST_FOR_COMPILER} \
    --host=${HOST_FOR_COMPILER} \
    --target="${_target}" \
    --program-prefix="${_target}-" \
    --prefix="${_source_folder}/compiler" \
    --with-sysroot="${_source_folder}/compiler" \
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
    --with-build-sysroot=../src-newlib/newlib/libc/include \
    --with-build-time-tools="${MINGW_INSTALL_PREFIX}/bin" \
    CC=${MINGW_GCC_COMMAND_PREFIX}gcc.exe \
    CPPFLAGS="-g -O0" || exit_with_msg "boot GCC configure failure" && \
  make -j1 all-gcc || exit_with_msg "boot GCC make failure" && \
  make -j1 install-gcc || exit_with_msg "boot GCC install failure"

    #--enable-newlib-io-pos-args \
    #--enable-newlib-io-c99-formats \
    #--enable-newlib-io-long-long \
    #--enable-newlib-io-float \

  echo "Build newlib"
  bootgccpath="${_source_folder}/compiler/bin"
  NEWLIB_CFLAGS+=" -g -ffunction-sections -fdata-sections"
  cd $_source_folder
  rm -rf build-newlib
  mkdir -p build-newlib && cd build-newlib
  ../src-newlib/configure \
    --build=${HOST_FOR_COMPILER} \
    --host=${HOST_FOR_COMPILER} \
    --target=${_target} \
    --prefix="${MINGW_INSTALL_PREFIX}" \
    --disable-newlib-supplied-syscalls \
    --disable-nls \
    --enable-newlib-reent-small \
    CC=${MINGW_GCC_COMMAND_PREFIX}gcc.exe \
    CFLAGS="${NEWLIB_CFLAGS}" \
    PATH="${bootgccpath}:${MINGW_INSTALL_PREFIX}/bin:${MINGW_INSTALL_PREFIX}/${_target}/bin:${PATH}" || exit_with_msg "newlib configure failure" && \
  make -j1 PATH="${bootgccpath}:${MINGW_INSTALL_PREFIX}/bin:${MINGW_INSTALL_PREFIX}/${_target}/bin:${PATH}" || exit_with_msg "newlib make failure" && \
  make -j1 install PATH="${bootgccpath}:${MINGW_INSTALL_PREFIX}/bin:${MINGW_INSTALL_PREFIX}/${_target}/bin:${PATH}" || exit_with_msg "newlib install failure"
