####
#
####

# Install Run-time packages
  pacman -S --needed ${MINGW_PACKAGE_PREFIX}-gcc-libs \
    ${MINGW_PACKAGE_PREFIX}-hunspell ${MINGW_PACKAGE_PREFIX}-drmingw \
    ${MINGW_PACKAGE_PREFIX}-wxWidgets || exit

# Install Build packages
  pacman -S --needed ${MINGW_PACKAGE_PREFIX}-boost \
    ${MINGW_PACKAGE_PREFIX}-libtool ${MINGW_PACKAGE_PREFIX}-gcc \
    ${MINGW_PACKAGE_PREFIX}-pkg-config autoconf automake-wrapper \
    subversion make patch rsync zip || exit
