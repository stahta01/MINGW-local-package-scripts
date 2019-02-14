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

  rm -rf ${BUILD_FOLDER_NEWLIB}
  mkdir -p ${BUILD_FOLDER_NEWLIB} && \
  cd ${BUILD_FOLDER_NEWLIB} || exit_with_msg "newlib mkdir failure"
  pwd

  NEWLIB_CFLAGS+=" -g -ffunction-sections -fdata-sections"
  
  bootgccpath="${_source_folder}/compiler-${MSYSTEM_CARCH}/bin:${_source_folder}/compiler-${MSYSTEM_CARCH}/libexec/gcc/${_target}/4.3.6"

  CCAS="${_source_folder}/compiler-${MSYSTEM_CARCH}/bin/${_target}-gcc" \
  CC_FOR_TARGET="${_source_folder}/compiler-${MSYSTEM_CARCH}/bin/${_target}-gcc" \
  AS_FOR_TARGET="${MINGW_INSTALL_PREFIX}/bin/${_target}-as" \
  AR_FOR_TARGET="${MINGW_INSTALL_PREFIX}/bin/${_target}-ar" \
  LD_FOR_TARGET="${MINGW_INSTALL_PREFIX}/bin/${_target}-ld" \
  RANLIB_FOR_TARGET=/bin/true \
  CFLAGS="${NEWLIB_CFLAGS}" \
  PATH="${bootgccpath}:${MINGW_INSTALL_PREFIX}/${_target}/bin:${MINGW_INSTALL_PREFIX}/bin:${PATH}" \
  ${SRC_FOLDER_NEWLIB}/configure \
    --build=${MINGW_CHOST} \
    --host=${MINGW_CHOST} \
    --target=${_target} \
    --program-prefix="${_target}-" \
    --prefix="${MINGW_INSTALL_PREFIX}" || exit_with_msg "newlib configure failure"

  make -j1 || exit_with_msg "newlib make failure" && \
  make -j1 install || exit_with_msg "newlib install failure"
