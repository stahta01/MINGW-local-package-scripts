####
#
####

# Install Run-time packages
  pacman -S --needed ${MINGW_PACKAGE_PREFIX}-gcc-libs \
    ${MINGW_PACKAGE_PREFIX}-hunspell ${MINGW_PACKAGE_PREFIX}-drmingw \
    ${MINGW_PACKAGE_PREFIX}-wxWidgets || exit
