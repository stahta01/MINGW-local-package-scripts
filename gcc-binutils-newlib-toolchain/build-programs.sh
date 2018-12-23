####
#
####

# import custom-settings.sh file
  source custom-settings.sh

  echo "Build GCC"
  cd $_source_folder
  rm -rf build-gcc
  mkdir -p build-gcc && cd build-gcc
  unset CFLAGS
  unset CXXFLAGS
  # Bug work around that with-build-sysroot might have fixed
  mkdir -p ${MINGW_INSTALL_PREFIX}/${_target}/include/usr/include
  CFLAGS="-g -O3 -fdata-sections -ffunction-sections" \
  CXXFLAGS="${CFLAGS}" \
  CC=${MINGW_GCC_COMMAND_PREFIX}gcc.exe \
  CXX=${MINGW_GCC_COMMAND_PREFIX}g++.exe \
  ../src-gcc/configure \
    --build=${HOST_FOR_COMPILER} \
    --host=${HOST_FOR_COMPILER} \
    --target="${_target}" \
    --prefix="${MINGW_INSTALL_PREFIX}" \
    --with-sysroot="${MINGW_INSTALL_PREFIX}/${_target}" \
    --with-build-sysroot="${MINGW_INSTALL_PREFIX}/${_target}/include" \
    --infodir="${MINGW_INSTALL_PREFIX}/${_target}/info" \
    --enable-languages="c,c++" \
    --enable-multilib \
    --enable-interwork \
    --with-newlib \
    --with-headers=yes \
    --with-native-system-header-dir="${MINGW_PREFIX}/include" \
    --with-gnu-as \
    --with-gnu-ld \
    --with-system-zlib \
    --with-python-dir="share/${_target}-gcc" \
    --with-libelf \
    --with-host-libstdcxx="-static-libgcc -Wl,-Bstatic,-lstdc++,-Bdynamic -lm" \
    --with-build-time-tools="${MINGW_INSTALL_PREFIX}/bin"  \
    --without-cloog \
    --disable-werror \
    --disable-isl-version-check  \
    --disable-lto \
    --disable-nls \
    --disable-libffi \
    --disable-decimal-float \
    --disable-libgomp \
    --disable-libmudflap \
    --disable-libquadmath \
    --disable-libssp \
    --disable-libstdcxx-pch \
    --disable-libsanitizer \
    --disable-threads \
    --disable-tls \
    --disable-shared && \
  make -j1 && \
  make -j1 install
