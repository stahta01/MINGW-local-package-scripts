####
#
####

# Install Build packages
  pacman -S --needed ${MINGW_PACKAGE_PREFIX}-boost \
    ${MINGW_PACKAGE_PREFIX}-libtool ${MINGW_PACKAGE_PREFIX}-gcc \
    ${MINGW_PACKAGE_PREFIX}-pkg-config autoconf automake-wrapper \
    git make patch rsync zip || exit 1

./run-depends.sh
