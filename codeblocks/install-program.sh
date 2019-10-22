####
#
####

# import program settings file
  source program-settings.sh

  cd ${_PROGRAM_REPO}

  make install --jobs=1

  # Rename files
  mv -f ${_PROGRAM_PREFIX}/bin/${MINGW_CHOST}-cb_console_runner.exe ${_PROGRAM_PREFIX}/bin/cb_console_runner.exe
  mv -f ${_PROGRAM_PREFIX}/bin/${MINGW_CHOST}-cb_share_config.exe   ${_PROGRAM_PREFIX}/bin/cb_share_config.exe

  # Move files
  mv -f ${_PROGRAM_PREFIX}/lib/codeblocks/bin/*.dll ${_PROGRAM_PREFIX}/bin/
