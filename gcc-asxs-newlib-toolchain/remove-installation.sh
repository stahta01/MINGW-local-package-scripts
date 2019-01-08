# import custom-settings.sh file
  source custom-settings.sh


  rm -fr "${MINGW_INSTALL_PREFIX}/${_target}"
  rm -f  "${MINGW_INSTALL_PREFIX}/man/man1/${_target}-*"
  rm -f  "${MINGW_INSTALL_PREFIX}/bin/${_target}-*"
