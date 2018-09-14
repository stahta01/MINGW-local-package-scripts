####
#
####

# Install Run-time packages
  pacman -S --needed ${MINGW_PACKAGE_PREFIX}-gcc-libs \
    ${MINGW_PACKAGE_PREFIX}-expat \
    ${MINGW_PACKAGE_PREFIX}-libjpeg-turbo \
    ${MINGW_PACKAGE_PREFIX}-libpng ${MINGW_PACKAGE_PREFIX}-libtiff \
    ${MINGW_PACKAGE_PREFIX}-xz ${MINGW_PACKAGE_PREFIX}-zlib || exit

# Install Build packages
  pacman -S --needed make autoconf automake-wrapper \
    ${MINGW_PACKAGE_PREFIX}-gcc \
    ${MINGW_PACKAGE_PREFIX}-make || exit

# Install Test packages
  pacman -S --needed ${MINGW_PACKAGE_PREFIX}-cppunit || exit
