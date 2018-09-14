# import library settings file
  source library-settings.sh

  cd ${_LIBRARY_REPO} || exit 1

  cd ${_LIBRARY_BUILD_DIR} || exit 2

  make clean
