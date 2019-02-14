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

  cd $_source_folder
  if [[ ${VERSION_NEWLIB} != "git"  ]] ; then
    SRC_FOLDER_NEWLIB=../src-newlib
    BUILD_FOLDER_NEWLIB=${_source_folder}/build-newlib-${MSYSTEM_CARCH}
  else
    SRC_FOLDER_NEWLIB=${VCFOLDER_NEWLIB}
    BUILD_FOLDER_NEWLIB=${VCFOLDER_NEWLIB}/build-newlib-${MSYSTEM_CARCH}
  fi

  rm -rf ${BUILD_FOLDER_NEWLIB}
  mkdir -p ${BUILD_FOLDER_NEWLIB} && \
  cd ${BUILD_FOLDER_NEWLIB}

  echo "Build newlib"
  if [[ ${VERSION_NEWLIB} == "git" ]] ; then
    cd ${SRC_FOLDER_NEWLIB}/newlib
    # libtoolize --force --copy
#    aclocal || exit_with_msg "newlib aclocal failure"
    # autoheader
#    automake-1.9 --add-missing --include-deps --copy || exit_with_msg "newlib automake failure"
#    autoconf || exit_with_msg "newlib autoconf failure"
    cd $SRC_FOLDER_NEWLIB/newlib/libc/sys/m6809sim
#    aclocal || exit_with_msg "m6809sim aclocal failure"
    touch NEWS README AUTHORS ChangeLog
#    automake-1.10 --add-missing --include-deps --copy || exit_with_msg "m6809sim automake failure"
#
    cd $SRC_FOLDER_NEWLIB/newlib/libc/sys/m6809sim
#    autoconf || exit_with_msg "m6809sim autoconf failure"
#    cd $SRC_FOLDER_NEWLIB/newlib/libc/machine/m6809
#    automake-1.10 --add-missing --include-deps --copy || exit_with_msg "machine/m6809 automake failure"
    cd $SRC_FOLDER_NEWLIB/newlib/libc/machine/m6809
#    autoconf || exit_with_msg "machine/m6809 autoconf failure"
  fi

  NEWLIB_CFLAGS+=" -g -ffunction-sections -fdata-sections"
  cd $_source_folder
#  rm -rf build-newlib-${MSYSTEM_CARCH}; mkdir -p build-newlib-${MSYSTEM_CARCH} && \

  cd ${BUILD_FOLDER_NEWLIB}


####
#  Some influential environment variables for newlib
#   RANLIB_FOR_TARGET
#   CC_FOR_TARGET
#   AS_FOR_TARGET
#   AR_FOR_TARGET
#   LD_FOR_TARGET
####
#  Some influential environment variables for libgloss
#   CCAS        assembler compiler command (defaults to CC)
#   CCASFLAGS   assembler compiler flags (defaults to CFLAGS)
####

  mkdir -p ${BUILD_FOLDER_NEWLIB} && cd ${BUILD_FOLDER_NEWLIB}
  pwd

  CCAS="${_source_folder}/compiler-${MSYSTEM_CARCH}/bin/${_target}-gcc" \
  CC_FOR_TARGET="${_source_folder}/compiler-${MSYSTEM_CARCH}/bin/${_target}-gcc" \
  AS_FOR_TARGET="${MINGW_PREFIX}/bin/${_target}-as" \
  AR_FOR_TARGET="${MINGW_PREFIX}/bin/${_target}-ar" \
  LD_FOR_TARGET="${MINGW_PREFIX}/bin/${_target}-ld" \
  RANLIB_FOR_TARGET=/bin/true \
  CFLAGS="${NEWLIB_CFLAGS}" \
  PATH="${MINGW_PREFIX}/${_target}/bin:${MINGW_PREFIX}/bin:${PATH}" \
  ${SRC_FOLDER_NEWLIB}/configure \
    --build=${MINGW_CHOST} \
    --host=${MINGW_CHOST} \
    --target=${_target} \
    --program-prefix="${_target}-" \
    --prefix="${MINGW_INSTALL_PREFIX}"

  make -j1 || exit_with_msg "newlib make failure" && \
  make -j1 install || exit_with_msg "newlib install failure"

  #PATH=${MINGW_PREFIX}/bin:${MINGW_PREFIX}/${MINGW_CHOST}/bin:/usr/bin \
  #PATH="${bootgccpath}:${MINGW_INSTALL_PREFIX}/bin:${MINGW_INSTALL_PREFIX}/${_target}/bin:${PATH}" \
  #export PATH;
  
  #echo $PATH
