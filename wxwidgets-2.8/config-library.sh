####
#
####

# import library settings file
  source library-settings.sh

  cd ${_LIBRARY_REPO} || exit 1

#  ./bootstrap

  mkdir -p ${_LIBRARY_BUILD_DIR} && cd ${_LIBRARY_BUILD_DIR}
#  PATH="${MINGW_PREFIX}/bin":"$PATH" 
  ../configure \
    --host=${MINGW_CHOST} \
    --target=${MINGW_CHOST} \
    --build=${MINGW_CHOST} \
    --with-msw \
    --disable-precomp-headers \
    --enable-shared \
    --enable-unicode \
    --disable-compat26 \
    --enable-monolithic \
    --with-opengl \
    --with-regex=builtin
