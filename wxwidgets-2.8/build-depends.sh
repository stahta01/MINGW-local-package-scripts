
# Install Build packages
  pacman -S --needed make autoconf automake-wrapper \
    ${MINGW_PACKAGE_PREFIX}-gcc \
    ${MINGW_PACKAGE_PREFIX}-make || exit
